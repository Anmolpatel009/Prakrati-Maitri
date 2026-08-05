"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useCart } from "@/components/cart/CartProvider";

type CheckoutForm = {
  firstName: string;
  lastName: string;
  phone: string;
  address: string;
  city: string;
  state: string;
  country: string;
  postalCode: string;
};

export default function PaymentPage() {
  const router = useRouter();
  const { items, subtotal } = useCart();

  const [checkout, setCheckout] = useState<CheckoutForm | null>(null);
  const [loaded, setLoaded] = useState(false);
  const [placingOrder, setPlacingOrder] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    const stored = sessionStorage.getItem(
      "prakratri-matri-checkout"
    );

    if (stored) {
      try {
        setCheckout(JSON.parse(stored));
      } catch {
        sessionStorage.removeItem(
          "prakratri-matri-checkout"
        );
      }
    }

    setLoaded(true);
  }, []);

  async function handlePlaceTestOrder() {
    if (!checkout) {
      setError("Delivery information is missing.");
      return;
    }

    if (items.length === 0) {
      setError("Your cart is empty.");
      return;
    }

    setPlacingOrder(true);
    setError("");

    try {
      const response = await fetch("/api/orders/create", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          items: items.map((item) => ({
            productId: item.productId,
            quantity: item.quantity,
          })),
          shipping: checkout,
        }),
      });

      const data = await response.json();

      if (!response.ok) {
        setError(
          data.error || "Unable to create your order."
        );
        setPlacingOrder(false);
        return;
      }

      sessionStorage.removeItem(
        "prakratri-matri-checkout"
      );

      localStorage.removeItem(
        "prakratri-matri-cart"
      );

      router.push(
        `/checkout/success?order=${data.orderId}`
      );
    } catch (error) {
      console.error("Order creation error:", error);

      setError(
        "Something went wrong. Please try again."
      );

      setPlacingOrder(false);
    }
  }

  if (!loaded) {
    return (
      <main>
        <p>Loading payment...</p>
      </main>
    );
  }

  if (items.length === 0) {
    return (
      <main>
        <h1>Payment</h1>

        <p>Your cart is empty.</p>

        <Link href="/shop">
          Continue Shopping
        </Link>
      </main>
    );
  }

  if (!checkout) {
    return (
      <main>
        <h1>Payment</h1>

        <p>Delivery information is missing.</p>

        <Link href="/checkout">
          ← Back to Checkout
        </Link>
      </main>
    );
  }

  return (
    <main>
      <h1>Payment</h1>

      <section>
        <h2>Order Summary</h2>

        {items.map((item) => (
          <div key={item.productId}>
            <p>
              <strong>{item.name}</strong>
            </p>

            <p>
              ₹{item.price.toFixed(2)} × {item.quantity}
            </p>

            <p>
              ₹
              {(item.price * item.quantity).toFixed(2)}
            </p>
          </div>
        ))}

        <p>
          Subtotal: ₹{subtotal.toFixed(2)}
        </p>

        <p>Shipping: ₹0.00</p>

        <p>
          <strong>
            Total: ₹{subtotal.toFixed(2)}
          </strong>
        </p>
      </section>

      <section>
        <h2>Payment Method</h2>

        <p>
          Online payment will be available here.
        </p>

        <p>
          Stripe integration will be added before
          production launch.
        </p>
      </section>

      {error && (
        <p role="alert">
          {error}
        </p>
      )}

      <button
        type="button"
        onClick={handlePlaceTestOrder}
        disabled={placingOrder}
      >
        {placingOrder
          ? "Placing order..."
          : "Place Test Order"}
      </button>

      <p>
        <Link href="/checkout/review">
          ← Back to Review
        </Link>
      </p>
    </main>
  );
}