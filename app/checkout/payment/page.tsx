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

type PaymentMethod = "cod" | "online";

export default function PaymentPage() {
  const router = useRouter();

  const {
    items,
    subtotal,
    clearCart,
  } = useCart();

  const [checkout, setCheckout] =
    useState<CheckoutForm | null>(null);

  const [paymentMethod, setPaymentMethod] =
    useState<PaymentMethod>("cod");

  const [loaded, setLoaded] = useState(false);

  const [placingOrder, setPlacingOrder] =
    useState(false);

  const [error, setError] = useState("");

  // =====================================================
  // LOAD CHECKOUT INFORMATION
  // =====================================================

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

  // =====================================================
  // PLACE ORDER
  // =====================================================

  async function handlePlaceOrder() {
    if (placingOrder) {
      return;
    }

    if (!checkout) {
      setError(
        "Delivery information is missing."
      );
      return;
    }

    if (items.length === 0) {
      setError("Your cart is empty.");
      return;
    }

    setPlacingOrder(true);
    setError("");

    try {
      const response = await fetch(
        "/api/orders/create",
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

            shipping: checkout,

            paymentMethod,
          }),
        }
      );

      const data = await response.json();

      if (!response.ok) {
        throw new Error(
          data.error ||
            "Unable to create your order."
        );
      }

      if (!data.orderId) {
        throw new Error(
          "Order was created without a valid order ID."
        );
      }

      // =================================================
      // CLEAR TEMPORARY CHECKOUT DATA
      // =================================================

      sessionStorage.removeItem(
        "prakratri-matri-checkout"
      );

      // =================================================
      // CLEAR CART
      // =================================================

      clearCart();

      // =================================================
      // GO TO SUCCESS PAGE
      // =================================================

      router.push(
        `/checkout/success?order=${encodeURIComponent(
          data.orderId
        )}`
      );
    } catch (err) {
      console.error(
        "Order creation error:",
        err
      );

      setError(
        err instanceof Error
          ? err.message
          : "Something went wrong. Please try again."
      );

      setPlacingOrder(false);
    }
  }

  // =====================================================
  // LOADING
  // =====================================================

  if (!loaded) {
    return (
      <main className="min-h-screen bg-[#F9F7F2] px-5 py-16 sm:px-8">
        <div className="mx-auto max-w-3xl">
          <div className="rounded-3xl border border-[#D2B48C]/50 bg-white p-12 text-center">
            <div className="mx-auto h-9 w-9 animate-spin rounded-full border-2 border-[#D2B48C] border-t-[#4A5D23]" />

            <p className="mt-5 text-sm text-[#3D3D3D]/60">
              Preparing payment...
            </p>
          </div>
        </div>
      </main>
    );
  }

  // =====================================================
  // EMPTY CART
  // =====================================================

  if (items.length === 0) {
    return (
      <main className="min-h-screen bg-[#F9F7F2] px-5 py-16 sm:px-8">
        <div className="mx-auto max-w-3xl">
          <div className="rounded-3xl border border-[#D2B48C]/50 bg-[#EDE5D4] px-6 py-16 text-center sm:px-10">
            <p className="text-xs font-semibold uppercase tracking-[0.25em] text-[#4A5D23]">
              Prakrati Maitri
            </p>

            <h1 className="mt-3 font-serif text-4xl text-[#4A5D23] sm:text-5xl">
              Payment
            </h1>

            <p className="mt-4 text-sm text-[#3D3D3D]/65">
              Your cart is currently empty.
            </p>

            <Link
              href="/shop"
              className="mt-8 inline-flex rounded-full bg-[#4A5D23] px-7 py-3.5 text-sm font-semibold text-white transition hover:bg-[#3D4D1D]"
            >
              Continue Shopping
            </Link>
          </div>
        </div>
      </main>
    );
  }

  // =====================================================
  // MISSING DELIVERY INFORMATION
  // =====================================================

  if (!checkout) {
    return (
      <main className="min-h-screen bg-[#F9F7F2] px-5 py-16 sm:px-8">
        <div className="mx-auto max-w-3xl">
          <div className="rounded-3xl border border-[#D2B48C]/50 bg-white p-10 text-center sm:p-14">
            <p className="text-xs font-semibold uppercase tracking-[0.2em] text-[#4A5D23]">
              Checkout
            </p>

            <h1 className="mt-3 font-serif text-4xl text-[#4A5D23]">
              Delivery information missing
            </h1>

            <p className="mx-auto mt-4 max-w-md text-sm leading-6 text-[#3D3D3D]/60">
              Please enter your delivery details before
              continuing to payment.
            </p>

            <Link
              href="/checkout"
              className="mt-7 inline-flex rounded-full bg-[#4A5D23] px-7 py-3.5 text-sm font-semibold text-white transition hover:bg-[#3D4D1D]"
            >
              ← Back to Checkout
            </Link>
          </div>
        </div>
      </main>
    );
  }

  // =====================================================
  // PAYMENT PAGE
  // =====================================================

  return (
    <main className="min-h-screen bg-[#F9F7F2] px-5 py-10 sm:px-8 lg:py-14">
      <div className="mx-auto max-w-6xl">

        {/* ================================================= */}
        {/* HEADER */}
        {/* ================================================= */}

        <div className="mb-10">
          <Link
            href="/checkout/review"
            className="text-sm text-[#3D3D3D]/60 transition hover:text-[#4A5D23]"
          >
            ← Back to Review
          </Link>

          <div className="mt-7 rounded-3xl border border-[#D2B48C]/50 bg-[#EDE5D4] px-6 py-10 text-center sm:px-10">
            <p className="text-xs font-semibold uppercase tracking-[0.25em] text-[#4A5D23]">
              Step 3
            </p>

            <h1 className="mt-3 font-serif text-4xl text-[#4A5D23] sm:text-5xl">
              Payment
            </h1>

            <p className="mx-auto mt-3 max-w-xl text-sm leading-6 text-[#3D3D3D]/65">
              Choose your payment method before placing
              your test order.
            </p>
          </div>
        </div>

        {/* ================================================= */}
        {/* GRID */}
        {/* ================================================= */}

        <div className="grid gap-8 lg:grid-cols-[1.35fr_0.85fr]">

          {/* ================================================= */}
          {/* LEFT COLUMN */}
          {/* ================================================= */}

          <div className="space-y-8">

            {/* ================================================= */}
            {/* PAYMENT METHOD */}
            {/* ================================================= */}

            <section className="rounded-3xl border border-[#D2B48C]/50 bg-white p-6 shadow-sm sm:p-8">

              <div className="border-b border-[#D2B48C]/30 pb-6">
                <p className="text-xs font-semibold uppercase tracking-[0.2em] text-[#4A5D23]">
                  Payment Method
                </p>

                <h2 className="mt-2 font-serif text-3xl text-[#4A5D23]">
                  Choose how you want to pay
                </h2>
              </div>

              {/* ================================================= */}
              {/* PAYMENT OPTIONS */}
              {/* ================================================= */}

              <div className="mt-6 space-y-4">

                {/* ONLINE PAYMENT */}

                <button
                  type="button"
                  onClick={() =>
                    setPaymentMethod("online")
                  }
                  disabled={placingOrder}
                  className={`w-full rounded-2xl border-2 p-5 text-left transition ${
                    paymentMethod === "online"
                      ? "border-[#4A5D23] bg-[#F1EDE3]"
                      : "border-[#D2B48C]/50 bg-white hover:border-[#4A5D23]/50"
                  }`}
                >
                  <div className="flex items-start gap-4">

                    <div
                      className={`mt-1 flex h-5 w-5 shrink-0 items-center justify-center rounded-full border-2 ${
                        paymentMethod === "online"
                          ? "border-[#4A5D23]"
                          : "border-[#D2B48C]"
                      }`}
                    >
                      {paymentMethod === "online" && (
                        <div className="h-2.5 w-2.5 rounded-full bg-[#4A5D23]" />
                      )}
                    </div>

                    <div className="flex-1">
                      <div className="flex flex-wrap items-center justify-between gap-2">
                        <p className="font-semibold text-[#3D3D3D]">
                          Online Payment
                        </p>

                        <span className="rounded-full bg-[#EDE5D4] px-3 py-1 text-[10px] font-semibold uppercase tracking-wider text-[#8B4513]">
                          Coming Soon
                        </span>
                      </div>

                      <p className="mt-2 text-sm leading-6 text-[#3D3D3D]/60">
                        Payment gateway will be connected
                        after the MVP is approved.
                      </p>
                    </div>

                  </div>
                </button>

                {/* COD */}

                <button
                  type="button"
                  onClick={() =>
                    setPaymentMethod("cod")
                  }
                  disabled={placingOrder}
                  className={`w-full rounded-2xl border-2 p-5 text-left transition ${
                    paymentMethod === "cod"
                      ? "border-[#4A5D23] bg-[#F1EDE3]"
                      : "border-[#D2B48C]/50 bg-white hover:border-[#4A5D23]/50"
                  }`}
                >
                  <div className="flex items-start gap-4">

                    <div
                      className={`mt-1 flex h-5 w-5 shrink-0 items-center justify-center rounded-full border-2 ${
                        paymentMethod === "cod"
                          ? "border-[#4A5D23]"
                          : "border-[#D2B48C]"
                      }`}
                    >
                      {paymentMethod === "cod" && (
                        <div className="h-2.5 w-2.5 rounded-full bg-[#4A5D23]" />
                      )}
                    </div>

                    <div className="flex-1">
                      <div className="flex flex-wrap items-center justify-between gap-2">
                        <p className="font-semibold text-[#3D3D3D]">
                          Cash on Delivery
                        </p>

                        <span className="rounded-full bg-[#E8F5E9] px-3 py-1 text-[10px] font-semibold uppercase tracking-wider text-[#4A5D23]">
                          Available
                        </span>
                      </div>

                      <p className="mt-2 text-sm leading-6 text-[#3D3D3D]/60">
                        Place your order now and pay when
                        your order is delivered.
                      </p>
                    </div>

                  </div>
                </button>

              </div>

              {/* ================================================= */}
              {/* DEVELOPMENT NOTICE */}
              {/* ================================================= */}

              <div className="mt-6 rounded-2xl border border-[#D2B48C]/40 bg-[#EDE5D4]/50 p-5">

                <p className="text-sm font-semibold text-[#4A5D23]">
                  Development mode
                </p>

                {paymentMethod === "cod" ? (
                  <p className="mt-1 text-xs leading-5 text-[#3D3D3D]/60">
                    This COD order will be created as a
                    confirmed order with payment marked as
                    pending collection.
                  </p>
                ) : (
                  <p className="mt-1 text-xs leading-5 text-[#3D3D3D]/60">
                    No real payment will be processed.
                    This will create a pending online
                    payment test order.
                  </p>
                )}

              </div>

            </section>

            {/* ================================================= */}
            {/* DELIVERY */}
            {/* ================================================= */}

            <section className="rounded-3xl border border-[#D2B48C]/50 bg-white p-6 shadow-sm sm:p-8">

              <div className="flex items-start justify-between gap-5 border-b border-[#D2B48C]/30 pb-6">

                <div>
                  <p className="text-xs font-semibold uppercase tracking-[0.2em] text-[#4A5D23]">
                    Deliver To
                  </p>

                  <h2 className="mt-2 font-serif text-3xl text-[#4A5D23]">
                    Delivery Information
                  </h2>
                </div>

                <Link
                  href="/checkout"
                  className="shrink-0 rounded-full border border-[#D2B48C] px-4 py-2 text-xs font-semibold text-[#4A5D23] transition hover:border-[#4A5D23]"
                >
                  Edit
                </Link>

              </div>

              <div className="mt-6">

                <p className="font-semibold text-[#3D3D3D]">
                  {checkout.firstName}{" "}
                  {checkout.lastName}
                </p>

                <p className="mt-2 text-sm text-[#3D3D3D]/65">
                  {checkout.phone}
                </p>

                <div className="mt-4 rounded-2xl bg-[#F9F7F2] p-5 text-sm leading-7 text-[#3D3D3D]/70">

                  <p>{checkout.address}</p>

                  <p>
                    {checkout.city},{" "}
                    {checkout.state}
                  </p>

                  <p>
                    {checkout.country} -{" "}
                    {checkout.postalCode}
                  </p>

                </div>

              </div>

            </section>

          </div>

          {/* ================================================= */}
          {/* ORDER SUMMARY */}
          {/* ================================================= */}

          <aside className="lg:sticky lg:top-8 lg:self-start">

            <section className="rounded-3xl border border-[#D2B48C]/50 bg-white p-6 shadow-sm sm:p-7">

              <p className="text-xs font-semibold uppercase tracking-[0.2em] text-[#4A5D23]">
                Your Order
              </p>

              <h2 className="mt-2 font-serif text-3xl text-[#4A5D23]">
                Order Summary
              </h2>

              {/* ITEMS */}

              <div className="mt-6 divide-y divide-[#D2B48C]/30">

                {items.map((item) => (
                  <div
                    key={item.cartItemId}
                    className="flex gap-4 py-4 first:pt-0"
                  >

                    <div className="min-w-0 flex-1">

                      <p className="font-medium text-[#3D3D3D]">
                        {item.name}
                      </p>

                      {item.customization && (
                        <p className="mt-1 text-xs font-medium text-[#8B4513]">
                          {item.customization.type ===
                          "custom"
                            ? "Custom"
                            : "Standard"}
                        </p>
                      )}

                      <p className="mt-1 text-xs text-[#3D3D3D]/55">
                        ₹
                        {item.price.toLocaleString(
                          "en-IN",
                          {
                            minimumFractionDigits: 2,
                            maximumFractionDigits: 2,
                          }
                        )}{" "}
                        × {item.quantity}
                      </p>

                    </div>

                    <p className="shrink-0 text-sm font-semibold text-[#3D3D3D]">
                      ₹
                      {(
                        item.price *
                        item.quantity
                      ).toLocaleString(
                        "en-IN",
                        {
                          minimumFractionDigits: 2,
                          maximumFractionDigits: 2,
                        }
                      )}
                    </p>

                  </div>
                ))}

              </div>

              {/* TOTALS */}

              <div className="mt-6 border-t border-[#D2B48C]/40 pt-5">

                <div className="flex justify-between text-sm text-[#3D3D3D]/65">
                  <span>Subtotal</span>

                  <span>
                    ₹
                    {subtotal.toLocaleString(
                      "en-IN",
                      {
                        minimumFractionDigits: 2,
                        maximumFractionDigits: 2,
                      }
                    )}
                  </span>
                </div>

                <div className="mt-3 flex justify-between text-sm text-[#3D3D3D]/65">
                  <span>Shipping</span>
                  <span>₹0.00</span>
                </div>

                <div className="mt-5 border-t border-[#D2B48C]/30 pt-5">

                  <p className="text-sm text-[#3D3D3D]/55">
                    Total
                  </p>

                  <p className="mt-1 font-serif text-3xl text-[#4A5D23]">
                    ₹
                    {subtotal.toLocaleString(
                      "en-IN",
                      {
                        minimumFractionDigits: 2,
                        maximumFractionDigits: 2,
                      }
                    )}
                  </p>

                </div>

                {/* ERROR */}

                {error && (
                  <div
                    role="alert"
                    className="mt-5 rounded-2xl border border-red-200 bg-red-50 px-4 py-3 text-sm leading-6 text-red-700"
                  >
                    {error}
                  </div>
                )}

                {/* PLACE ORDER */}

                <button
                  type="button"
                  onClick={handlePlaceOrder}
                  disabled={placingOrder}
                  className="mt-6 w-full rounded-full bg-[#8B4513] px-6 py-4 text-sm font-semibold text-white transition hover:-translate-y-0.5 hover:bg-[#71370F] hover:shadow-lg active:translate-y-0 disabled:cursor-not-allowed disabled:opacity-60 disabled:hover:translate-y-0 disabled:hover:shadow-none"
                >
                  {placingOrder
                    ? "Placing order..."
                    : paymentMethod === "cod"
                    ? "Place COD Order"
                    : "Place Online Test Order"}
                </button>

                <p className="mt-4 text-center text-xs leading-5 text-[#3D3D3D]/45">
                  {paymentMethod === "cod"
                    ? "No payment is required online. Payment will be collected on delivery."
                    : "No payment will be charged during development."}
                </p>

              </div>

            </section>

            <div className="mt-5 rounded-2xl border border-[#D2B48C]/40 bg-[#EDE5D4]/60 p-5">

              <p className="text-sm font-semibold text-[#4A5D23]">
                Almost there
              </p>

              <p className="mt-1 text-xs leading-5 text-[#3D3D3D]/60">
                The server will validate the order,
                price, inventory, and payment method
                again when you place it.
              </p>

            </div>

          </aside>

        </div>
      </div>
    </main>
  );
}