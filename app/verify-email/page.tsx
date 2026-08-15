import Link from "next/link";

export default function VerifyEmailPage() {
  return (
    <main className="min-h-screen bg-[#F9F7F2]">

      <div className="mx-auto grid min-h-screen max-w-6xl lg:grid-cols-2">

        {/* ================================================= */}
        {/* BRAND PANEL */}
        {/* ================================================= */}

        <section className="relative hidden overflow-hidden bg-[#E9E0CE] lg:flex lg:flex-col lg:justify-between p-12">

          <div>
            <p className="text-xs font-semibold uppercase tracking-[0.25em] text-[#4A5D23]">
              Prakratri Maitri
            </p>

            <h2 className="mt-8 max-w-md font-serif text-5xl leading-tight text-[#4A5D23]">
              Almost there.
              <br />
              One small step.
            </h2>

            <p className="mt-6 max-w-md text-base leading-7 text-[#3D3D3D]/65">
              Verify your email address to activate your
              account and continue your journey with
              Prakratri Maitri.
            </p>
          </div>

          <p className="text-xs text-[#3D3D3D]/45">
            Sustainable choices. Meaningful products.
          </p>

        </section>

        {/* ================================================= */}
        {/* VERIFICATION MESSAGE */}
        {/* ================================================= */}

        <section className="flex items-center justify-center px-6 py-16 sm:px-10 lg:px-16">

          <div className="w-full max-w-md">

            <div className="rounded-3xl border border-[#D2B48C]/50 bg-white p-8 shadow-sm sm:p-10">

              {/* ICON */}

              <div className="flex h-14 w-14 items-center justify-center rounded-full bg-[#E8F5E9] text-2xl text-[#4A5D23]">
                ✓
              </div>

              {/* HEADING */}

              <p className="mt-7 text-xs font-semibold uppercase tracking-[0.25em] text-[#4A5D23]">
                Email verification
              </p>

              <h1 className="mt-3 font-serif text-4xl leading-tight text-[#4A5D23]">
                Check your email
              </h1>

              {/* MESSAGE */}

              <p className="mt-5 text-sm leading-7 text-[#3D3D3D]/65">
                We've sent a verification link to your
                email address.
              </p>

              <p className="mt-3 text-sm leading-7 text-[#3D3D3D]/65">
                Click the link in your email to verify
                your account.
              </p>

              <div className="my-7 border-t border-[#D2B48C]/30" />

              <p className="text-sm leading-7 text-[#3D3D3D]/55">
                After verification, you can log in and
                continue.
              </p>

              {/* LOGIN */}

              <Link
                href="/login"
                className="mt-7 inline-flex w-full items-center justify-center rounded-full bg-[#4A5D23] px-6 py-3.5 text-sm font-semibold text-white transition hover:-translate-y-0.5 hover:bg-[#3D4D1D] hover:shadow-lg"
              >
                Go to login
              </Link>

            </div>

          </div>

        </section>

      </div>

    </main>
  );
}