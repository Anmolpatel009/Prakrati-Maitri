"use client";

import { FormEvent, useState } from "react";
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

export default function CheckoutPage() {
  const router = useRouter();

  const { items, subtotal } = useCart();

  const [form, setForm] = useState<CheckoutForm>({
    firstName: "",
    lastName: "",
    phone: "",
    address: "",
    city: "",
    state: "",
    country: "India",
    postalCode: "",
  });

  const [error, setError] = useState("");

  function updateField(
    field: keyof CheckoutForm,
    value: string
  ) {
    setForm((current) => ({
      ...current,
      [field]: value,
    }));
  }

  function handleSubmit(
    event: FormEvent<HTMLFormElement>
  ) {
    event.preventDefault();

    setError("");

    if (items.length === 0) {
      setError("Your cart is empty.");
      return;
    }

    if (form.phone.trim().length < 10) {
      setError("Please enter a valid phone number.");
      return;
    }

    if (form.postalCode.trim().length < 4) {
      setError("Please enter a valid postal code.");
      return;
    }

    sessionStorage.setItem(
      "prakratri-matri-checkout",
      JSON.stringify(form)
    );

    router.push("/checkout/review");
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
              Checkout
            </h1>

            <p className="mx-auto mt-4 max-w-md text-sm leading-6 text-[#3D3D3D]/65">
              Your cart is currently empty. Add something
              thoughtful before continuing.
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

  return (
    <main className="min-h-screen bg-[#F9F7F2] px-5 py-10 sm:px-8 lg:py-14">
      <div className="mx-auto max-w-6xl">

        {/* ================================================= */}
        {/* HEADER */}
        {/* ================================================= */}

        <div className="mb-10">
          <Link
            href="/cart"
            className="text-sm text-[#3D3D3D]/60 transition hover:text-[#4A5D23]"
          >
            ← Back to Cart
          </Link>

          <div className="mt-7 rounded-3xl border border-[#D2B48C]/50 bg-[#EDE5D4] px-6 py-10 text-center sm:px-10">
            <p className="text-xs font-semibold uppercase tracking-[0.25em] text-[#4A5D23]">
              Prakrati Maitri
            </p>

            <h1 className="mt-3 font-serif text-4xl text-[#4A5D23] sm:text-5xl">
              Checkout
            </h1>

            <p className="mx-auto mt-3 max-w-xl text-sm leading-6 text-[#3D3D3D]/65">
              Complete your delivery details and review your
              order before proceeding.
            </p>
          </div>
        </div>

        {/* ================================================= */}
        {/* CHECKOUT GRID */}
        {/* ================================================= */}

        <form onSubmit={handleSubmit}>
          <div className="grid gap-8 lg:grid-cols-[1.45fr_0.85fr]">

            {/* ================================================= */}
            {/* DELIVERY INFORMATION */}
            {/* ================================================= */}

            <section className="rounded-3xl border border-[#D2B48C]/50 bg-white p-6 shadow-sm sm:p-8">

              <div className="border-b border-[#D2B48C]/30 pb-6">
                <p className="text-xs font-semibold uppercase tracking-[0.2em] text-[#4A5D23]">
                  Step 1
                </p>

                <h2 className="mt-2 font-serif text-3xl text-[#4A5D23]">
                  Delivery Information
                </h2>

                <p className="mt-2 text-sm leading-6 text-[#3D3D3D]/60">
                  Tell us where your order should be delivered.
                </p>
              </div>

              {/* ================================================= */}
              {/* NAME */}
              {/* ================================================= */}

              <div className="mt-7 grid gap-5 sm:grid-cols-2">

                <div>
                  <label
                    htmlFor="firstName"
                    className="mb-2 block text-sm font-semibold text-[#3D3D3D]"
                  >
                    First name
                  </label>

                  <input
                    id="firstName"
                    name="firstName"
                    type="text"
                    value={form.firstName}
                    onChange={(event) =>
                      updateField(
                        "firstName",
                        event.target.value
                      )
                    }
                    required
                    autoComplete="given-name"
                    placeholder="Your first name"
                    className="w-full rounded-2xl border border-[#D2B48C]/70 bg-[#F9F7F2] px-4 py-3.5 text-sm text-[#3D3D3D] outline-none transition placeholder:text-[#3D3D3D]/35 focus:border-[#4A5D23] focus:ring-2 focus:ring-[#4A5D23]/10"
                  />
                </div>

                <div>
                  <label
                    htmlFor="lastName"
                    className="mb-2 block text-sm font-semibold text-[#3D3D3D]"
                  >
                    Last name
                  </label>

                  <input
                    id="lastName"
                    name="lastName"
                    type="text"
                    value={form.lastName}
                    onChange={(event) =>
                      updateField(
                        "lastName",
                        event.target.value
                      )
                    }
                    required
                    autoComplete="family-name"
                    placeholder="Your last name"
                    className="w-full rounded-2xl border border-[#D2B48C]/70 bg-[#F9F7F2] px-4 py-3.5 text-sm text-[#3D3D3D] outline-none transition placeholder:text-[#3D3D3D]/35 focus:border-[#4A5D23] focus:ring-2 focus:ring-[#4A5D23]/10"
                  />
                </div>

              </div>

              {/* ================================================= */}
              {/* PHONE */}
              {/* ================================================= */}

              <div className="mt-5">
                <label
                  htmlFor="phone"
                  className="mb-2 block text-sm font-semibold text-[#3D3D3D]"
                >
                  Phone number
                </label>

                <input
                  id="phone"
                  name="phone"
                  type="tel"
                  value={form.phone}
                  onChange={(event) =>
                    updateField(
                      "phone",
                      event.target.value
                    )
                  }
                  required
                  autoComplete="tel"
                  placeholder="10-digit mobile number"
                  className="w-full rounded-2xl border border-[#D2B48C]/70 bg-[#F9F7F2] px-4 py-3.5 text-sm text-[#3D3D3D] outline-none transition placeholder:text-[#3D3D3D]/35 focus:border-[#4A5D23] focus:ring-2 focus:ring-[#4A5D23]/10"
                />
              </div>

              {/* ================================================= */}
              {/* ADDRESS */}
              {/* ================================================= */}

              <div className="mt-5">
                <label
                  htmlFor="address"
                  className="mb-2 block text-sm font-semibold text-[#3D3D3D]"
                >
                  Delivery address
                </label>

                <textarea
                  id="address"
                  name="address"
                  value={form.address}
                  onChange={(event) =>
                    updateField(
                      "address",
                      event.target.value
                    )
                  }
                  required
                  autoComplete="street-address"
                  rows={4}
                  placeholder="House / flat number, street, area..."
                  className="w-full resize-none rounded-2xl border border-[#D2B48C]/70 bg-[#F9F7F2] px-4 py-3.5 text-sm leading-6 text-[#3D3D3D] outline-none transition placeholder:text-[#3D3D3D]/35 focus:border-[#4A5D23] focus:ring-2 focus:ring-[#4A5D23]/10"
                />
              </div>

              {/* ================================================= */}
              {/* CITY + STATE */}
              {/* ================================================= */}

              <div className="mt-5 grid gap-5 sm:grid-cols-2">

                <div>
                  <label
                    htmlFor="city"
                    className="mb-2 block text-sm font-semibold text-[#3D3D3D]"
                  >
                    City
                  </label>

                  <input
                    id="city"
                    name="city"
                    type="text"
                    value={form.city}
                    onChange={(event) =>
                      updateField(
                        "city",
                        event.target.value
                      )
                    }
                    required
                    autoComplete="address-level2"
                    placeholder="City"
                    className="w-full rounded-2xl border border-[#D2B48C]/70 bg-[#F9F7F2] px-4 py-3.5 text-sm text-[#3D3D3D] outline-none transition placeholder:text-[#3D3D3D]/35 focus:border-[#4A5D23] focus:ring-2 focus:ring-[#4A5D23]/10"
                  />
                </div>

                <div>
                  <label
                    htmlFor="state"
                    className="mb-2 block text-sm font-semibold text-[#3D3D3D]"
                  >
                    State
                  </label>

                  <input
                    id="state"
                    name="state"
                    type="text"
                    value={form.state}
                    onChange={(event) =>
                      updateField(
                        "state",
                        event.target.value
                      )
                    }
                    required
                    autoComplete="address-level1"
                    placeholder="State"
                    className="w-full rounded-2xl border border-[#D2B48C]/70 bg-[#F9F7F2] px-4 py-3.5 text-sm text-[#3D3D3D] outline-none transition placeholder:text-[#3D3D3D]/35 focus:border-[#4A5D23] focus:ring-2 focus:ring-[#4A5D23]/10"
                  />
                </div>

              </div>

              {/* ================================================= */}
              {/* COUNTRY + POSTAL */}
              {/* ================================================= */}

              <div className="mt-5 grid gap-5 sm:grid-cols-2">

                <div>
                  <label
                    htmlFor="country"
                    className="mb-2 block text-sm font-semibold text-[#3D3D3D]"
                  >
                    Country
                  </label>

                  <input
                    id="country"
                    name="country"
                    type="text"
                    value={form.country}
                    onChange={(event) =>
                      updateField(
                        "country",
                        event.target.value
                      )
                    }
                    required
                    autoComplete="country-name"
                    className="w-full rounded-2xl border border-[#D2B48C]/70 bg-[#F9F7F2] px-4 py-3.5 text-sm text-[#3D3D3D] outline-none transition focus:border-[#4A5D23] focus:ring-2 focus:ring-[#4A5D23]/10"
                  />
                </div>

                <div>
                  <label
                    htmlFor="postalCode"
                    className="mb-2 block text-sm font-semibold text-[#3D3D3D]"
                  >
                    Postal code
                  </label>

                  <input
                    id="postalCode"
                    name="postalCode"
                    type="text"
                    value={form.postalCode}
                    onChange={(event) =>
                      updateField(
                        "postalCode",
                        event.target.value
                      )
                    }
                    required
                    autoComplete="postal-code"
                    placeholder="Postal / PIN code"
                    className="w-full rounded-2xl border border-[#D2B48C]/70 bg-[#F9F7F2] px-4 py-3.5 text-sm text-[#3D3D3D] outline-none transition placeholder:text-[#3D3D3D]/35 focus:border-[#4A5D23] focus:ring-2 focus:ring-[#4A5D23]/10"
                  />
                </div>

              </div>

              {/* ================================================= */}
              {/* ERROR */}
              {/* ================================================= */}

              {error && (
                <div
                  role="alert"
                  className="mt-6 rounded-2xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700"
                >
                  {error}
                </div>
              )}

              {/* ================================================= */}
              {/* SUBMIT */}
              {/* ================================================= */}

              <button
                type="submit"
                className="mt-7 w-full rounded-full bg-[#4A5D23] px-6 py-4 text-sm font-semibold text-white transition hover:-translate-y-0.5 hover:bg-[#3D4D1D] hover:shadow-lg active:translate-y-0"
              >
                Continue to Review →
              </button>

              <p className="mt-4 text-center text-xs text-[#3D3D3D]/50">
                You will have a chance to review your order
                before continuing to payment.
              </p>

            </section>

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

                {/* ================================================= */}
                {/* ITEMS */}
                {/* ================================================= */}

                <div className="mt-6 divide-y divide-[#D2B48C]/30">

                  {items.map((item) => (
                    <div
                      key={item.cartItemId}
                      className="flex gap-4 py-4 first:pt-0 last:pb-0"
                    >
                      <div className="flex-1">
                        <p className="font-medium text-[#3D3D3D]">
                          {item.name}
                        </p>

                        {item.customization && (
                          <p className="mt-1 text-xs text-[#8B4513]">
                            {item.customization.type ===
                            "custom"
                              ? "Custom"
                              : "Standard"}
                          </p>
                        )}

                        <p className="mt-1 text-xs text-[#3D3D3D]/55">
                          ₹{item.price.toFixed(2)} ×{" "}
                          {item.quantity}
                        </p>
                      </div>

                      <p className="whitespace-nowrap text-sm font-semibold text-[#3D3D3D]">
                        ₹
                        {(item.price * item.quantity).toLocaleString(
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

                {/* ================================================= */}
                {/* TOTALS */}
                {/* ================================================= */}

                <div className="mt-6 border-t border-[#D2B48C]/40 pt-5">

                  <div className="flex justify-between text-sm text-[#3D3D3D]/65">
                    <span>Subtotal</span>

                    <span>
                      ₹
                      {subtotal.toLocaleString("en-IN", {
                        minimumFractionDigits: 2,
                        maximumFractionDigits: 2,
                      })}
                    </span>
                  </div>

                  <div className="mt-3 flex justify-between text-sm text-[#3D3D3D]/65">
                    <span>Shipping</span>

                    <span>Calculated later</span>
                  </div>

                  <div className="mt-5 flex items-end justify-between border-t border-[#D2B48C]/30 pt-5">
                    <div>
                      <p className="text-sm text-[#3D3D3D]/60">
                        Current total
                      </p>

                      <p className="mt-1 font-serif text-3xl text-[#4A5D23]">
                        ₹
                        {subtotal.toLocaleString("en-IN", {
                          minimumFractionDigits: 2,
                          maximumFractionDigits: 2,
                        })}
                      </p>
                    </div>
                  </div>

                </div>

              </section>

              {/* ================================================= */}
              {/* TRUST MESSAGE */}
              {/* ================================================= */}

              <div className="mt-5 rounded-2xl border border-[#D2B48C]/40 bg-[#EDE5D4]/60 p-5">
                <p className="text-sm font-semibold text-[#4A5D23]">
                  Thoughtfully made.
                </p>

                <p className="mt-1 text-xs leading-5 text-[#3D3D3D]/60">
                  Your order details will be verified before
                  payment and final confirmation.
                </p>
              </div>

            </aside>

          </div>
        </form>

      </div>
    </main>
  );
}