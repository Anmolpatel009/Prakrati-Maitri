import { NextResponse } from "next/server";
import { createRazorpayOrder } from "@/lib/payments/razorpay";
import { createClient } from "@/lib/supabase/server";

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
    const items = body?.items;
    const shipping = body?.shipping;

    if (!Array.isArray(items) || items.length === 0) {
      return NextResponse.json({ error: "Cart is empty." }, { status: 400 });
    }

    if (!shipping || typeof shipping !== "object") {
      return NextResponse.json(
        { error: "Shipping information is required." },
        { status: 400 }
      );
    }

    const { data: orderId, error: rpcError } = await supabase.rpc(
      "create_order_with_payment",
      {
        p_items: items,
        p_shipping: shipping,
        p_payment_method: "online",
      }
    );

    if (rpcError || !orderId) {
      return NextResponse.json(
        { error: rpcError?.message || "Unable to create order." },
        { status: 400 }
      );
    }

    const { data: order, error: orderError } = await supabase
      .from("orders")
      .select("id, total, payment_status, status")
      .eq("id", orderId)
      .eq("user_id", user.id)
      .single();

    if (orderError || !order) {
      return NextResponse.json(
        { error: "Created order could not be loaded." },
        { status: 500 }
      );
    }

    const amountInPaise = Math.round(Number(order.total) * 100);

    if (!Number.isSafeInteger(amountInPaise) || amountInPaise <= 0) {
      return NextResponse.json(
        { error: "Invalid order amount." },
        { status: 500 }
      );
    }

    let razorpayOrder;

    try {
      razorpayOrder = await createRazorpayOrder({
        amountInPaise,
        localOrderId: order.id,
      });
    } catch (error) {
      await supabase.rpc("cancel_pending_online_order", {
        p_order_id: order.id,
        p_reason:
          error instanceof Error
            ? error.message
            : "Razorpay order creation failed.",
      });

      throw error;
    }

    const { error: updateError } = await supabase
      .from("orders")
      .update({
        razorpay_order_id: razorpayOrder.id,
        updated_at: new Date().toISOString(),
      })
      .eq("id", order.id)
      .eq("user_id", user.id)
      .eq("status", "pending")
      .eq("payment_method", "online");

    if (updateError) {
      await supabase.rpc("cancel_pending_online_order", {
        p_order_id: order.id,
        p_reason: "Could not save Razorpay order ID.",
      });

      return NextResponse.json(
        { error: "Could not initialize payment." },
        { status: 500 }
      );
    }

    return NextResponse.json({
      orderId: order.id,
      razorpayOrderId: razorpayOrder.id,
      amount: razorpayOrder.amount,
      currency: razorpayOrder.currency,
      keyId: process.env.NEXT_PUBLIC_RAZORPAY_KEY_ID,
    });
  } catch (error) {
    console.error("Razorpay create order error:", error);

    return NextResponse.json(
      {
        error:
          error instanceof Error
            ? error.message
            : "Unable to initialize payment.",
      },
      { status: 500 }
    );
  }
}
