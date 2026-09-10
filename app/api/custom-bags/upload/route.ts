import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

const ALLOWED_TYPES = [
  "image/jpeg",
  "image/png",
  "image/webp",
];

export async function POST(request: Request) {
  try {
    const contentType = request.headers.get("content-type") || "";
    const filePath = request.headers.get("x-file-path") || "";

    if (!ALLOWED_TYPES.includes(contentType)) {
      return NextResponse.json(
        { error: "Only JPG, PNG and WebP images are allowed." },
        { status: 400 }
      );
    }

    if (!filePath.startsWith("custom-bags/")) {
      return NextResponse.json(
        { error: "Invalid upload path." },
        { status: 400 }
      );
    }

    const file = await request.arrayBuffer();

    if (file.byteLength > 5 * 1024 * 1024) {
      return NextResponse.json(
        { error: "Reference image must be smaller than 5MB." },
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
      console.error("Custom bag image upload error:", error);

      return NextResponse.json(
        { error: "Unable to upload reference image." },
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
      url: publicUrl,
    });
  } catch (error) {
    console.error("Custom bag upload API error:", error);

    return NextResponse.json(
      { error: "Unable to upload reference image." },
      { status: 500 }
    );
  }
}
