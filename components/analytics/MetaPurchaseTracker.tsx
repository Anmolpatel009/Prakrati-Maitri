"use client";

import { useEffect } from "react";
import { trackMetaEvent } from "@/components/analytics/MetaPixel";

export default function MetaPurchaseTracker({
  orderId,
  value,
}: {
  orderId: string;
  value: number;
}) {
  useEffect(() => {
    if (!orderId || !Number.isFinite(value)) return;
    const key = `pm_meta_purchase_${orderId}`;
    try {
      if (window.sessionStorage.getItem(key)) return;
      trackMetaEvent(
        "Purchase",
        {
          value,
          currency: "INR",
          order_id: orderId,
        },
        orderId,
      );
      window.sessionStorage.setItem(key, "1");
    } catch {
      // Tracking must never interrupt the customer's order flow.
    }
  }, [orderId, value]);

  return null;
}
