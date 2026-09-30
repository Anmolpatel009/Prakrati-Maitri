import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

const ALLOWED_TYPES = [
  "image/jpeg",
  "image/png",
  "image/webp",
];

const MAX_FILE_SIZE = 5 * 1024 * 1024;

export async function POST(request: Request) {
  try {
    const contentType =
      request.headers.get("content-type") || "";
    const filePath =
      request.headers.get("x-file-path") || "";

    if (!ALLOWED_TYPES.includes(contentType)) {
      return NextResponse.json(
        {
          error:
            "Only JPG, PNG and WebP images are allowed.",
        },
        { status: 400 }
      );
    }

    if (!filePath.startsWith("bulk-orders/")) {
      return NextResponse.json(
        { error: "Invalid upload path." },
        { status: 400 }
      );
    }

    const file = await request.arrayBuffer();

    if (file.byteLength === 0) {
      return NextResponse.json(
        { error: "Reference image is empty." },
        { status: 400 }
      );
    }

    if (file.byteLength > MAX_FILE_SIZE) {
      return NextResponse.json(
        {
          error:
            "Reference image must be smaller than 5MB.",
        },
        { status: 400 }
      );
    }

    const supabase = await createClient();

    const { error } = await supabase.storage
      .from("custom-bag-references")
      .upload(filePath, file, {
        contentType,
        upsert: false,
      });

    if (error) {
      console.error(
        "Bulk reference image upload error:",
        error
      );

      return NextResponse.json(
        {
          error:
            "Unable to upload reference image.",
        },
        { status: 500 }
      );
    }

    const {
      data: { publicUrl },
    } = supabase.storage
      .from("custom-bag-references")
      .getPublicUrl(filePath);

    return NextResponse.json({
      success: true,
      path: filePath,
      url: publicUrl,
    });
  } catch (error) {
    console.error(
      "Bulk reference upload API error:",
      error
    );

    return NextResponse.json(
      {
        error:
          "Unable to upload reference image.",
      },
      { status: 500 }
    );
  }
}
