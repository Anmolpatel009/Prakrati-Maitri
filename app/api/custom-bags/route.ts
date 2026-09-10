import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

const ALLOWED_BAG_TYPES = [
  "Tote Bag",
  "Jute Bag",
  "Cotton Bag",
  "Drawstring Bag",
  "Gift / Hamper Bag",
  "Packaging Bag",
  "Other Custom Bag",
];

const ALLOWED_PRICE_RANGES = [
  "₹50 – ₹100",
  "₹100 – ₹200",
  "₹200 – ₹500",
  "₹500 – ₹1,000",
  "₹1,000+",
  "Not sure yet",
];

export async function POST(request: Request) {
  try {
    const body = await request.json();

    const mobile = String(body.mobile ?? "").trim();
    const bagType = String(body.bagType ?? "").trim();
    const description = String(body.description ?? "").trim();
    const referenceImageUrl =
      String(body.referenceImageUrl ?? "").trim() || null;
    const expectedPriceRange =
      String(body.expectedPriceRange ?? "").trim() || null;

    const normalizedMobile = mobile.replace(/\D/g, "");

    if (normalizedMobile.length < 10 || normalizedMobile.length > 15) {
      return NextResponse.json(
        { error: "Please enter a valid contact number." },
        { status: 400 }
      );
    }

    if (!ALLOWED_BAG_TYPES.includes(bagType)) {
      return NextResponse.json(
        { error: "Please select a valid bag type." },
        { status: 400 }
      );
    }

    if (description.length < 10) {
      return NextResponse.json(
        { error: "Please describe the custom bag you have in mind." },
        { status: 400 }
      );
    }

    if (
      expectedPriceRange &&
      !ALLOWED_PRICE_RANGES.includes(expectedPriceRange)
    ) {
      return NextResponse.json(
        { error: "Please select a valid price range." },
        { status: 400 }
      );
    }

    if (
      referenceImageUrl &&
      !referenceImageUrl.includes(
        "/storage/v1/object/public/custom-bag-references/"
      )
    ) {
      return NextResponse.json(
        { error: "Invalid reference image." },
        { status: 400 }
      );
    }

    const supabase = await createClient();

    const { error } = await supabase
      .from("custom_bag_requests")
      .insert({
        mobile: normalizedMobile,
        bag_type: bagType,
        description,
        reference_image_url: referenceImageUrl,
        expected_price_range: expectedPriceRange,
      });

    if (error) {
      console.error("Custom bag request insert error:", error);

      return NextResponse.json(
        { error: "Unable to submit your request right now." },
        { status: 500 }
      );
    }

    return NextResponse.json({ success: true });
  } catch (error) {
    console.error("Custom bag API error:", error);

    return NextResponse.json(
      { error: "Invalid request." },
      { status: 400 }
    );
  }
}
