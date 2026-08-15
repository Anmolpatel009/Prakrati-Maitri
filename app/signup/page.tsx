import SignupForm from "@/components/auth/SignupForm";

export default function SignupPage() {
  return (
    <main className="min-h-screen bg-[#F9F7F2]">

      <div className="mx-auto grid min-h-screen max-w-6xl lg:grid-cols-2">

        {/* ================================================= */}
        {/* BRAND / INTRO PANEL */}
        {/* ================================================= */}

        <section className="relative hidden overflow-hidden bg-[#E9E0CE] lg:flex lg:flex-col lg:justify-between p-12">

          <div>
            <p className="text-xs font-semibold uppercase tracking-[0.25em] text-[#4A5D23]">
              Prakratri Maitri
            </p>

            <h2 className="mt-8 max-w-md font-serif text-5xl leading-tight text-[#4A5D23]">
              Thoughtful products,
              <br />
              made with purpose.
            </h2>

            <p className="mt-6 max-w-md text-base leading-7 text-[#3D3D3D]/65">
              Create your account and discover thoughtfully
              selected products made for everyday moments.
            </p>
          </div>

          <p className="text-xs text-[#3D3D3D]/45">
            Sustainable choices. Meaningful products.
          </p>

        </section>

        {/* ================================================= */}
        {/* SIGNUP */}
        {/* ================================================= */}

        <section className="flex items-center justify-center px-6 py-16 sm:px-10 lg:px-16">

          <div className="w-full max-w-md">

            {/* Heading */}

            <div className="mb-8">

              <p className="text-xs font-semibold uppercase tracking-[0.25em] text-[#4A5D23]">
                Account
              </p>

              <h1 className="mt-4 font-serif text-4xl leading-tight text-[#4A5D23] sm:text-5xl">
                Create your account
              </h1>

              <p className="mt-4 text-sm leading-6 text-[#3D3D3D]/60">
                Join Prakratri Maitri and start exploring
                our thoughtfully selected collection.
              </p>

            </div>

            {/* Form */}

            <SignupForm />

          </div>

        </section>

      </div>

    </main>
  );
}