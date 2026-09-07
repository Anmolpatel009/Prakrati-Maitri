import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

export async function POST(request: Request) {
  try {
    const body = await request.json();

    const name = String(body.name ?? "").trim();
    const mobile = String(body.mobile ?? "").trim();
    const email = String(body.email ?? "").trim() || null;
    const businessName =
      String(body.businessName ?? "").trim() || null;
    const categoryId =
      String(body.categoryId ?? "").trim() || null;
    const productId =
      String(body.productId ?? "").trim() || null;
    const quantity = Number(body.quantity);
    const purpose = String(body.purpose ?? "").trim();
    const message =
      String(body.message ?? "").trim() || null;

    if (!name) {
      return NextResponse.json(
        { error: "Name is required." },
        { status: 400 }
      );
    }

    if (mobile.replace(/\D/g, "").length < 10) {
      return NextResponse.json(
        { error: "A valid mobile number is required." },
        { status: 400 }
      );
    }

    if (!Number.isInteger(quantity) || quantity <= 0) {
      return NextResponse.json(
        { error: "A valid quantity is required." },
        { status: 400 }
      );
    }

    if (!categoryId && !productId) {
      return NextResponse.json(
        { error: "Please select a category or product." },
        { status: 400 }
      );
    }

    if (!purpose) {
      return NextResponse.json(
        { error: "Purpose of purchase is required." },
        { status: 400 }
      );
    }

    const supabase = await createClient();

    const { error } = await supabase
      .from("bulk_order_enquiries")
      .insert({
        name,
        mobile,
        email,
        business_name: businessName,
        category_id: categoryId,
        product_id: productId,
        quantity,
        purpose,
        message,
      });

    if (error) {
      console.error("Bulk enquiry insert error:", error);

      return NextResponse.json(
        { error: "Unable to submit your enquiry right now." },
        { status: 500 }
      );
    }

    return NextResponse.json({ success: true });
  } catch (error) {
    console.error("Bulk enquiry API error:", error);

    return NextResponse.json(
      { error: "Invalid request." },
      { status: 400 }
    );
  }
}
