import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import {
  generateInvoicePdf,
  type InvoiceOrder,
} from "@/lib/invoice/generate-invoice-pdf";

export const runtime = "nodejs";

type Params = {
  params: Promise<{ id: string }>;
};

export async function GET(
  _request: Request,
  { params }: Params,
) {
  try {
    const { id } = await params;

    if (!id) {
      return NextResponse.json(
        { error: "Order ID is required." },
        { status: 400 },
      );
    }

    const supabase = await createClient();

    const {
      data: { user },
    } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json(
        { error: "You must be logged in to download an invoice." },
        { status: 401 },
      );
    }

    const { data: order, error } = await supabase
      .from("orders")
      .select(`
        id,
        created_at,
        subtotal,
        shipping_fee,
        total,
        shipping_first_name,
        shipping_last_name,
        shipping_phone,
        shipping_address,
        shipping_city,
        shipping_state,
        shipping_country,
        shipping_postal_code,
        order_items (
          product_name,
          product_sku,
          quantity,
          unit_price,
          line_total
        )
      `)
      .eq("id", id)
      .eq("user_id", user.id)
      .single();

    if (error || !order) {
      return NextResponse.json(
        { error: "Order not found." },
        { status: 404 },
      );
    }

    const pdf = await generateInvoicePdf(
      order as InvoiceOrder,
      user.email,
    );

    return new NextResponse(new Uint8Array(pdf), {
      status: 200,
      headers: {
        "Content-Type": "application/pdf",
        "Content-Disposition": `attachment; filename="Prakriti-Maitri-Invoice-${id.slice(0, 8).toUpperCase()}.pdf"`,
        "Cache-Control": "private, no-store, max-age=0",
      },
    });
  } catch (error) {
    console.error("Invoice generation error:", error);

    return NextResponse.json(
      { error: "Unable to generate invoice." },
      { status: 500 },
    );
  }
}
