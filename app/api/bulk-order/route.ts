import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createClient as createServiceRoleClient } from "@supabase/supabase-js";

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
    const allowedPlanningOptions = new Set([
      "Tote Bags",
      "Printed Tote Bags",
      "Conference Bags & Kits",
      "Customize Bags",
      "Hamper Bags",
      "Hand Bags",
      "Packaging Bags",
    ]);

    const selectedPlanning: string[] = Array.isArray(body.selectedPlanning)
      ? Array.from(
          new Set(
            body.selectedPlanning.filter(
              (option: unknown): option is string =>
                typeof option === "string" &&
                allowedPlanningOptions.has(option)
            )
          )
        )
      : [];

    const purpose =
      String(body.purpose ?? "").trim() ||
      (selectedPlanning.length > 0 ? "Other" : "");

    const submittedMessage = String(body.message ?? "").trim();
    const planningMessage = selectedPlanning.length
      ? `Selected product interests: ${selectedPlanning.join(", ")}`
      : "";

    const message =
      [submittedMessage, planningMessage].filter(Boolean).join("\n\n") || null;
    const bagSize =
      String(body.bagSize ?? "").trim() || null;
    const deliveryPincode =
      String(body.deliveryPincode ?? "").trim() || null;
    const deliveryTimeline =
      String(body.deliveryTimeline ?? "").trim() || null;

    const referenceImagePath =
      typeof body.referenceImagePath === "string" &&
      body.referenceImagePath.trim()
        ? body.referenceImagePath.trim()
        : null;

    if (referenceImagePath) {
      const validPath =
        /^bulk-orders\/[0-9a-f-]{36}\.(jpg|png|webp)$/i.test(
          referenceImagePath
        );

      if (!validPath) {
        return NextResponse.json(
          { error: "Invalid reference image." },
          { status: 400 }
        );
      }
    }

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

    if (!categoryId && !productId && selectedPlanning.length === 0) {
      return NextResponse.json(
        { error: "Please select a product type, category, or product." },
        { status: 400 }
      );
    }

    if (!purpose) {
      return NextResponse.json(
        { error: "Purpose of purchase is required." },
        { status: 400 }
      );
    }

    if (
      deliveryPincode &&
      !/^\d{6}$/.test(deliveryPincode)
    ) {
      return NextResponse.json(
        { error: "A valid 6-digit delivery pincode is required." },
        { status: 400 }
      );
    }

    const allowedTimelines = new Set([
      "urgent",
      "within_7_days",
      "within_15_days",
      "flexible",
    ]);

    if (
      deliveryTimeline &&
      !allowedTimelines.has(deliveryTimeline)
    ) {
      return NextResponse.json(
        { error: "Invalid delivery timeline." },
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
        bag_size: bagSize,
        delivery_pincode: deliveryPincode,
        delivery_timeline: deliveryTimeline,
        reference_image_path: referenceImagePath,
      });

    if (error) {
      console.error("Bulk enquiry insert error:", error);

      if (referenceImagePath) {
        const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
        const serviceRoleKey =
          process.env.SUPABASE_SERVICE_ROLE_KEY;

        if (supabaseUrl && serviceRoleKey) {
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

          const { error: cleanupError } =
            await adminSupabase.storage
              .from("custom-bag-references")
              .remove([referenceImagePath]);

          if (cleanupError) {
            console.error(
              "Bulk enquiry reference image cleanup error:",
              cleanupError
            );
          }
        }
      }

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
