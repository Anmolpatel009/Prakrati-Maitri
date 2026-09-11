import { NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";
import {
  fetchRazorpayPayment,
  verifyRazorpayWebhookSignature,
} from "@/lib/payments/razorpay";

function getServiceRoleClient() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

  if (!url || !serviceRoleKey) {
    throw new Error("Supabase service-role credentials are not configured.");
  }

  return createClient(url, serviceRoleKey, {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
    },
  });
}

export async function POST(request: Request) {
  try {
    const rawBody = await request.text();

    const signature = request.headers.get("x-razorpay-signature");
    const eventId = request.headers.get("x-razorpay-event-id");

    if (!signature || !eventId) {
      return NextResponse.json(
        { error: "Missing Razorpay webhook headers." },
        { status: 400 }
      );
    }

    if (!verifyRazorpayWebhookSignature(rawBody, signature)) {
      return NextResponse.json(
        { error: "Invalid webhook signature." },
        { status: 400 }
      );
    }

    let payload: {
      event?: string;
      payload?: {
        payment?: {
          entity?: {
            id?: string;
            order_id?: string;
            status?: string;
            amount?: number;
            currency?: string;
            error_description?: string;
            error_reason?: string;
          };
        };
        order?: {
          entity?: {
            id?: string;
          };
        };
      };
    };

    try {
      payload = JSON.parse(rawBody);
    } catch {
      return NextResponse.json(
        { error: "Invalid webhook payload." },
        { status: 400 }
      );
    }

    const eventType = String(payload.event || "");

    const paymentEntity = payload.payload?.payment?.entity;
    const orderEntity = payload.payload?.order?.entity;

    const razorpayOrderId = String(
      paymentEntity?.order_id || orderEntity?.id || ""
    );

    if (!razorpayOrderId) {
      return NextResponse.json({
        success: true,
        ignored: true,
      });
    }

    const supabase = getServiceRoleClient();

    // Razorpay can retry webhook deliveries.
    // Recording the event ID makes processing idempotent.
    const { error: eventInsertError } = await supabase
      .from("razorpay_webhook_events")
      .insert({
        event_id: eventId,
        event_type: eventType,
      });

    if (eventInsertError?.code === "23505") {
      return NextResponse.json({
        success: true,
        duplicate: true,
      });
    }

    if (eventInsertError) {
      console.error("Webhook event insert failed:", eventInsertError);

      return NextResponse.json(
        { error: "Unable to record webhook event." },
        { status: 500 }
      );
    }

    const { data: order, error: orderError } = await supabase
      .from("orders")
      .select(
        "id,total,status,payment_status,payment_method,razorpay_order_id"
      )
      .eq("razorpay_order_id", razorpayOrderId)
      .maybeSingle();

    if (orderError) {
      console.error("Webhook order lookup failed:", orderError);

      return NextResponse.json(
        { error: "Unable to lookup order." },
        { status: 500 }
      );
    }

    if (!order) {
      return NextResponse.json({
        success: true,
        ignored: true,
      });
    }

    if (order.payment_method !== "online") {
      return NextResponse.json({
        success: true,
        ignored: true,
      });
    }

    // payment.captured is our authoritative successful-payment webhook.
    if (eventType === "payment.captured") {
      const paymentId = String(paymentEntity?.id || "");

      if (!paymentId) {
        return NextResponse.json(
          { error: "Captured event has no payment ID." },
          { status: 400 }
        );
      }

      const payment = await fetchRazorpayPayment(paymentId);
      const expectedAmount = Math.round(Number(order.total) * 100);

      if (
        payment.status !== "captured" ||
        Number(payment.amount) !== expectedAmount ||
        payment.currency !== "INR" ||
        payment.order_id !== razorpayOrderId
      ) {
        console.error("Webhook payment mismatch:", {
          localOrderId: order.id,
          expectedAmount,
          razorpayOrderId,
          paymentId,
          paymentStatus: payment.status,
          paymentAmount: payment.amount,
          paymentCurrency: payment.currency,
          paymentOrderId: payment.order_id,
        });

        return NextResponse.json(
          { error: "Payment verification mismatch." },
          { status: 400 }
        );
      }

      if (order.payment_status !== "paid") {
        const { error: updateError } = await supabase
          .from("orders")
          .update({
            status: "confirmed",
            payment_status: "paid",
            payment_id: paymentId,
            updated_at: new Date().toISOString(),
          })
          .eq("id", order.id)
          .eq("payment_method", "online")
          .neq("payment_status", "paid");

        if (updateError) {
          console.error("Webhook order update failed:", updateError);

          return NextResponse.json(
            { error: "Unable to confirm order." },
            { status: 500 }
          );
        }
      }
    }

    /*
      Do not cancel the local order on payment.failed.

      Razorpay can allow a customer to retry payment against the
      same checkout/order. The local order therefore remains pending
      until a successful payment is confirmed.

      Expiration/release of stale pending orders can be added later
      as a separate background-job concern.
    */

    return NextResponse.json({ success: true });
  } catch (error) {
    console.error("Razorpay webhook error:", error);

    return NextResponse.json(
      { error: "Webhook processing failed." },
      { status: 500 }
    );
  }
}
