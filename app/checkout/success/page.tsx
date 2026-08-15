import Link from "next/link";

type SuccessPageProps = {
  searchParams: Promise<{
    order?: string;
  }>;
};

export default async function SuccessPage({
  searchParams,
}: SuccessPageProps) {
  const params = await searchParams;
  const orderId = params.order;

  return (
    <main className="min-h-screen bg-[#F9F7F2] px-5 py-12 sm:px-8 lg:py-16">
      <div className="mx-auto max-w-4xl">

        {/* ================================================= */}
        {/* SUCCESS CARD */}
        {/* ================================================= */}

        <section className="overflow-hidden rounded-3xl border border-[#D2B48C]/50 bg-white shadow-sm">

          {/* HEADER */}

          <div className="bg-[#EDE5D4] px-6 py-12 text-center sm:px-10 sm:py-16">

            <div className="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-[#4A5D23] text-2xl text-white shadow-sm">
              ✓
            </div>

            <p className="mt-6 text-xs font-semibold uppercase tracking-[0.25em] text-[#4A5D23]">
              Prakrati Maitri
            </p>

            <h1 className="mt-3 font-serif text-4xl text-[#4A5D23] sm:text-5xl">
              Order Confirmed
            </h1>

            <p className="mx-auto mt-4 max-w-xl text-sm leading-6 text-[#3D3D3D]/65 sm:text-base">
              Thank you for your order. Your order has
              been successfully created.
            </p>

          </div>

          {/* ================================================= */}
          {/* ORDER DETAILS */}
          {/* ================================================= */}

          <div className="px-6 py-8 sm:px-10 sm:py-10">

            {orderId ? (
              <div className="rounded-2xl border border-[#D2B48C]/50 bg-[#F9F7F2] p-5 sm:p-6">

                <p className="text-xs font-semibold uppercase tracking-[0.18em] text-[#3D3D3D]/50">
                  Order ID
                </p>

                <p className="mt-2 break-all font-mono text-sm font-semibold text-[#4A5D23] sm:text-base">
                  {orderId}
                </p>

                <p className="mt-3 text-xs leading-5 text-[#3D3D3D]/50">
                  Keep this order ID for your records.
                </p>

              </div>
            ) : (
              <div className="rounded-2xl border border-[#D2B48C]/50 bg-[#F9F7F2] p-5 text-sm text-[#3D3D3D]/65">
                Your order has been created successfully.
              </div>
            )}

            {/* ================================================= */}
            {/* WHAT HAPPENS NEXT */}
            {/* ================================================= */}

            <div className="mt-8">

              <p className="text-xs font-semibold uppercase tracking-[0.2em] text-[#4A5D23]">
                What's next?
              </p>

              <h2 className="mt-2 font-serif text-2xl text-[#4A5D23] sm:text-3xl">
                Your order is now with us
              </h2>

              <div className="mt-6 grid gap-4 sm:grid-cols-3">

                <div className="rounded-2xl border border-[#D2B48C]/40 bg-white p-5">
                  <div className="flex h-9 w-9 items-center justify-center rounded-full bg-[#EDE5D4] text-sm font-bold text-[#4A5D23]">
                    1
                  </div>

                  <p className="mt-4 font-semibold text-[#3D3D3D]">
                    Order received
                  </p>

                  <p className="mt-2 text-xs leading-5 text-[#3D3D3D]/55">
                    Your order has been recorded
                    successfully.
                  </p>
                </div>

                <div className="rounded-2xl border border-[#D2B48C]/40 bg-white p-5">
                  <div className="flex h-9 w-9 items-center justify-center rounded-full bg-[#EDE5D4] text-sm font-bold text-[#4A5D23]">
                    2
                  </div>

                  <p className="mt-4 font-semibold text-[#3D3D3D]">
                    Order processing
                  </p>

                  <p className="mt-2 text-xs leading-5 text-[#3D3D3D]/55">
                    Your order can now move through
                    the fulfilment workflow.
                  </p>
                </div>

                <div className="rounded-2xl border border-[#D2B48C]/40 bg-white p-5">
                  <div className="flex h-9 w-9 items-center justify-center rounded-full bg-[#EDE5D4] text-sm font-bold text-[#4A5D23]">
                    3
                  </div>

                  <p className="mt-4 font-semibold text-[#3D3D3D]">
                    Track your order
                  </p>

                  <p className="mt-2 text-xs leading-5 text-[#3D3D3D]/55">
                    View your orders from your account
                    whenever you need them.
                  </p>
                </div>

              </div>

            </div>

            {/* ================================================= */}
            {/* ACTIONS */}
            {/* ================================================= */}

            <div className="mt-9 flex flex-col gap-3 sm:flex-row">

              <Link
                href="/account/orders"
                className="inline-flex flex-1 items-center justify-center rounded-full bg-[#4A5D23] px-6 py-4 text-sm font-semibold text-white transition hover:-translate-y-0.5 hover:bg-[#3D4D1D] hover:shadow-lg"
              >
                View My Orders
              </Link>

              <Link
                href="/shop"
                className="inline-flex flex-1 items-center justify-center rounded-full border border-[#D2B48C] bg-white px-6 py-4 text-sm font-semibold text-[#4A5D23] transition hover:border-[#4A5D23] hover:bg-[#F9F7F2]"
              >
                Continue Shopping
              </Link>

            </div>

          </div>

        </section>

        {/* ================================================= */}
        {/* FOOTER MESSAGE */}
        {/* ================================================= */}

        <p className="mx-auto mt-6 max-w-xl text-center text-xs leading-5 text-[#3D3D3D]/45">
          Thoughtfully created with care by Prakrati Maitri.
        </p>

      </div>
    </main>
  );
}