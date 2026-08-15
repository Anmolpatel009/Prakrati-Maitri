import Link from "next/link";
import { notFound } from "next/navigation";
import { createClient } from "@/lib/supabase/server";

type OrderDetailsPageProps = {
  params: Promise<{
    id: string;
  }>;
};

function formatCurrency(value: number) {
  return `₹${value.toLocaleString("en-IN", {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  })}`;
}

function formatDate(value: string) {
  return new Date(value).toLocaleString("en-IN", {
    dateStyle: "medium",
    timeStyle: "short",
  });
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

export default async function OrderDetailsPage({
  params,
}: OrderDetailsPageProps) {
  const { id } = await params;

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
              You must be logged in to view your order
              details.
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
  // FETCH ORDER
  // =====================================================

  const { data: order, error } = await supabase
    .from("orders")
    .select(`
      id,
      user_id,
      status,
      subtotal,
      shipping_fee,
      total,
      shipping_first_name,
      shipping_last_name,
      shipping_phone,
      shipping_address,
      shipping_city,
      shipping_state,
      shipping_country,
      shipping_postal_code,
      created_at,
      updated_at,
      order_items (
        id,
        product_id,
        product_name,
        product_sku,
        quantity,
        unit_price,
        line_total,
        created_at
      )
    `)
    .eq("id", id)
    .eq("user_id", user.id)
    .single();

  if (error || !order) {
    notFound();
  }

  // =====================================================
  // PREPARE DISPLAY VALUES
  // =====================================================

  const subtotal = Number(order.subtotal);
  const shippingFee = Number(order.shipping_fee);
  const total = Number(order.total);

  // =====================================================
  // PAGE
  // =====================================================

  return (
    <main className="min-h-screen bg-[#F9F7F2] px-5 py-10 sm:px-8 lg:py-14">
      <div className="mx-auto max-w-6xl">

        {/* ================================================= */}
        {/* TOP NAVIGATION */}
        {/* ================================================= */}

        <div className="mb-7">
          <Link
            href="/account/orders"
            className="text-sm text-[#3D3D3D]/60 transition hover:text-[#4A5D23]"
          >
            ← Back to My Orders
          </Link>
        </div>

        {/* ================================================= */}
        {/* ORDER HEADER */}
        {/* ================================================= */}

        <section className="overflow-hidden rounded-3xl border border-[#D2B48C]/50 bg-white shadow-sm">

          <div className="bg-[#EDE5D4] px-6 py-9 sm:px-9 sm:py-11">

            <div className="flex flex-col gap-6 sm:flex-row sm:items-start sm:justify-between">

              <div>
                <p className="text-xs font-semibold uppercase tracking-[0.25em] text-[#4A5D23]">
                  Order Details
                </p>

                <h1 className="mt-2 font-serif text-4xl text-[#4A5D23] sm:text-5xl">
                  Order #{order.id.slice(0, 8)}
                </h1>

                <p className="mt-3 text-sm text-[#3D3D3D]/60">
                  Placed on {formatDate(order.created_at)}
                </p>
              </div>

              <span
                className={`inline-flex w-fit rounded-full px-4 py-2 text-sm font-semibold ${getStatusClasses(
                  order.status
                )}`}
              >
                {formatStatus(order.status)}
              </span>

            </div>

          </div>

          {/* ORDER ID */}

          <div className="border-t border-[#D2B48C]/30 px-6 py-5 sm:px-9">
            <p className="text-xs font-semibold uppercase tracking-[0.15em] text-[#3D3D3D]/45">
              Order ID
            </p>

            <p className="mt-1 break-all font-mono text-xs text-[#3D3D3D]/65 sm:text-sm">
              {order.id}
            </p>
          </div>

        </section>

        {/* ================================================= */}
        {/* MAIN GRID */}
        {/* ================================================= */}

        <div className="mt-8 grid gap-8 lg:grid-cols-[1.4fr_0.8fr]">

          {/* ================================================= */}
          {/* LEFT COLUMN */}
          {/* ================================================= */}

          <div className="space-y-8">

            {/* ================================================= */}
            {/* ITEMS */}
            {/* ================================================= */}

            <section className="rounded-3xl border border-[#D2B48C]/50 bg-white p-6 shadow-sm sm:p-8">

              <div className="border-b border-[#D2B48C]/30 pb-6">
                <p className="text-xs font-semibold uppercase tracking-[0.2em] text-[#4A5D23]">
                  Products
                </p>

                <h2 className="mt-2 font-serif text-3xl text-[#4A5D23]">
                  Items in Your Order
                </h2>
              </div>

              <div className="mt-2 divide-y divide-[#D2B48C]/30">

                {order.order_items.map((item) => (
                  <article
                    key={item.id}
                    className="py-6 first:pt-6 last:pb-2"
                  >
                    <div className="flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">

                      <div className="min-w-0">

                        <h3 className="text-base font-semibold text-[#3D3D3D]">
                          {item.product_name}
                        </h3>

                        {item.product_sku && (
                          <p className="mt-1 text-xs text-[#3D3D3D]/45">
                            SKU: {item.product_sku}
                          </p>
                        )}

                        <p className="mt-3 text-sm text-[#3D3D3D]/60">
                          {formatCurrency(
                            Number(item.unit_price)
                          )}{" "}
                          × {item.quantity}
                        </p>

                      </div>

                      <div className="shrink-0 sm:text-right">

                        <p className="text-lg font-semibold text-[#3D3D3D]">
                          {formatCurrency(
                            Number(item.line_total)
                          )}
                        </p>

                        <p className="mt-1 text-xs text-[#3D3D3D]/45">
                          {item.quantity}{" "}
                          {item.quantity === 1
                            ? "unit"
                            : "units"}
                        </p>

                      </div>

                    </div>
                  </article>
                ))}

              </div>

            </section>

            {/* ================================================= */}
            {/* DELIVERY */}
            {/* ================================================= */}

            <section className="rounded-3xl border border-[#D2B48C]/50 bg-white p-6 shadow-sm sm:p-8">

              <div className="border-b border-[#D2B48C]/30 pb-6">
                <p className="text-xs font-semibold uppercase tracking-[0.2em] text-[#4A5D23]">
                  Delivery
                </p>

                <h2 className="mt-2 font-serif text-3xl text-[#4A5D23]">
                  Shipping Information
                </h2>
              </div>

              <div className="mt-6 grid gap-6 sm:grid-cols-2">

                <div>
                  <p className="text-xs font-semibold uppercase tracking-[0.15em] text-[#3D3D3D]/45">
                    Recipient
                  </p>

                  <p className="mt-2 text-sm font-semibold text-[#3D3D3D]">
                    {order.shipping_first_name}{" "}
                    {order.shipping_last_name}
                  </p>

                  <p className="mt-2 text-sm text-[#3D3D3D]/65">
                    {order.shipping_phone}
                  </p>
                </div>

                <div>
                  <p className="text-xs font-semibold uppercase tracking-[0.15em] text-[#3D3D3D]/45">
                    Address
                  </p>

                  <div className="mt-2 text-sm leading-6 text-[#3D3D3D]/70">
                    <p>{order.shipping_address}</p>

                    <p>
                      {order.shipping_city},{" "}
                      {order.shipping_state}
                    </p>

                    <p>
                      {order.shipping_country} -{" "}
                      {order.shipping_postal_code}
                    </p>
                  </div>
                </div>

              </div>

            </section>

            {/* ================================================= */}
            {/* ORDER TIMELINE */}
            {/* ================================================= */}

            <section className="rounded-3xl border border-[#D2B48C]/50 bg-white p-6 shadow-sm sm:p-8">

              <p className="text-xs font-semibold uppercase tracking-[0.2em] text-[#4A5D23]">
                Order Progress
              </p>

              <h2 className="mt-2 font-serif text-3xl text-[#4A5D23]">
                What's Happening
              </h2>

              <div className="mt-7 space-y-6">

                <div className="flex gap-4">
                  <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-[#4A5D23] text-sm font-bold text-white">
                    ✓
                  </div>

                  <div>
                    <p className="font-semibold text-[#3D3D3D]">
                      Order placed
                    </p>

                    <p className="mt-1 text-xs leading-5 text-[#3D3D3D]/55">
                      Your order has been successfully
                      received.
                    </p>
                  </div>
                </div>

                <div className="flex gap-4">
                  <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-[#EDE5D4] text-sm font-bold text-[#4A5D23]">
                    2
                  </div>

                  <div>
                    <p className="font-semibold text-[#3D3D3D]">
                      Order processing
                    </p>

                    <p className="mt-1 text-xs leading-5 text-[#3D3D3D]/55">
                      Your order will move through
                      preparation and fulfilment.
                    </p>
                  </div>
                </div>

                <div className="flex gap-4">
                  <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-[#EDE5D4] text-sm font-bold text-[#4A5D23]">
                    3
                  </div>

                  <div>
                    <p className="font-semibold text-[#3D3D3D]">
                      Shipment
                    </p>

                    <p className="mt-1 text-xs leading-5 text-[#3D3D3D]/55">
                      Tracking information will become
                      available once your order is shipped.
                    </p>
                  </div>
                </div>

              </div>

            </section>

          </div>

          {/* ================================================= */}
          {/* RIGHT COLUMN */}
          {/* ================================================= */}

          <aside className="lg:sticky lg:top-8 lg:self-start">

            <section className="rounded-3xl border border-[#D2B48C]/50 bg-white p-6 shadow-sm sm:p-7">

              <p className="text-xs font-semibold uppercase tracking-[0.2em] text-[#4A5D23]">
                Payment Summary
              </p>

              <h2 className="mt-2 font-serif text-3xl text-[#4A5D23]">
                Order Total
              </h2>

              <div className="mt-7 space-y-4">

                <div className="flex justify-between text-sm text-[#3D3D3D]/65">
                  <span>Subtotal</span>

                  <span>
                    {formatCurrency(subtotal)}
                  </span>
                </div>

                <div className="flex justify-between text-sm text-[#3D3D3D]/65">
                  <span>Shipping</span>

                  <span>
                    {formatCurrency(shippingFee)}
                  </span>
                </div>

              </div>

              <div className="mt-6 border-t border-[#D2B48C]/40 pt-6">

                <p className="text-sm text-[#3D3D3D]/50">
                  Total
                </p>

                <p className="mt-1 font-serif text-4xl text-[#4A5D23]">
                  {formatCurrency(total)}
                </p>

              </div>

              <div className="mt-6 rounded-2xl bg-[#F9F7F2] p-4">
                <p className="text-xs leading-5 text-[#3D3D3D]/55">
                  Order last updated{" "}
                  {formatDate(order.updated_at)}.
                </p>
              </div>

            </section>

            {/* ================================================= */}
            {/* ACTIONS */}
            {/* ================================================= */}

            <div className="mt-5 space-y-3">

              <Link
                href="/account/orders"
                className="flex w-full items-center justify-center rounded-full bg-[#4A5D23] px-6 py-3.5 text-sm font-semibold text-white transition hover:-translate-y-0.5 hover:bg-[#3D4D1D] hover:shadow-lg"
              >
                View All Orders
              </Link>

              <Link
                href="/shop"
                className="flex w-full items-center justify-center rounded-full border border-[#D2B48C] bg-white px-6 py-3.5 text-sm font-semibold text-[#4A5D23] transition hover:border-[#4A5D23] hover:bg-[#F9F7F2]"
              >
                Continue Shopping
              </Link>

            </div>

          </aside>

        </div>

        {/* ================================================= */}
        {/* FOOTER */}
        {/* ================================================= */}

        <div className="mt-8">
          <Link
            href="/account/orders"
            className="text-sm text-[#3D3D3D]/55 transition hover:text-[#4A5D23]"
          >
            ← Back to My Orders
          </Link>
        </div>

      </div>
    </main>
  );
}