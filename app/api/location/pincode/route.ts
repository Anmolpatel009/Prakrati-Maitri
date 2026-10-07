import { NextResponse } from "next/server";

type PincodeOffice = {
  office_name?: string;
  district?: string;
  state?: string;
  country?: string;
  delivery_status?: string;
};

type PincodeResponse = {
  success?: boolean;
  data?: {
    pincode?: string;
    post_offices?: PincodeOffice[];
  };
};

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const value = (searchParams.get("pincode") || "").trim();

  if (!/^\d{6}$/.test(value)) {
    return NextResponse.json(
      {
        success: false,
        error: "Please enter a valid 6-digit PIN code.",
      },
      { status: 400 }
    );
  }

  try {
    const response = await fetch(
      `https://api.pincodeapi.in/api/v1/pincode/${value}`,
      {
        next: {
          revalidate: 86400,
        },
        headers: {
          Accept: "application/json",
        },
      }
    );

    if (!response.ok) {
      throw new Error(
        `PIN service returned HTTP ${response.status}`
      );
    }

    const payload =
      (await response.json()) as PincodeResponse;

    const offices = payload.data?.post_offices || [];

    if (!payload.success || offices.length === 0) {
      return NextResponse.json(
        {
          success: false,
          error: "We could not find this PIN code.",
        },
        { status: 404 }
      );
    }

    const deliveryOffice =
      offices.find(
        (office) =>
          office.delivery_status?.toLowerCase() ===
          "delivery"
      ) || offices[0];

    return NextResponse.json({
      success: true,
      city: deliveryOffice.district || "",
      state: deliveryOffice.state || "",
      country: deliveryOffice.country || "India",
      pincode: value,
    });
  } catch (error) {
    console.error("PIN code lookup failed:", error);

    return NextResponse.json(
      {
        success: false,
        error: "Unable to look up this PIN code right now.",
      },
      { status: 502 }
    );
  }
}
