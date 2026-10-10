import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const items = body?.items;
    const promoCode = typeof body?.promoCode === "string" ? body.promoCode.trim().toUpperCase() : null;
    if (!Array.isArray(items) || items.length === 0) {
      return NextResponse.json({ error: "Cart is empty." }, { status: 400 });
    }
    const supabase = await createClient();
    const { data, error } = await supabase.rpc("calculate_checkout_pricing", {
      p_items: items,
      p_promo_code: promoCode,
    });
    if (error) {
      console.error("Checkout pricing error:", error.message);
      return NextResponse.json({ error: error.message || "Unable to calculate checkout pricing." }, { status: 400 });
    }
    return NextResponse.json({ success: true, pricing: data });
  } catch (error) {
    console.error("Checkout pricing failed:", error);
    return NextResponse.json({ error: "Unable to calculate checkout pricing." }, { status: 500 });
  }
}