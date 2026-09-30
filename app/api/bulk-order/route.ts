import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createClient as createServiceRoleClient } from "@supabase/supabase-js";

export async function POST(request: Request) {
  try {
    const formData = await request.formData();

    const name = String(formData.get("name") ?? "").trim();
    const mobile = String(formData.get("mobile") ?? "").trim();
    const email = String(formData.get("email") ?? "").trim() || null;
    const businessName =
      String(formData.get("businessName") ?? "").trim() || null;
    const categoryId =
      String(formData.get("categoryId") ?? "").trim() || null;
    const productId =
      String(formData.get("productId") ?? "").trim() || null;
    const quantity = Number(formData.get("quantity"));
    const purpose = String(formData.get("purpose") ?? "").trim();
    const message =
      String(formData.get("message") ?? "").trim() || null;

    const referenceImageEntry = formData.get("referenceImage");
    const referenceImage =
      referenceImageEntry instanceof File &&
      referenceImageEntry.size > 0
        ? referenceImageEntry
        : null;

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

    if (referenceImage) {
      const allowedTypes = [
        "image/jpeg",
        "image/png",
        "image/webp",
      ];

      if (!allowedTypes.includes(referenceImage.type)) {
        return NextResponse.json(
          { error: "Reference image must be JPG, PNG or WebP." },
          { status: 400 }
        );
      }

      if (referenceImage.size > 5 * 1024 * 1024) {
        return NextResponse.json(
          { error: "Reference image must be smaller than 5MB." },
          { status: 400 }
        );
      }
    }

    const supabase = await createClient();

    let referenceImagePath: string | null = null;

    if (referenceImage) {
      const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
      const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

      if (!supabaseUrl || !serviceRoleKey) {
        console.error(
          "Bulk enquiry image upload failed: service-role credentials are not configured."
        );

        return NextResponse.json(
          { error: "Unable to upload reference image right now." },
          { status: 500 }
        );
      }

      const extensionByType: Record<string, string> = {
        "image/jpeg": "jpg",
        "image/png": "png",
        "image/webp": "webp",
      };

      const extension = extensionByType[referenceImage.type];

      referenceImagePath =
        `enquiries/${crypto.randomUUID()}.${extension}`;

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

      const { error: uploadError } =
        await adminSupabase.storage
          .from("bulk-order-references")
          .upload(
            referenceImagePath,
            await referenceImage.arrayBuffer(),
            {
              contentType: referenceImage.type,
              upsert: false,
            }
          );

      if (uploadError) {
        console.error(
          "Bulk enquiry reference image upload error:",
          uploadError
        );

        return NextResponse.json(
          { error: "Unable to upload reference image right now." },
          { status: 500 }
        );
      }
    }

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
        reference_image_path: referenceImagePath,
      });

    if (error) {
      console.error("Bulk enquiry insert error:", error);

      if (referenceImagePath) {
        const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
        const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

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

          await adminSupabase.storage
            .from("bulk-order-references")
            .remove([referenceImagePath]);
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
