import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

const allowedGuestRanges = new Set(["50–100", "100–300", "300–700", "700+"]);
const allowedGiftChoices = new Set([
  "Jute hamper bag",
  "Potli bag",
  "Saree cover",
  "Printed jute tote",
  "Help me choose",
]);

function isValidDate(value: string): boolean {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(value)) return false;
  const parsed = new Date(`${value}T00:00:00.000Z`);
  return !Number.isNaN(parsed.getTime()) && parsed.toISOString().slice(0, 10) === value;
}

export async function POST(request: Request) {
  try {
    const body: unknown = await request.json();
    if (!body || typeof body !== "object" || Array.isArray(body)) {
      return NextResponse.json({ error: "Invalid enquiry details." }, { status: 400 });
    }

    const data = body as Record<string, unknown>;
    const brideName = typeof data.brideName === "string" ? data.brideName.trim() : "";
    const groomName = typeof data.groomName === "string" ? data.groomName.trim() : "";
    const weddingDate = typeof data.weddingDate === "string" ? data.weddingDate.trim() : "";
    const guestRange = typeof data.guestRange === "string" ? data.guestRange : "";
    const giftChoice = typeof data.giftChoice === "string" ? data.giftChoice : "";

    if (!brideName || brideName.length > 24 || !groomName || groomName.length > 24) {
      return NextResponse.json(
        { error: "Please enter both names (up to 24 characters each)." },
        { status: 400 },
      );
    }
    if (weddingDate && !isValidDate(weddingDate)) {
      return NextResponse.json({ error: "Please enter a valid wedding date." }, { status: 400 });
    }
    if (!allowedGuestRanges.has(guestRange)) {
      return NextResponse.json({ error: "Please select a valid guest range." }, { status: 400 });
    }
    if (!allowedGiftChoices.has(giftChoice)) {
      return NextResponse.json({ error: "Please select a valid return gift." }, { status: 400 });
    }

    const supabase = await createClient();
    // The migration is applied separately; the cast keeps generated database types
    // from blocking this new table before the project's types are regenerated.
    const db = supabase as any;
    const { error } = await db.from("wedding_return_gift_enquiries").insert({
      bride_name: brideName,
      groom_name: groomName,
      wedding_date: weddingDate || null,
      guest_range: guestRange,
      gift_choice: giftChoice,
    });

    if (error) {
      console.error("Wedding return-gift enquiry insert error:", error);
      return NextResponse.json(
        { error: "Unable to save your enquiry right now. Please try again." },
        { status: 500 },
      );
    }

    return NextResponse.json({ success: true }, { status: 201 });
  } catch (error) {
    console.error("Wedding return-gift enquiry API error:", error);
    return NextResponse.json({ error: "Invalid request." }, { status: 400 });
  }
}