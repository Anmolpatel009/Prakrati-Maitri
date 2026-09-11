import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import {
  fetchRazorpayPayment,
  verifyRazorpaySignature,
} from "@/lib/payments/razorpay";

export async function POST(request: Request) {
  try {
    const supabase = await createClient();

    const {
      data: { user },
    } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json(
        { error: "You must be logged in." },
        { status: 401 }
      );
    }

    const body = await request.json();

    const razorpayPaymentId = String(body?.razorpay_payment_id || "");
    const razorpayOrderId = String(body?.razorpay_order_id || "");
    const razorpaySignature = String(body?.razorpay_signature || "");

    if (
      !razorpayPaymentId ||
      !razorpayOrderId ||
      !razorpaySignature
    ) {
      return NextResponse.json(
        { error: "Incomplete Razorpay payment response." },
        { status: 400 }
      );
    }

    const { data: order, error: orderError } = await supabase
      .from("orders")
      .select(
        "id,total,status,payment_status,payment_method,razorpay_order_id"
      )
      .eq("user_id", user.id)
      .eq("razorpay_order_id", razorpayOrderId)
      .single();

    if (orderError || !order) {
      return NextResponse.json(
        { error: "Payment order was not found." },
        { status: 404 }
      );
    }

    if (order.payment_method !== "online") {
      return NextResponse.json(
        { error: "Invalid payment method." },
        { status: 400 }
      );
    }

    if (order.payment_status === "paid") {
      return NextResponse.json({
        success: true,
        orderId: order.id,
        alreadyProcessed: true,
      });
    }

    if (
      !verifyRazorpaySignature({
        orderId: razorpayOrderId,
        paymentId: razorpayPaymentId,
        signature: razorpaySignature,
      })
    ) {
      return NextResponse.json(
        { error: "Invalid payment signature." },
        { status: 400 }
      );
    }

    const payment = await fetchRazorpayPayment(razorpayPaymentId);
    const expectedAmount = Math.round(Number(order.total) * 100);

    if (
      Number(payment.amount) !== expectedAmount ||
      payment.currency !== "INR" ||
      payment.order_id !== razorpayOrderId
    ) {
      return NextResponse.json(
        { error: "Payment amount or order mismatch." },
        { status: 400 }
      );
    }

    if (payment.status !== "captured") {
      return NextResponse.json(
        {
          error: `Payment is not captured. Current status: ${payment.status}`,
        },
        { status: 400 }
      );
    }

    const { error: updateError } = await supabase
      .from("orders")
      .update({
        status: "confirmed",
        payment_status: "paid",
        payment_id: razorpayPaymentId,
        updated_at: new Date().toISOString(),
      })
      .eq("id", order.id)
      .eq("user_id", user.id)
      .eq("payment_status", "pending");

    if (updateError) {
      console.error("Payment confirmation update failed:", updateError);

      return NextResponse.json(
        { error: "Payment verified but order confirmation failed." },
        { status: 500 }
      );
    }

    return NextResponse.json({
      success: true,
      orderId: order.id,
    });
  } catch (error) {
    console.error("Razorpay verification error:", error);

    return NextResponse.json(
      { error: "Payment verification failed." },
      { status: 500 }
    );
  }
}
