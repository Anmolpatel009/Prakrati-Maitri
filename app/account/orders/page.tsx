import Link from "next/link";
import { createClient } from "@/lib/supabase/server";

function formatCurrency(value: number) {
  return `₹${value.toLocaleString("en-IN", {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  })}`;
}

function formatStatus(status: string) {
  return status
    .replace(/_/g, " ")
    .replace(/\b\w/g, (char) => char.toUpperCase());
}

function getStatusClasses(status: string) {
  switch (status.toLowerCase()) {
    case "completed":
    case "delivered":
      return "bg-[#E8F5E9] text-[#4A5D23]";

    case "cancelled":
    case "canceled":
    case "failed":
      return "bg-red-50 text-red-700";

    case "processing":
    case "confirmed":
      return "bg-blue-50 text-blue-700";

    case "shipped":
      return "bg-purple-50 text-purple-700";

    default:
      return "bg-[#F1EDE3] text-[#3D3D3D]/70";
  }
}

export default async function OrdersPage() {
  const supabase = await createClient();

  // =====================================================
  // AUTHENTICATION
  // =====================================================

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return (
      <main className="min-h-screen bg-[#F9F7F2] px-5 py-16 sm:px-8">
        <div className="mx-auto max-w-2xl">
          <div className="rounded-3xl border border-[#D2B48C]/50 bg-white p-10 text-center shadow-sm sm:p-14">

            <div className="mx-auto flex h-14 w-14 items-center justify-center rounded-full bg-[#EDE5D4] text-xl text-[#4A5D23]">
              🔒
            </div>

            <h1 className="mt-6 font-serif text-4xl text-[#4A5D23]">
              Login Required
            </h1>

            <p className="mt-4 text-sm leading-6 text-[#3D3D3D]/65">
              You must be logged in to view your
              orders.
            </p>

            <Link
              href="/login"
              className="mt-7 inline-flex rounded-full bg-[#4A5D23] px-7 py-3.5 text-sm font-semibold text-white transition hover:bg-[#3D4D1D] hover:shadow-lg"
            >
              Login
            </Link>

          </div>
        </div>
      </main>
    );
  }

  // =====================================================
  // FETCH ORDERS
  // =====================================================

  const { data: orders, error } = await supabase
    .from("orders")
    .select(`
      id,
      status,
      subtotal,
      shipping_fee,
      total,
      created_at,
      order_items (
        id,
        product_name,
        product_sku,
        quantity,
        unit_price,
        line_total
      )
    `)
    .eq("user_id", user.id)
    .order("created_at", {
      ascending: false,
    });

  // =====================================================
  // ERROR
  // =====================================================

  if (error) {
    console.error(
      "Orders fetch error:",
      error
    );

    return (
      <main className="min-h-screen bg-[#F9F7F2] px-5 py-16 sm:px-8">
        <div className="mx-auto max-w-2xl">
          <div className="rounded-3xl border border-red-200 bg-white p-10 text-center shadow-sm sm:p-14">

            <div className="mx-auto flex h-14 w-14 items-center justify-center rounded-full bg-red-50 text-xl text-red-600">
              !
            </div>

            <h1 className="mt-6 font-serif text-4xl text-[#4A5D23]">
              Unable to Load Orders
            </h1>

            <p className="mt-4 text-sm leading-6 text-[#3D3D3D]/65">
              Something went wrong while loading your
              orders. Please try again later.
            </p>

            <Link
              href="/account"
              className="mt-7 inline-flex rounded-full bg-[#4A5D23] px-7 py-3.5 text-sm font-semibold text-white transition hover:bg-[#3D4D1D]"
            >
              ← Back to Account
            </Link>

          </div>
        </div>
      </main>
    );
  }

  // =====================================================
  // EMPTY ORDERS
  // =====================================================

  if (!orders || orders.length === 0) {
    return (
      <main className="min-h-screen bg-[#F9F7F2] px-5 py-10 sm:px-8 lg:py-14">
        <div className="mx-auto max-w-5xl">

          <Link
            href="/account"
            className="text-sm text-[#3D3D3D]/60 transition hover:text-[#4A5D23]"
          >
            ← Back to Account
          </Link>

          <section className="mt-7 overflow-hidden rounded-3xl border border-[#D2B48C]/50 bg-white shadow-sm">

            <div className="bg-[#EDE5D4] px-6 py-12 text-center sm:px-10 sm:py-16">

              <div className="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-[#4A5D23] text-2xl text-white">
                📦
              </div>

              <p className="mt-6 text-xs font-semibold uppercase tracking-[0.25em] text-[#4A5D23]">
                My Orders
              </p>

              <h1 className="mt-3 font-serif text-4xl text-[#4A5D23] sm:text-5xl">
                No Orders Yet
              </h1>

              <p className="mx-auto mt-4 max-w-md text-sm leading-6 text-[#3D3D3D]/65">
                You haven't placed any orders yet.
                Explore our collection and find something
                you love.
              </p>

              <Link
                href="/shop"
                className="mt-8 inline-flex rounded-full bg-[#4A5D23] px-8 py-3.5 text-sm font-semibold text-white transition hover:-translate-y-0.5 hover:bg-[#3D4D1D] hover:shadow-lg"
              >
                Start Shopping
              </Link>

            </div>

          </section>

        </div>
      </main>
    );
  }

  // =====================================================
  // ORDERS PAGE
  // =====================================================

  return (
    <main className="min-h-screen bg-[#F9F7F2] px-5 py-10 sm:px-8 lg:py-14">
      <div className="mx-auto max-w-6xl">

        {/* ================================================= */}
        {/* HEADER */}
        {/* ================================================= */}

        <div className="mb-8">

          <Link
            href="/account"
            className="text-sm text-[#3D3D3D]/60 transition hover:text-[#4A5D23]"
          >
            ← Back to Account
          </Link>

          <div className="mt-7 rounded-3xl border border-[#D2B48C]/50 bg-[#EDE5D4] px-6 py-10 sm:px-10">

            <p className="text-xs font-semibold uppercase tracking-[0.25em] text-[#4A5D23]">
              Account
            </p>

            <div className="mt-2 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">

              <div>
                <h1 className="font-serif text-4xl text-[#4A5D23] sm:text-5xl">
                  My Orders
                </h1>

                <p className="mt-3 text-sm text-[#3D3D3D]/60">
                  View and track your Prakrati Maitri
                  orders.
                </p>
              </div>

              <span className="w-fit rounded-full bg-white/70 px-4 py-2 text-xs font-semibold text-[#4A5D23]">
                {orders.length}{" "}
                {orders.length === 1
                  ? "order"
                  : "orders"}
              </span>

            </div>

          </div>

        </div>

        {/* ================================================= */}
        {/* ORDER LIST */}
        {/* ================================================= */}

        <section className="space-y-6">

          {orders.map((order) => {

            const itemCount =
              order.order_items?.reduce(
                (count, item) =>
                  count + item.quantity,
                0
              ) ?? 0;

            return (
              <article
                key={order.id}
                className="overflow-hidden rounded-3xl border border-[#D2B48C]/50 bg-white shadow-sm transition hover:shadow-md"
              >

                {/* ORDER HEADER */}

                <div className="border-b border-[#D2B48C]/30 px-6 py-6 sm:px-8">

                  <div className="flex flex-col gap-5 sm:flex-row sm:items-start sm:justify-between">

                    <div>

                      <div className="flex flex-wrap items-center gap-3">

                        <h2 className="font-serif text-2xl text-[#4A5D23]">
                          Order #
                          {order.id.slice(0, 8)}
                        </h2>

                        <span
                          className={`rounded-full px-3 py-1.5 text-xs font-semibold ${getStatusClasses(
                            order.status
                          )}`}
                        >
                          {formatStatus(
                            order.status
                          )}
                        </span>

                      </div>

                      <p className="mt-2 text-xs text-[#3D3D3D]/50">
                        Placed on{" "}
                        {new Date(
                          order.created_at
                        ).toLocaleDateString(
                          "en-IN",
                          {
                            day: "numeric",
                            month: "long",
                            year: "numeric",
                          }
                        )}
                      </p>

                    </div>

                    <div className="sm:text-right">

                      <p className="text-xs uppercase tracking-[0.15em] text-[#3D3D3D]/40">
                        Order Total
                      </p>

                      <p className="mt-1 font-serif text-2xl text-[#4A5D23]">
                        {formatCurrency(
                          Number(order.total)
                        )}
                      </p>

                    </div>

                  </div>

                </div>

                {/* ORDER CONTENT */}

                <div className="px-6 py-6 sm:px-8">

                  <div className="space-y-4">

                    {order.order_items
                      ?.slice(0, 3)
                      .map((item) => (
                        <div
                          key={item.id}
                          className="flex items-center justify-between gap-5 rounded-2xl bg-[#F9F7F2] px-4 py-4"
                        >

                          <div className="min-w-0">

                            <p className="truncate text-sm font-semibold text-[#3D3D3D]">
                              {item.product_name}
                            </p>

                            {item.product_sku && (
                              <p className="mt-1 text-xs text-[#3D3D3D]/45">
                                SKU:{" "}
                                {item.product_sku}
                              </p>
                            )}

                            <p className="mt-1 text-xs text-[#3D3D3D]/55">
                              {item.quantity}{" "}
                              {item.quantity === 1
                                ? "unit"
                                : "units"}
                            </p>

                          </div>

                          <p className="shrink-0 text-sm font-semibold text-[#3D3D3D]">
                            {formatCurrency(
                              Number(
                                item.line_total
                              )
                            )}
                          </p>

                        </div>
                      ))}

                  </div>

                  {/* MORE ITEMS */}

                  {itemCount > 3 && (
                    <p className="mt-4 text-xs text-[#3D3D3D]/50">
                      +{" "}
                      {itemCount - 3} more{" "}
                      {itemCount - 3 === 1
                        ? "unit"
                        : "units"}{" "}
                      in this order
                    </p>
                  )}

                  {/* SUMMARY */}

                  <div className="mt-6 grid gap-4 border-t border-[#D2B48C]/30 pt-6 sm:grid-cols-3">

                    <div>
                      <p className="text-xs uppercase tracking-[0.15em] text-[#3D3D3D]/40">
                        Items
                      </p>

                      <p className="mt-1 text-sm font-semibold text-[#3D3D3D]">
                        {itemCount}{" "}
                        {itemCount === 1
                          ? "unit"
                          : "units"}
                      </p>
                    </div>

                    <div>
                      <p className="text-xs uppercase tracking-[0.15em] text-[#3D3D3D]/40">
                        Subtotal
                      </p>

                      <p className="mt-1 text-sm font-semibold text-[#3D3D3D]">
                        {formatCurrency(
                          Number(
                            order.subtotal
                          )
                        )}
                      </p>
                    </div>

                    <div>
                      <p className="text-xs uppercase tracking-[0.15em] text-[#3D3D3D]/40">
                        Shipping
                      </p>

                      <p className="mt-1 text-sm font-semibold text-[#3D3D3D]">
                        {formatCurrency(
                          Number(
                            order.shipping_fee
                          )
                        )}
                      </p>
                    </div>

                  </div>

                  {/* VIEW ORDER */}

                  <div className="mt-6">

                    <Link
                      href={`/account/orders/${order.id}`}
                      className="flex w-full items-center justify-center rounded-full bg-[#4A5D23] px-6 py-3.5 text-sm font-semibold text-white transition hover:-translate-y-0.5 hover:bg-[#3D4D1D] hover:shadow-lg sm:w-auto"
                    >
                      View Order Details →
                    </Link>

                  </div>

                </div>

              </article>
            );
          })}

        </section>

        {/* ================================================= */}
        {/* BOTTOM ACTION */}
        {/* ================================================= */}

        <div className="mt-8 flex flex-col gap-3 sm:flex-row">

          <Link
            href="/account"
            className="flex items-center justify-center rounded-full border border-[#D2B48C] bg-white px-6 py-3.5 text-sm font-semibold text-[#4A5D23] transition hover:border-[#4A5D23]"
          >
            ← Back to Account
          </Link>

          <Link
            href="/shop"
            className="flex items-center justify-center rounded-full bg-[#8B4513] px-6 py-3.5 text-sm font-semibold text-white transition hover:bg-[#71370F]"
          >
            Continue Shopping
          </Link>

        </div>

      </div>
    </main>
  );
}