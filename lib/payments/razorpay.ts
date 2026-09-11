import crypto from "node:crypto";

const RAZORPAY_KEY_ID = process.env.RAZORPAY_KEY_ID;
const RAZORPAY_KEY_SECRET = process.env.RAZORPAY_KEY_SECRET;

function requireCredentials() {
  if (!RAZORPAY_KEY_ID || !RAZORPAY_KEY_SECRET) {
    throw new Error("Razorpay server credentials are not configured.");
  }

  return {
    keyId: RAZORPAY_KEY_ID,
    keySecret: RAZORPAY_KEY_SECRET,
  };
}

function authHeader(keyId: string, keySecret: string) {
  return `Basic ${Buffer.from(`${keyId}:${keySecret}`).toString("base64")}`;
}

export async function createRazorpayOrder({
  amountInPaise,
  localOrderId,
}: {
  amountInPaise: number;
  localOrderId: string;
}) {
  const { keyId, keySecret } = requireCredentials();

  const response = await fetch("https://api.razorpay.com/v1/orders", {
    method: "POST",
    headers: {
      Authorization: authHeader(keyId, keySecret),
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      amount: amountInPaise,
      currency: "INR",
      receipt: localOrderId,
      notes: {
        local_order_id: localOrderId,
      },
    }),
    cache: "no-store",
  });

  const data = await response.json();

  if (!response.ok) {
    throw new Error(
      data?.error?.description || "Failed to create Razorpay order."
    );
  }

  return {
    id: String(data.id),
    amount: Number(data.amount),
    currency: String(data.currency),
  };
}

export async function fetchRazorpayPayment(paymentId: string) {
  const { keyId, keySecret } = requireCredentials();

  const response = await fetch(
    `https://api.razorpay.com/v1/payments/${encodeURIComponent(paymentId)}`,
    {
      headers: {
        Authorization: authHeader(keyId, keySecret),
      },
      cache: "no-store",
    }
  );

  const data = await response.json();

  if (!response.ok) {
    throw new Error(
      data?.error?.description || "Failed to fetch Razorpay payment."
    );
  }

  return data;
}

export function verifyRazorpaySignature({
  orderId,
  paymentId,
  signature,
}: {
  orderId: string;
  paymentId: string;
  signature: string;
}) {
  const { keySecret } = requireCredentials();

  const expectedSignature = crypto
    .createHmac("sha256", keySecret)
    .update(`${orderId}|${paymentId}`)
    .digest("hex");

  const expected = Buffer.from(expectedSignature);
  const received = Buffer.from(signature);

  return (
    expected.length === received.length &&
    crypto.timingSafeEqual(expected, received)
  );
}

export function verifyRazorpayWebhookSignature(
  rawBody: string,
  signature: string
) {
  const webhookSecret = process.env.RAZORPAY_WEBHOOK_SECRET;

  if (!webhookSecret) {
    throw new Error("RAZORPAY_WEBHOOK_SECRET is not configured.");
  }

  const expectedSignature = crypto
    .createHmac("sha256", webhookSecret)
    .update(rawBody)
    .digest("hex");

  const expected = Buffer.from(expectedSignature);
  const received = Buffer.from(signature);

  return (
    expected.length === received.length &&
    crypto.timingSafeEqual(expected, received)
  );
}
