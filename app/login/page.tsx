import Link from "next/link";
import LoginForm from "@/components/auth/LoginForm";

export default function LoginPage() {
  return (
    <main className="min-h-screen bg-[#F9F7F2] px-5 py-10 sm:px-8 lg:py-16">
      <div className="mx-auto grid max-w-6xl overflow-hidden rounded-3xl border border-[#D2B48C]/50 bg-white shadow-sm lg:grid-cols-2">

        {/* ================================================= */}
        {/* BRAND PANEL */}
        {/* ================================================= */}

        <section className="relative flex min-h-[360px] flex-col justify-between overflow-hidden bg-[#EDE5D4] p-8 sm:p-12 lg:min-h-[680px]">

          {/* Decorative circles */}

          <div className="absolute -right-24 -top-24 h-64 w-64 rounded-full border-[40px] border-[#D2B48C]/30" />

          <div className="absolute -bottom-28 -left-28 h-72 w-72 rounded-full border-[45px] border-[#4A5D23]/10" />

          <div className="relative z-10">

            <Link
              href="/"
              className="font-serif text-2xl font-semibold tracking-wide text-[#4A5D23]"
            >
              Prakratri Maitri
            </Link>

            <p className="mt-2 max-w-xs text-xs uppercase tracking-[0.2em] text-[#3D3D3D]/50">
              Sustainable · Thoughtful · Natural
            </p>

          </div>

          <div className="relative z-10 mt-16">

            <p className="text-xs font-semibold uppercase tracking-[0.25em] text-[#4A5D23]">
              Welcome Back
            </p>

            <h2 className="mt-4 max-w-md font-serif text-4xl leading-tight text-[#4A5D23] sm:text-5xl">
              Thoughtfully made.
              <br />
              Consciously chosen.
            </h2>

            <p className="mt-6 max-w-md text-sm leading-7 text-[#3D3D3D]/65">
              Sign in to manage your orders, continue
              shopping and keep your Prakratri Maitri
              journey in one place.
            </p>

          </div>

          <div className="relative z-10 mt-12 flex items-center gap-3 text-xs text-[#3D3D3D]/50">
            <span className="h-px w-10 bg-[#D2B48C]" />
            Sustainable products for conscious living
          </div>

        </section>

        {/* ================================================= */}
        {/* LOGIN PANEL */}
        {/* ================================================= */}

        <section className="flex items-center justify-center p-7 sm:p-12 lg:p-16">

          <div className="w-full max-w-md">

            <div className="mb-8">

              <p className="text-xs font-semibold uppercase tracking-[0.2em] text-[#4A5D23]">
                Account
              </p>

              <h1 className="mt-3 font-serif text-4xl text-[#4A5D23] sm:text-5xl">
                Welcome back
              </h1>

              <p className="mt-3 text-sm leading-6 text-[#3D3D3D]/60">
                Log in to your Prakratri Maitri account.
              </p>

            </div>

            {/* Login form */}

            <LoginForm />

            {/* Signup */}

            <div className="mt-8 border-t border-[#D2B48C]/30 pt-7 text-center">

              <p className="text-sm text-[#3D3D3D]/60">
                Don't have an account?
              </p>

              <Link
                href="/signup"
                className="mt-2 inline-block text-sm font-semibold text-[#4A5D23] transition hover:text-[#8B4513]"
              >
                Create an account →
              </Link>

            </div>

            {/* Continue shopping */}

            <div className="mt-6 text-center">

              <Link
                href="/shop"
                className="text-xs text-[#3D3D3D]/45 transition hover:text-[#4A5D23]"
              >
                ← Continue Shopping
              </Link>

            </div>

          </div>

        </section>

      </div>

      {/* ================================================= */}
      {/* FOOTER */}
      {/* ================================================= */}

      <p className="mx-auto mt-8 max-w-6xl text-center text-xs text-[#3D3D3D]/40">
        Prakratri Maitri · Sustainable and eco-friendly
        products
      </p>

    </main>
  );
}