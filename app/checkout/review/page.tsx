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

  // =====================================================
  // LOAD DELIVERY INFORMATION
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
  // PREPARE CHECKOUT ON SERVER
  // =====================================================

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

  // =====================================================
  // LOADING
  // =====================================================

  if (!loaded) {
    return (
      <main className="min-h-screen bg-[#F9F7F2] px-5 py-16 sm:px-8">
        <div className="mx-auto max-w-3xl">
          <div className="rounded-3xl border border-[#D2B48C]/50 bg-white p-12 text-center">
            <div className="mx-auto h-8 w-8 animate-spin rounded-full border-2 border-[#D2B48C] border-t-[#4A5D23]" />

            <p className="mt-5 text-sm text-[#3D3D3D]/60">
              Loading your review...
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
              Review Order
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
  // DELIVERY INFORMATION MISSING
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
              Review Order
            </h1>

            <p className="mt-4 text-sm leading-6 text-[#3D3D3D]/65">
              Your delivery information is missing.
              Please return to checkout and enter your
              delivery details.
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
  // SERVER PREPARING CHECKOUT
  // =====================================================

  if (preparing) {
    return (
      <main className="min-h-screen bg-[#F9F7F2] px-5 py-16 sm:px-8">
        <div className="mx-auto max-w-3xl">
          <div className="rounded-3xl border border-[#D2B48C]/50 bg-white p-10 text-center sm:p-14">
            <div className="mx-auto h-10 w-10 animate-spin rounded-full border-2 border-[#D2B48C] border-t-[#4A5D23]" />

            <h1 className="mt-6 font-serif text-3xl text-[#4A5D23]">
              Verifying your order
            </h1>

            <p className="mt-3 text-sm leading-6 text-[#3D3D3D]/60">
              Checking current product prices and
              availability before you continue.
            </p>
          </div>
        </div>
      </main>
    );
  }

  // =====================================================
  // SERVER ERROR
  // =====================================================

  if (error) {
    return (
      <main className="min-h-screen bg-[#F9F7F2] px-5 py-16 sm:px-8">
        <div className="mx-auto max-w-3xl">
          <div className="rounded-3xl border border-red-200 bg-white p-10 text-center sm:p-14">
            <p className="text-xs font-semibold uppercase tracking-[0.2em] text-red-600">
              Checkout Error
            </p>

            <h1 className="mt-3 font-serif text-4xl text-[#4A5D23]">
              We couldn't prepare your order
            </h1>

            <p
              role="alert"
              className="mx-auto mt-5 max-w-xl rounded-2xl bg-red-50 px-5 py-4 text-sm leading-6 text-red-700"
            >
              {error}
            </p>

            <p className="mt-5 text-sm text-[#3D3D3D]/60">
              Your cart has not been cleared. You can return
              to it and make changes.
            </p>

            <Link
              href="/cart"
              className="mt-7 inline-flex rounded-full bg-[#4A5D23] px-7 py-3.5 text-sm font-semibold text-white transition hover:bg-[#3D4D1D]"
            >
              ← Back to Cart
            </Link>
          </div>
        </div>
      </main>
    );
  }

  // =====================================================
  // NO SERVER CHECKOUT
  // =====================================================

  if (!serverCheckout) {
    return (
      <main className="min-h-screen bg-[#F9F7F2] px-5 py-16 sm:px-8">
        <div className="mx-auto max-w-3xl">
          <div className="rounded-3xl border border-[#D2B48C]/50 bg-white p-10 text-center sm:p-14">
            <h1 className="font-serif text-4xl text-[#4A5D23]">
              Unable to prepare your order
            </h1>

            <p className="mt-4 text-sm text-[#3D3D3D]/60">
              Please return to your cart and try again.
            </p>

            <Link
              href="/cart"
              className="mt-7 inline-flex rounded-full bg-[#4A5D23] px-7 py-3.5 text-sm font-semibold text-white"
            >
              ← Back to Cart
            </Link>
          </div>
        </div>
      </main>
    );
  }

  // =====================================================
  // MAIN REVIEW
  // =====================================================

  return (
    <main className="min-h-screen bg-[#F9F7F2] px-5 py-10 sm:px-8 lg:py-14">
      <div className="mx-auto max-w-6xl">

        {/* ================================================= */}
        {/* HEADER */}
        {/* ================================================= */}

        <div className="mb-10">
          <Link
            href="/checkout"
            className="text-sm text-[#3D3D3D]/60 transition hover:text-[#4A5D23]"
          >
            ← Back to Checkout
          </Link>

          <div className="mt-7 rounded-3xl border border-[#D2B48C]/50 bg-[#EDE5D4] px-6 py-10 text-center sm:px-10">
            <p className="text-xs font-semibold uppercase tracking-[0.25em] text-[#4A5D23]">
              Step 2
            </p>

            <h1 className="mt-3 font-serif text-4xl text-[#4A5D23] sm:text-5xl">
              Review Your Order
            </h1>

            <p className="mx-auto mt-3 max-w-xl text-sm leading-6 text-[#3D3D3D]/65">
              Everything looks good? Review your delivery
              details and order total before payment.
            </p>
          </div>
        </div>

        {/* ================================================= */}
        {/* REVIEW GRID */}
        {/* ================================================= */}

        <div className="grid gap-8 lg:grid-cols-[1.4fr_0.85fr]">

          {/* ================================================= */}
          {/* LEFT COLUMN */}
          {/* ================================================= */}

          <div className="space-y-8">

            {/* DELIVERY */}
            <section className="rounded-3xl border border-[#D2B48C]/50 bg-white p-6 shadow-sm sm:p-8">

              <div className="flex items-start justify-between gap-5 border-b border-[#D2B48C]/30 pb-6">
                <div>
                  <p className="text-xs font-semibold uppercase tracking-[0.2em] text-[#4A5D23]">
                    Delivery
                  </p>

                  <h2 className="mt-2 font-serif text-3xl text-[#4A5D23]">
                    Delivery Information
                  </h2>
                </div>

                <Link
                  href="/checkout"
                  className="shrink-0 rounded-full border border-[#D2B48C] px-4 py-2 text-xs font-semibold text-[#4A5D23] transition hover:border-[#4A5D23] hover:bg-[#F9F7F2]"
                >
                  Edit
                </Link>
              </div>

              <div className="mt-6">

                <p className="text-lg font-semibold text-[#3D3D3D]">
                  {checkout.firstName}{" "}
                  {checkout.lastName}
                </p>

                <p className="mt-3 text-sm text-[#3D3D3D]/70">
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

            {/* ORDER ITEMS */}
            <section className="rounded-3xl border border-[#D2B48C]/50 bg-white p-6 shadow-sm sm:p-8">

              <div className="border-b border-[#D2B48C]/30 pb-6">
                <p className="text-xs font-semibold uppercase tracking-[0.2em] text-[#4A5D23]">
                  Products
                </p>

                <h2 className="mt-2 font-serif text-3xl text-[#4A5D23]">
                  Order Items
                </h2>
              </div>

              <div className="mt-2 divide-y divide-[#D2B48C]/30">

                {serverCheckout.items.map(
                  (item) => (
                    <div
                      key={item.productId}
                      className="py-6 first:pt-6 last:pb-2"
                    >
                      <div className="flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">

                        <div>
                          <h3 className="text-base font-semibold text-[#3D3D3D]">
                            {item.name}
                          </h3>

                          {item.sku && (
                            <p className="mt-1 text-xs text-[#3D3D3D]/45">
                              SKU: {item.sku}
                            </p>
                          )}

                          <p className="mt-3 text-sm text-[#3D3D3D]/60">
                            ₹
                            {item.unitPrice.toLocaleString(
                              "en-IN",
                              {
                                minimumFractionDigits: 2,
                                maximumFractionDigits: 2,
                              }
                            )}{" "}
                            × {item.quantity}
                          </p>
                        </div>

                        <div className="sm:text-right">
                          <p className="font-semibold text-[#3D3D3D]">
                            ₹
                            {item.lineTotal.toLocaleString(
                              "en-IN",
                              {
                                minimumFractionDigits: 2,
                                maximumFractionDigits: 2,
                              }
                            )}
                          </p>

                          <p className="mt-2 inline-flex rounded-full bg-[#E8F5E9] px-3 py-1 text-xs font-medium text-[#4A5D23]">
                            {item.availableQuantity.toLocaleString(
                              "en-IN"
                            )}{" "}
                            available
                          </p>
                        </div>

                      </div>
                    </div>
                  )
                )}

              </div>
            </section>

          </div>

          {/* ================================================= */}
          {/* RIGHT COLUMN */}
          {/* ================================================= */}

          <aside className="lg:sticky lg:top-8 lg:self-start">

            <section className="rounded-3xl border border-[#D2B48C]/50 bg-white p-6 shadow-sm sm:p-7">

              <p className="text-xs font-semibold uppercase tracking-[0.2em] text-[#4A5D23]">
                Final Check
              </p>

              <h2 className="mt-2 font-serif text-3xl text-[#4A5D23]">
                Order Summary
              </h2>

              <div className="mt-7 space-y-4">

                <div className="flex justify-between text-sm text-[#3D3D3D]/65">
                  <span>Subtotal</span>

                  <span>
                    ₹
                    {serverCheckout.subtotal.toLocaleString(
                      "en-IN",
                      {
                        minimumFractionDigits: 2,
                        maximumFractionDigits: 2,
                      }
                    )}
                  </span>
                </div>

                <div className="flex justify-between text-sm text-[#3D3D3D]/65">
                  <span>Shipping</span>

                  <span>
                    ₹
                    {serverCheckout.shippingFee.toLocaleString(
                      "en-IN",
                      {
                        minimumFractionDigits: 2,
                        maximumFractionDigits: 2,
                      }
                    )}
                  </span>
                </div>

              </div>

              <div className="mt-6 border-t border-[#D2B48C]/40 pt-6">

                <div className="flex items-end justify-between gap-4">

                  <div>
                    <p className="text-sm text-[#3D3D3D]/55">
                      Current Total
                    </p>

                    <p className="mt-1 font-serif text-3xl text-[#4A5D23]">
                      ₹
                      {serverCheckout.total.toLocaleString(
                        "en-IN",
                        {
                          minimumFractionDigits: 2,
                          maximumFractionDigits: 2,
                        }
                      )}
                    </p>
                  </div>

                </div>

              </div>

              <button
                type="button"
                onClick={() => {
                  router.push(
                    "/checkout/payment"
                  );
                }}
                className="mt-7 w-full rounded-full bg-[#8B4513] px-6 py-4 text-sm font-semibold text-white transition hover:-translate-y-0.5 hover:bg-[#71370F] hover:shadow-lg active:translate-y-0"
              >
                Continue to Payment →
              </button>

              <p className="mt-4 text-center text-xs leading-5 text-[#3D3D3D]/45">
                You'll be able to review the payment
                details before placing your order.
              </p>

            </section>

            {/* TRUST MESSAGE */}

            <div className="mt-5 rounded-2xl border border-[#D2B48C]/40 bg-[#EDE5D4]/60 p-5">
              <p className="text-sm font-semibold text-[#4A5D23]">
                Price verified
              </p>

              <p className="mt-1 text-xs leading-5 text-[#3D3D3D]/60">
                Product prices and stock availability have
                been checked with the server before you
                continue.
              </p>
            </div>

          </aside>

        </div>

        {/* ================================================= */}
        {/* BOTTOM NAVIGATION */}
        {/* ================================================= */}

        <div className="mt-8">
          <Link
            href="/cart"
            className="text-sm text-[#3D3D3D]/55 transition hover:text-[#4A5D23]"
          >
            ← Back to Cart
          </Link>
        </div>

      </div>
    </main>
  );
}