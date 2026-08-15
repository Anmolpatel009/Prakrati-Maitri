import Link from "next/link";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import LogoutButton from "@/components/auth/LogoutButton";

export default async function AccountPage() {
  const supabase = await createClient();

  // =====================================================
  // AUTHENTICATION
  // =====================================================

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    redirect("/login");
  }

  // =====================================================
  // PROFILE
  // =====================================================

  const { data: profile } = await supabase
    .from("profiles")
    .select(
      "first_name, last_name, phone, country, onboarding_complete"
    )
    .eq("id", user.id)
    .maybeSingle();

  if (!profile?.onboarding_complete) {
    redirect("/onboarding");
  }

  const firstName = profile.first_name?.trim() || "";
  const lastName = profile.last_name?.trim() || "";

  const fullName =
    [firstName, lastName]
      .filter(Boolean)
      .join(" ") || "Customer";

  const initials =
    [firstName, lastName]
      .filter(Boolean)
      .map((name) => name.charAt(0).toUpperCase())
      .join("")
      .slice(0, 2) || "PM";

  // =====================================================
  // ACCOUNT PAGE
  // =====================================================

  return (
    <main className="min-h-screen bg-[#F9F7F2] px-5 py-10 sm:px-8 lg:py-14">
      <div className="mx-auto max-w-6xl">

        {/* ================================================= */}
        {/* HEADER */}
        {/* ================================================= */}

        <section className="overflow-hidden rounded-3xl border border-[#D2B48C]/50 bg-white shadow-sm">

          <div className="bg-[#EDE5D4] px-6 py-10 sm:px-10 sm:py-12">

            <div className="flex flex-col gap-6 sm:flex-row sm:items-center sm:justify-between">

              <div className="flex items-center gap-5">

                {/* AVATAR */}

                <div className="flex h-16 w-16 shrink-0 items-center justify-center rounded-full bg-[#4A5D23] font-serif text-xl font-semibold text-white shadow-sm">
                  {initials}
                </div>

                <div>
                  <p className="text-xs font-semibold uppercase tracking-[0.25em] text-[#4A5D23]">
                    My Account
                  </p>

                  <h1 className="mt-1 font-serif text-4xl text-[#4A5D23] sm:text-5xl">
                    Welcome
                    {firstName
                      ? `, ${firstName}`
                      : ""}
                  </h1>

                  <p className="mt-2 text-sm text-[#3D3D3D]/60">
                    Manage your profile, orders and
                    shopping activity.
                  </p>
                </div>

              </div>

              <LogoutButton />

            </div>

          </div>

        </section>

        {/* ================================================= */}
        {/* DASHBOARD CARDS */}
        {/* ================================================= */}

        <div className="mt-8 grid gap-6 md:grid-cols-2">

          {/* ================================================= */}
          {/* ORDERS */}
          {/* ================================================= */}

          <Link
            href="/account/orders"
            className="group rounded-3xl border border-[#D2B48C]/50 bg-white p-7 shadow-sm transition hover:-translate-y-1 hover:border-[#4A5D23]/50 hover:shadow-md"
          >
            <div className="flex items-start justify-between">

              <div className="flex h-12 w-12 items-center justify-center rounded-2xl bg-[#EDE5D4] text-xl text-[#4A5D23]">
                📦
              </div>

              <span className="text-xl text-[#3D3D3D]/30 transition group-hover:translate-x-1 group-hover:text-[#4A5D23]">
                →
              </span>

            </div>

            <h2 className="mt-6 font-serif text-3xl text-[#4A5D23]">
              My Orders
            </h2>

            <p className="mt-2 max-w-md text-sm leading-6 text-[#3D3D3D]/60">
              View your previous orders, order status,
              delivery details and order totals.
            </p>

            <p className="mt-5 text-sm font-semibold text-[#4A5D23]">
              View orders →
            </p>

          </Link>

          {/* ================================================= */}
          {/* SHOP */}
          {/* ================================================= */}

          <Link
            href="/shop"
            className="group rounded-3xl border border-[#D2B48C]/50 bg-white p-7 shadow-sm transition hover:-translate-y-1 hover:border-[#4A5D23]/50 hover:shadow-md"
          >
            <div className="flex items-start justify-between">

              <div className="flex h-12 w-12 items-center justify-center rounded-2xl bg-[#EDE5D4] text-xl text-[#4A5D23]">
                🛍
              </div>

              <span className="text-xl text-[#3D3D3D]/30 transition group-hover:translate-x-1 group-hover:text-[#4A5D23]">
                →
              </span>

            </div>

            <h2 className="mt-6 font-serif text-3xl text-[#4A5D23]">
              Continue Shopping
            </h2>

            <p className="mt-2 max-w-md text-sm leading-6 text-[#3D3D3D]/60">
              Explore our collections and discover
              thoughtfully made products.
            </p>

            <p className="mt-5 text-sm font-semibold text-[#4A5D23]">
              Explore Shop →
            </p>

          </Link>

        </div>

        {/* ================================================= */}
        {/* ACCOUNT INFORMATION */}
        {/* ================================================= */}

        <section className="mt-8 rounded-3xl border border-[#D2B48C]/50 bg-white p-6 shadow-sm sm:p-8">

          <div className="border-b border-[#D2B48C]/30 pb-6">

            <p className="text-xs font-semibold uppercase tracking-[0.2em] text-[#4A5D23]">
              Profile
            </p>

            <h2 className="mt-2 font-serif text-3xl text-[#4A5D23]">
              Account Information
            </h2>

          </div>

          <div className="mt-7 grid gap-6 sm:grid-cols-2 lg:grid-cols-3">

            {/* NAME */}

            <div>
              <p className="text-xs font-semibold uppercase tracking-[0.15em] text-[#3D3D3D]/45">
                Name
              </p>

              <p className="mt-2 text-sm font-semibold text-[#3D3D3D]">
                {fullName}
              </p>
            </div>

            {/* EMAIL */}

            <div>
              <p className="text-xs font-semibold uppercase tracking-[0.15em] text-[#3D3D3D]/45">
                Email
              </p>

              <p className="mt-2 break-all text-sm text-[#3D3D3D]/70">
                {user.email || "Not available"}
              </p>
            </div>

            {/* PHONE */}

            <div>
              <p className="text-xs font-semibold uppercase tracking-[0.15em] text-[#3D3D3D]/45">
                Phone
              </p>

              <p className="mt-2 text-sm text-[#3D3D3D]/70">
                {profile.phone || "Not provided"}
              </p>
            </div>

            {/* COUNTRY */}

            <div>
              <p className="text-xs font-semibold uppercase tracking-[0.15em] text-[#3D3D3D]/45">
                Country
              </p>

              <p className="mt-2 text-sm text-[#3D3D3D]/70">
                {profile.country || "Not provided"}
              </p>
            </div>

            {/* ACCOUNT STATUS */}

            <div>
              <p className="text-xs font-semibold uppercase tracking-[0.15em] text-[#3D3D3D]/45">
                Account Status
              </p>

              <span className="mt-2 inline-flex rounded-full bg-[#E8F5E9] px-3 py-1.5 text-xs font-semibold text-[#4A5D23]">
                Active
              </span>
            </div>

            {/* ONBOARDING */}

            <div>
              <p className="text-xs font-semibold uppercase tracking-[0.15em] text-[#3D3D3D]/45">
                Profile Setup
              </p>

              <span className="mt-2 inline-flex rounded-full bg-[#E8F5E9] px-3 py-1.5 text-xs font-semibold text-[#4A5D23]">
                Complete
              </span>
            </div>

          </div>

        </section>

        {/* ================================================= */}
        {/* QUICK NAVIGATION */}
        {/* ================================================= */}

        <section className="mt-8 rounded-3xl border border-[#D2B48C]/50 bg-[#EDE5D4]/60 p-6 sm:p-8">

          <p className="text-xs font-semibold uppercase tracking-[0.2em] text-[#4A5D23]">
            Quick Navigation
          </p>

          <div className="mt-5 flex flex-col gap-3 sm:flex-row">

            <Link
              href="/account/orders"
              className="flex flex-1 items-center justify-center rounded-full bg-[#4A5D23] px-6 py-3.5 text-sm font-semibold text-white transition hover:bg-[#3D4D1D] hover:shadow-lg"
            >
              View My Orders
            </Link>

            <Link
              href="/shop"
              className="flex flex-1 items-center justify-center rounded-full border border-[#D2B48C] bg-white px-6 py-3.5 text-sm font-semibold text-[#4A5D23] transition hover:border-[#4A5D23]"
            >
              Continue Shopping
            </Link>

          </div>

        </section>

        {/* ================================================= */}
        {/* FOOTER */}
        {/* ================================================= */}

        <p className="mt-8 text-center text-xs text-[#3D3D3D]/40">
          Prakrati Maitri · Thoughtfully made, consciously
          chosen.
        </p>

      </div>
    </main>
  );
}