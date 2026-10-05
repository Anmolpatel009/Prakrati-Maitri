import { NextResponse } from "next/server";
import { createClient as createServiceRoleClient } from "@supabase/supabase-js";
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

    const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
    const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;

    if (!supabaseUrl || !serviceRoleKey) {
      return NextResponse.json(
        { error: "Payment verification service is not configured." },
        { status: 500 }
      );
    }

    const adminSupabase = createServiceRoleClient(
      supabaseUrl,
      serviceRoleKey,
      {
        auth: {
          autoRefreshToken: false,
          persistSession: false,
        },
      }
    );

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

    const orderClient = user ? supabase : adminSupabase;

    let orderQuery = orderClient
      .from("orders")
      .select(
        "id,total,status,payment_status,payment_method,razorpay_order_id"
      )
      .eq("razorpay_order_id", razorpayOrderId);

    if (user) {
      orderQuery = orderQuery.eq("user_id", user.id);
    }

    const { data: order, error: orderError } =
      await orderQuery.single();

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

    const { data: updatedOrder, error: updateError } = await adminSupabase
      .from("orders")
      .update({
        status: "confirmed",
        payment_status: "paid",
        payment_id: razorpayPaymentId,
        updated_at: new Date().toISOString(),
      })
      .eq("id", order.id)
      .eq("payment_method", "online")
      .eq("payment_status", "pending")
      .select("id")
      .maybeSingle();

    if (updateError || !updatedOrder) {
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
