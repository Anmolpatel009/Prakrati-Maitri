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

type PreparedItem = {
  productId: string;
  name: string;
  slug: string;
  sku: string | null;
  quantity: number;
  unitPrice: number;
  lineTotal: number;
  availableQuantity: number;
};

type PreparedCheckout = {
  userId: string;
  items: PreparedItem[];
  subtotal: number;
  shippingFee: number;
  total: number;
};

export default function CheckoutReviewPage() {
  const router = useRouter();
  const { items } = useCart();

  const [checkout, setCheckout] =
    useState<CheckoutForm | null>(null);

  const [serverCheckout, setServerCheckout] =
    useState<PreparedCheckout | null>(null);

  const [loaded, setLoaded] = useState(false);
  const [preparing, setPreparing] = useState(false);
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

  /*
   * Once the page has loaded and we have cart items,
   * ask the server to validate the cart and calculate
   * the authoritative price.
   */
  useEffect(() => {
    if (!loaded || items.length === 0) {
      return;
    }

    async function prepareCheckout() {
      setPreparing(true);
      setError("");

      try {
        const response = await fetch(
          "/api/checkout/prepare",
          {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify({
              items: items.map((item) => ({
                productId: item.productId,
                quantity: item.quantity,
              })),
            }),
          }
        );

        const data = await response.json();

        if (!response.ok) {
          throw new Error(
            data.error ||
              "Unable to prepare your checkout."
          );
        }

        if (!data.success || !data.checkout) {
          throw new Error(
            "Invalid checkout response from server."
          );
        }

        setServerCheckout(data.checkout);
      } catch (err) {
        console.error(
          "Checkout preparation failed:",
          err
        );

        setError(
          err instanceof Error
            ? err.message
            : "Unable to prepare your checkout."
        );
      } finally {
        setPreparing(false);
      }
    }

    prepareCheckout();
  }, [loaded, items]);

  if (!loaded) {
    return (
      <main>
        <p>Loading review...</p>
      </main>
    );
  }

  if (items.length === 0) {
    return (
      <main>
        <h1>Review Order</h1>

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
        <h1>Review Order</h1>

        <p>
          Your delivery information is missing.
        </p>

        <Link href="/checkout">
          ← Back to Checkout
        </Link>
      </main>
    );
  }

  if (preparing) {
    return (
      <main>
        <h1>Review Order</h1>

        <p>Verifying your order...</p>
        <p>
          Checking product prices and availability.
        </p>
      </main>
    );
  }

  if (error) {
    return (
      <main>
        <h1>Review Order</h1>

        <p role="alert">
          {error}
        </p>

        <p>
          Your order could not be prepared.
        </p>

        <Link href="/cart">
          ← Back to Cart
        </Link>
      </main>
    );
  }

  if (!serverCheckout) {
    return (
      <main>
        <h1>Review Order</h1>

        <p>
          Unable to prepare your order.
        </p>

        <Link href="/cart">
          ← Back to Cart
        </Link>
      </main>
    );
  }

  return (
    <main>
      <h1>Review Order</h1>

      {/* ------------------------------------------ */}
      {/* DELIVERY INFORMATION */}
      {/* ------------------------------------------ */}

      <section>
        <h2>Delivery Information</h2>

        <p>
          <strong>
            {checkout.firstName}{" "}
            {checkout.lastName}
          </strong>
        </p>

        <p>
          Phone: {checkout.phone}
        </p>

        <p>
          {checkout.address}
          <br />
          {checkout.city}, {checkout.state}
          <br />
          {checkout.country} -{" "}
          {checkout.postalCode}
        </p>

        <Link href="/checkout">
          Edit delivery information
        </Link>
      </section>

      {/* ------------------------------------------ */}
      {/* ORDER ITEMS */}
      {/* ------------------------------------------ */}

      <section>
        <h2>Order Items</h2>

        {serverCheckout.items.map((item) => (
          <div key={item.productId}>
            <p>
              <strong>{item.name}</strong>
            </p>

            <p>
              ₹{item.unitPrice.toFixed(2)} ×{" "}
              {item.quantity}
            </p>

            <p>
              ₹{item.lineTotal.toFixed(2)}
            </p>

            <p>
              Available stock:{" "}
              {item.availableQuantity}
            </p>
          </div>
        ))}
      </section>

      {/* ------------------------------------------ */}
      {/* ORDER SUMMARY */}
      {/* ------------------------------------------ */}

      <section>
        <h2>Order Summary</h2>

        <p>
          Subtotal: ₹
          {serverCheckout.subtotal.toFixed(2)}
        </p>

        <p>
          Shipping: ₹
          {serverCheckout.shippingFee.toFixed(2)}
        </p>

        <p>
          <strong>
            Current Total: ₹
            {serverCheckout.total.toFixed(2)}
          </strong>
        </p>
      </section>

      {/* ------------------------------------------ */}
      {/* CONTINUE TO PAYMENT */}
      {/* ------------------------------------------ */}

      <section>
        <button
          type="button"
          onClick={() => {
            router.push(
              "/checkout/payment"
            );
          }}
        >
          Continue to Payment
        </button>
      </section>

      <p>
        <Link href="/cart">
          ← Back to Cart
        </Link>
      </p>
    </main>
  );
}