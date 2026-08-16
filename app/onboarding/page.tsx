import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import OnboardingForm from "@/components/onboarding/OnboardingForm";

export default async function OnboardingPage() {
  const supabase = await createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    redirect("/login");
  }

  const { data: profile } = await supabase
    .from("profiles")
    .select(
      "first_name, last_name, phone, country, onboarding_complete"
    )
    .eq("id", user.id)
    .maybeSingle();

  if (profile?.onboarding_complete) {
    redirect("/account");
  }

  return (
    <main className="min-h-screen bg-[#F9F7F2]">

      <div className="mx-auto grid min-h-screen max-w-6xl lg:grid-cols-2">

        {/* ================================================= */}
        {/* BRAND / INTRO PANEL */}
        {/* ================================================= */}

        <section className="relative hidden overflow-hidden bg-[#E9E0CE] lg:flex lg:flex-col lg:justify-between p-12">

          {/* Decorative shapes */}

          <div className="absolute -right-24 -top-24 h-64 w-64 rounded-full border-[40px] border-[#D2B48C]/25" />

          <div className="absolute -bottom-28 -left-28 h-72 w-72 rounded-full border-[45px] border-[#4A5D23]/10" />

          <div className="relative z-10">

            <p className="text-xs font-semibold uppercase tracking-[0.25em] text-[#4A5D23]">
              Prakratri Maitri
            </p>

            <p className="mt-2 text-xs uppercase tracking-[0.2em] text-[#3D3D3D]/45">
              Sustainable · Thoughtful · Natural
            </p>

          </div>

          <div className="relative z-10">

            <p className="text-xs font-semibold uppercase tracking-[0.25em] text-[#4A5D23]">
              Your journey starts here
            </p>

            <h2 className="mt-5 max-w-md font-serif text-5xl leading-tight text-[#4A5D23]">
              A little about you.
              <br />
              A better experience for you.
            </h2>

            <p className="mt-6 max-w-md text-base leading-7 text-[#3D3D3D]/65">
              Tell us a few details so we can personalize
              your Prakratri Maitri experience and keep
              your account information ready for future
              orders.
            </p>

          </div>

          <div className="relative z-10 flex items-center gap-3 text-xs text-[#3D3D3D]/45">
            <span className="h-px w-10 bg-[#D2B48C]" />
            Thoughtfully made. Consciously chosen.
          </div>

        </section>

        {/* ================================================= */}
        {/* ONBOARDING FORM */}
        {/* ================================================= */}

        <section className="flex items-center justify-center px-6 py-12 sm:px-10 sm:py-16 lg:px-16">

          <div className="w-full max-w-md">

            {/* Mobile brand */}

            <div className="mb-10 lg:hidden">

              <p className="text-xs font-semibold uppercase tracking-[0.25em] text-[#4A5D23]">
                Prakratri Maitri
              </p>

            </div>

            {/* Heading */}

            <div className="mb-8">

              <p className="text-xs font-semibold uppercase tracking-[0.25em] text-[#4A5D23]">
                Getting started
              </p>

              <h1 className="mt-3 font-serif text-4xl leading-tight text-[#4A5D23] sm:text-5xl">
                Welcome to Prakratri Maitri
              </h1>

              <p className="mt-4 text-sm leading-7 text-[#3D3D3D]/60">
                Tell us a little about yourself. This will
                help us keep your account and delivery
                information ready when you shop with us.
              </p>

            </div>

            {/* Form card */}

            <div className="rounded-3xl border border-[#D2B48C]/50 bg-white p-6 shadow-sm sm:p-8">

              <OnboardingForm
                initialProfile={profile}
              />

            </div>

            {/* Account email */}

            <div className="mt-6 rounded-2xl border border-[#D2B48C]/30 bg-[#EDE5D4]/40 px-4 py-3">

              <p className="text-xs text-[#3D3D3D]/50">
                Account email
              </p>

              <p className="mt-1 truncate text-sm font-medium text-[#3D3D3D]/75">
                {user.email}
              </p>

            </div>

          </div>

        </section>

      </div>

    </main>
  );
}