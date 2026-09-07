"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";

export default function BulkOrderPopup() {
  const router = useRouter();
  const [open, setOpen] = useState(false);

  useEffect(() => {
    const shown = sessionStorage.getItem("bulk-order-popup-shown");

    if (!shown) {
      setOpen(true);
      sessionStorage.setItem("bulk-order-popup-shown", "true");
    }
  }, []);

  if (!open) return null;

  function continueShopping() {
    setOpen(false);
  }

  return (
    <div className="bulk-order-popup-backdrop" role="dialog" aria-modal="true">
      <div className="bulk-order-popup">
        <button
          type="button"
          className="bulk-order-popup-close"
          onClick={continueShopping}
          aria-label="Close"
        >
          ×
        </button>

        <span className="bulk-order-popup-eyebrow">
          BULK ORDERS
        </span>

        <h2>
          Looking for bags in bulk?
        </h2>

        <p>
          Planning for your business, events, gifting, corporate needs or
          another large requirement? Tell us what you need and our team will
          get in touch with you.
        </p>

        <div className="bulk-order-popup-actions">
          <button
            type="button"
            className="bulk-order-popup-primary"
            onClick={() => router.push("/bulk-order")}
          >
            Explore Bulk Orders →
          </button>

          <button
            type="button"
            className="bulk-order-popup-secondary"
            onClick={continueShopping}
          >
            Continue Shopping
          </button>
        </div>
      </div>
    </div>
  );
}
