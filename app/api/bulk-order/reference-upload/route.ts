import { NextResponse } from "next/server";
import { createClient as createServiceRoleClient } from "@supabase/supabase-js";

const BUCKET = "bulk-order-references";
const MAX_FILE_SIZE = 5 * 1024 * 1024;

const EXTENSION_BY_TYPE: Record<string, string> = {
  "image/jpeg": "jpg",
  "image/png": "png",
  "image/webp": "webp",
};

export async function POST(request: Request) {
  try {
    const body = await request.json();

    const contentType = String(body.contentType ?? "").trim();
    const size = Number(body.size);

    if (!EXTENSION_BY_TYPE[contentType]) {
      return NextResponse.json(
        { error: "Reference image must be JPG, PNG or WebP." },
        { status: 400 }
      );
    }

    if (
      !Number.isFinite(size) ||
      size <= 0 ||
      size > MAX_FILE_SIZE
    ) {
      return NextResponse.json(
        { error: "Reference image must be smaller than 5MB." },
        { status: 400 }
      );
    }

    const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
    const serviceRoleKey =
      process.env.SUPABASE_SERVICE_ROLE_KEY;

    if (!supabaseUrl || !serviceRoleKey) {
      console.error(
        "Reference upload initialization failed: service-role credentials are not configured."
      );

      return NextResponse.json(
        { error: "Unable to upload reference image right now." },
        { status: 500 }
      );
    }

    const supabase = createServiceRoleClient(
      supabaseUrl,
      serviceRoleKey,
      {
        auth: {
          autoRefreshToken: false,
          persistSession: false,
        },
      }
    );

    const extension = EXTENSION_BY_TYPE[contentType];
    const path =
      `enquiries/${crypto.randomUUID()}.${extension}`;

    const { data, error } = await supabase.storage
      .from(BUCKET)
      .createSignedUploadUrl(path);

    if (error || !data?.token) {
      console.error(
        "Reference upload signed URL error:",
        error
      );

      return NextResponse.json(
        { error: "Unable to prepare reference image upload." },
        { status: 500 }
      );
    }

    return NextResponse.json({
      path,
      token: data.token,
    });
  } catch (error) {
    console.error(
      "Reference upload initialization error:",
      error
    );

    return NextResponse.json(
      { error: "Invalid request." },
      { status: 400 }
    );
  }
}
