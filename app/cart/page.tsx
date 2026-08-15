"use client";

import Image from "next/image";
import Link from "next/link";
import { useCart } from "@/components/cart/CartProvider";

export default function CartPage() {
  const {
    items,
    removeItem,
    updateQuantity,
    subtotal,
    totalItems,
  } = useCart();

  // =====================================================
  // EMPTY CART
  // =====================================================

  if (items.length === 0) {
    return (
      <main className="min-h-screen bg-[#F9F7F2] px-6 py-16">
        <div className="mx-auto flex min-h-[60vh] max-w-3xl flex-col items-center justify-center text-center">
          <div className="mb-6 flex h-20 w-20 items-center justify-center rounded-full bg-[#E8F5E9] text-3xl">
            🛍️
          </div>

          <p className="text-sm font-semibold uppercase tracking-[0.2em] text-[#4A5D23]">
            Prakrati Maitri
          </p>

          <h1 className="mt-3 font-serif text-4xl text-[#4A5D23] sm:text-5xl">
            Your Cart is Empty
          </h1>

          <p className="mt-4 max-w-md text-base leading-7 text-[#3D3D3D]/65">
            Looks like you haven't added anything
            yet. Explore our collections and find
            something you love.
          </p>

          <Link
            href="/shop"
            className="mt-8 inline-flex rounded-full bg-[#4A5D23] px-8 py-3.5 text-sm font-semibold text-white transition hover:-translate-y-0.5 hover:bg-[#3D4D1D] hover:shadow-lg"
          >
            Continue Shopping
          </Link>
        </div>
      </main>
    );
  }

  // =====================================================
  // CART
  // =====================================================

  return (
    <main className="min-h-screen bg-[#F9F7F2] px-6 py-12 sm:py-16">
      <div className="mx-auto max-w-7xl">
        {/* ================================================= */}
        {/* HEADER */}
        {/* ================================================= */}

        <div className="mb-10">
          <Link
            href="/shop"
            className="text-sm font-medium text-[#4A5D23] transition hover:underline"
          >
            ← Continue Shopping
          </Link>

          <div className="mt-6">
            <p className="text-sm font-semibold uppercase tracking-[0.2em] text-[#4A5D23]">
              Your Selection
            </p>

            <h1 className="mt-2 font-serif text-4xl text-[#4A5D23] sm:text-5xl">
              Your Cart
            </h1>

            <p className="mt-3 text-[#3D3D3D]/65">
              {totalItems}{" "}
              {totalItems === 1
                ? "item"
                : "items"}{" "}
              selected
            </p>
          </div>
        </div>

        {/* ================================================= */}
        {/* MAIN GRID */}
        {/* ================================================= */}

        <div className="grid gap-8 lg:grid-cols-[1fr_380px]">
          {/* ================================================= */}
          {/* CART ITEMS */}
          {/* ================================================= */}

          <section className="space-y-5">
            {items.map((item) => {
              const itemTotal =
                item.price * item.quantity;

              const isCustom =
                item.customization?.type ===
                "custom";

              return (
                <article
                  key={item.cartItemId}
                  className="rounded-3xl border border-[#D2B48C]/50 bg-white p-5 sm:p-6"
                >
                  <div className="flex flex-col gap-5 sm:flex-row">
                    {/* PRODUCT IMAGE */}

                    <Link
                      href={`/products/${item.slug}`}
                      className="relative block h-32 w-full shrink-0 overflow-hidden rounded-2xl bg-[#F1EDE3] sm:h-36 sm:w-36"
                    >
                      {item.imageUrl ? (
                        <Image
                          src={item.imageUrl}
                          alt={item.name}
                          fill
                          sizes="144px"
                          className="object-cover"
                        />
                      ) : (
                        <div className="flex h-full items-center justify-center text-xs text-[#3D3D3D]/50">
                          Image unavailable
                        </div>
                      )}
                    </Link>

                    {/* PRODUCT DETAILS */}

                    <div className="min-w-0 flex-1">
                      <div className="flex flex-col justify-between gap-3 sm:flex-row">
                        <div>
                          <Link
                            href={`/products/${item.slug}`}
                            className="font-serif text-2xl text-[#4A5D23] transition hover:underline"
                          >
                            {item.name}
                          </Link>

                          {/* PURCHASE TYPE */}

                          <div className="mt-2">
                            <span
                              className={`inline-flex rounded-full px-3 py-1 text-xs font-semibold ${
                                isCustom
                                  ? "bg-[#F3E6DC] text-[#8B4513]"
                                  : "bg-[#E8F5E9] text-[#4A5D23]"
                              }`}
                            >
                              {isCustom
                                ? "Custom Bag"
                                : "Standard Bag"}
                            </span>
                          </div>
                        </div>

                        {/* PRICE */}

                        <div className="text-left sm:text-right">
                          <p className="text-sm text-[#3D3D3D]/55">
                            ₹
                            {item.price.toFixed(
                              2
                            )}{" "}
                            / bag
                          </p>

                          <p className="mt-1 text-xl font-bold text-[#3D3D3D]">
                            ₹
                            {itemTotal.toLocaleString(
                              "en-IN",
                              {
                                minimumFractionDigits: 2,
                                maximumFractionDigits: 2,
                              }
                            )}
                          </p>
                        </div>
                      </div>

                      {/* CUSTOMIZATION DETAILS */}

                      {isCustom &&
                        item.customization && (
                          <div className="mt-4 rounded-2xl bg-[#F9F7F2] p-4">
                            <p className="text-xs font-semibold uppercase tracking-wider text-[#8B4513]">
                              Customization
                            </p>

                            {item.customization.note && (
                              <p className="mt-2 text-sm leading-6 text-[#3D3D3D]/75">
                                {
                                  item
                                    .customization
                                    .note
                                }
                              </p>
                            )}

                            {item.customization
                              .imageUrl && (
                              <p className="mt-2 text-xs text-[#4A5D23]">
                                Custom design
                                uploaded
                              </p>
                            )}
                          </div>
                        )}

                      {/* CONTROLS */}

                      <div className="mt-5 flex flex-wrap items-center justify-between gap-4">
                        {/* QUANTITY */}

                        <div>
                          <p className="mb-2 text-xs font-semibold uppercase tracking-wider text-[#3D3D3D]/55">
                            Quantity
                          </p>

                          <div className="flex h-11 items-center overflow-hidden rounded-xl border border-[#D2B48C]">
                            <button
                              type="button"
                              onClick={() =>
                                updateQuantity(
                                  item.cartItemId,
                                  item.quantity - 1
                                )
                              }
                              disabled={
                                item.quantity <=
                                1
                              }
                              className="h-full w-11 text-lg transition hover:bg-[#F1EDE3] disabled:cursor-not-allowed disabled:opacity-30"
                              aria-label={`Decrease quantity of ${item.name}`}
                            >
                              −
                            </button>

                            <input
                              type="number"
                              min={1}
                              value={
                                item.quantity
                              }
                              onChange={(event) => {
                                const value =
                                  Number(
                                    event
                                      .target
                                      .value
                                  );

                                if (
                                  Number.isFinite(
                                    value
                                  )
                                ) {
                                  updateQuantity(
                                    item.cartItemId,
                                    Math.max(
                                      1,
                                      Math.floor(
                                        value
                                      )
                                    )
                                  );
                                }
                              }}
                              className="h-full w-16 border-x border-[#D2B48C] bg-transparent text-center text-sm font-semibold outline-none"
                              aria-label={`Quantity of ${item.name}`}
                            />

                            <button
                              type="button"
                              onClick={() =>
                                updateQuantity(
                                  item.cartItemId,
                                  item.quantity + 1
                                )
                              }
                              className="h-full w-11 text-lg transition hover:bg-[#F1EDE3]"
                              aria-label={`Increase quantity of ${item.name}`}
                            >
                              +
                            </button>
                          </div>
                        </div>

                        {/* REMOVE */}

                        <button
                          type="button"
                          onClick={() =>
                            removeItem(
                              item.cartItemId
                            )
                          }
                          className="text-sm font-medium text-red-700/70 transition hover:text-red-700 hover:underline"
                        >
                          Remove
                        </button>
                      </div>
                    </div>
                  </div>
                </article>
              );
            })}
          </section>

          {/* ================================================= */}
          {/* ORDER SUMMARY */}
          {/* ================================================= */}

          <aside className="lg:sticky lg:top-8 lg:self-start">
            <div className="rounded-3xl border border-[#D2B48C]/50 bg-white p-6 sm:p-7">
              <h2 className="font-serif text-2xl text-[#4A5D23]">
                Order Summary
              </h2>

              <div className="mt-6 space-y-4">
                <div className="flex justify-between gap-4 text-sm">
                  <span className="text-[#3D3D3D]/65">
                    Items
                  </span>

                  <span className="font-medium text-[#3D3D3D]">
                    {totalItems}
                  </span>
                </div>

                <div className="flex justify-between gap-4 text-sm">
                  <span className="text-[#3D3D3D]/65">
                    Subtotal
                  </span>

                  <span className="font-semibold text-[#3D3D3D]">
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

                <div className="border-t border-[#D2B48C]/40 pt-4">
                  <div className="flex items-end justify-between gap-4">
                    <span className="font-semibold text-[#3D3D3D]">
                      Total
                    </span>

                    <span className="font-serif text-3xl text-[#4A5D23]">
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
                </div>
              </div>

              <p className="mt-5 text-xs leading-5 text-[#3D3D3D]/50">
                Shipping, taxes, and any applicable
                customization charges will be
                calculated during checkout.
              </p>

              <Link
                href="/checkout"
                className="mt-6 flex w-full items-center justify-center rounded-full bg-[#4A5D23] px-6 py-4 text-sm font-semibold text-white transition hover:-translate-y-0.5 hover:bg-[#3D4D1D] hover:shadow-lg"
              >
                Proceed to Checkout
              </Link>

              <Link
                href="/shop"
                className="mt-3 flex w-full items-center justify-center rounded-full border border-[#D2B48C] px-6 py-3.5 text-sm font-semibold text-[#4A5D23] transition hover:bg-[#F1EDE3]"
              >
                Continue Shopping
              </Link>
            </div>
          </aside>
        </div>
      </div>
    </main>
  );
}