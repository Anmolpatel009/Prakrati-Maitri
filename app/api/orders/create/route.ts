import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

type PaymentMethod = "cod" | "online";

export async function POST(request: Request) {
  try {
    const supabase = await createClient();

    // =====================================================
    // AUTHENTICATION
    // =====================================================

    const {
      data: { user },
      error: userError,
    } = await supabase.auth.getUser();

    if (userError || !user) {
      return NextResponse.json(
        {
          error: "You must be logged in to place an order.",
        },
        { status: 401 }
      );
    }

    // =====================================================
    // REQUEST BODY
    // =====================================================

    const body = await request.json();

    const {
      items,
      shipping,
      paymentMethod,
    } = body;

    // =====================================================
    // CART VALIDATION
    // =====================================================

    if (!Array.isArray(items) || items.length === 0) {
      return NextResponse.json(
        {
          error: "Cart is empty.",
        },
        { status: 400 }
      );
    }

    // =====================================================
    // SHIPPING VALIDATION
    // =====================================================

    if (!shipping || typeof shipping !== "object") {
      return NextResponse.json(
        {
          error: "Shipping information is required.",
        },
        { status: 400 }
      );
    }

    // =====================================================
    // PAYMENT METHOD VALIDATION
    // =====================================================

    if (
      paymentMethod !== "cod" &&
      paymentMethod !== "online"
    ) {
      return NextResponse.json(
        {
          error:
            "Invalid payment method. Choose Cash on Delivery or Online Payment.",
        },
        { status: 400 }
      );
    }

    // =====================================================
    // CREATE ORDER
    // =====================================================

    const {
      data: orderId,
      error: orderError,
    } = await supabase.rpc(
      "create_order_with_payment",
      {
        p_items: items,
        p_shipping: shipping,
        p_payment_method: paymentMethod as PaymentMethod,
      }
    );

    if (orderError) {
      console.error(
        "Order creation error:",
        orderError
      );

      return NextResponse.json(
        {
          error: orderError.message,
        },
        { status: 400 }
      );
    }

    if (!orderId) {
      console.error(
        "Order creation returned no order ID."
      );

      return NextResponse.json(
        {
          error:
            "Order could not be created. No order ID was returned.",
        },
        { status: 500 }
      );
    }

    // =====================================================
    // SUCCESS
    // =====================================================

    return NextResponse.json({
      success: true,
      orderId,
      paymentMethod,
    });
  } catch (error) {
    console.error(
      "Unexpected order creation error:",
      error
    );

    return NextResponse.json(
      {
        error:
          "Something went wrong while creating the order.",
      },
      { status: 500 }
    );
  }
}