import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

export async function POST(request: Request) {
  try {
    const supabase = await createClient();

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

    const body = await request.json();

    const { items, shipping } = body;

    if (!Array.isArray(items) || items.length === 0) {
      return NextResponse.json(
        {
          error: "Cart is empty.",
        },
        { status: 400 }
      );
    }

    if (!shipping) {
      return NextResponse.json(
        {
          error: "Shipping information is required.",
        },
        { status: 400 }
      );
    }

    const { data: orderId, error } = await supabase.rpc(
      "create_order",
      {
        p_items: items,
        p_shipping: shipping,
      }
    );

    if (error) {
      console.error("Order creation error:", error);

      return NextResponse.json(
        {
          error: error.message,
        },
        { status: 400 }
      );
    }

    return NextResponse.json({
      success: true,
      orderId,
    });
  } catch (error) {
    console.error("Unexpected order creation error:", error);

    return NextResponse.json(
      {
        error: "Something went wrong while creating the order.",
      },
      { status: 500 }
    );
  }
}