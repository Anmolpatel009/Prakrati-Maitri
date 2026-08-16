"use client";

import { FormEvent, useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

type Profile = {
  first_name: string | null;
  last_name: string | null;
  phone: string | null;
  country: string | null;
  onboarding_complete: boolean | null;
};

type OnboardingFormProps = {
  initialProfile: Profile | null;
};

export default function OnboardingForm({
  initialProfile,
}: OnboardingFormProps) {
  const router = useRouter();
  const supabase = createClient();

  const [firstName, setFirstName] = useState(
    initialProfile?.first_name ?? ""
  );

  const [lastName, setLastName] = useState(
    initialProfile?.last_name ?? ""
  );

  const [phone, setPhone] = useState(
    initialProfile?.phone ?? ""
  );

  const [country, setCountry] = useState(
    initialProfile?.country ?? ""
  );

  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  async function handleSubmit(
    event: FormEvent<HTMLFormElement>
  ) {
    event.preventDefault();

    setError("");

    if (!firstName.trim()) {
      setError("Please enter your first name.");
      return;
    }

    if (!country) {
      setError("Please select your country.");
      return;
    }

    setLoading(true);

    const {
      data: { user },
      error: userError,
    } = await supabase.auth.getUser();

    if (userError || !user) {
      setLoading(false);
      setError(
        "Your session has expired. Please log in again."
      );
      return;
    }

    const { error: profileError } =
      await supabase
        .from("profiles")
        .upsert(
          {
            id: user.id,
            first_name: firstName.trim(),
            last_name: lastName.trim() || null,
            phone: phone.trim() || null,
            country,
            onboarding_complete: true,
            updated_at: new Date().toISOString(),
          },
          {
            onConflict: "id",
          }
        );

    setLoading(false);

    if (profileError) {
      console.error(
        "Profile update error:",
        profileError
      );

      setError(
        "Unable to save your profile. Please try again."
      );

      return;
    }

    router.push("/account");
    router.refresh();
  }

  return (
    <form
      onSubmit={handleSubmit}
      className="space-y-6"
    >
      {/* ================================================= */}
      {/* INTRO */}
      {/* ================================================= */}

      <div className="rounded-2xl bg-[#F9F7F2] px-4 py-4">
        <p className="text-sm leading-6 text-[#3D3D3D]/65">
          These details help us keep your account and
          delivery information ready when you shop with
          us.
        </p>

        <p className="mt-2 text-xs text-[#3D3D3D]/45">
          Fields marked with * are required.
        </p>
      </div>

      {/* ================================================= */}
      {/* FIRST NAME */}
      {/* ================================================= */}

      <div>
        <label
          htmlFor="firstName"
          className="mb-2 block text-sm font-medium text-[#3D3D3D]"
        >
          First name <span className="text-[#8B4513]">*</span>
        </label>

        <input
          id="firstName"
          name="firstName"
          type="text"
          value={firstName}
          onChange={(event) =>
            setFirstName(event.target.value)
          }
          placeholder="Enter your first name"
          autoComplete="given-name"
          required
          disabled={loading}
          className="w-full rounded-xl border border-[#D2B48C]/70 bg-[#F9F7F2] px-4 py-3.5 text-sm text-[#3D3D3D] outline-none transition placeholder:text-[#3D3D3D]/35 focus:border-[#4A5D23] focus:bg-white focus:ring-2 focus:ring-[#4A5D23]/10 disabled:cursor-not-allowed disabled:opacity-60"
        />
      </div>

      {/* ================================================= */}
      {/* LAST NAME */}
      {/* ================================================= */}

      <div>
        <label
          htmlFor="lastName"
          className="mb-2 block text-sm font-medium text-[#3D3D3D]"
        >
          Last name
        </label>

        <input
          id="lastName"
          name="lastName"
          type="text"
          value={lastName}
          onChange={(event) =>
            setLastName(event.target.value)
          }
          placeholder="Enter your last name"
          autoComplete="family-name"
          disabled={loading}
          className="w-full rounded-xl border border-[#D2B48C]/70 bg-[#F9F7F2] px-4 py-3.5 text-sm text-[#3D3D3D] outline-none transition placeholder:text-[#3D3D3D]/35 focus:border-[#4A5D23] focus:bg-white focus:ring-2 focus:ring-[#4A5D23]/10 disabled:cursor-not-allowed disabled:opacity-60"
        />
      </div>

      {/* ================================================= */}
      {/* PHONE */}
      {/* ================================================= */}

      <div>
        <label
          htmlFor="phone"
          className="mb-2 block text-sm font-medium text-[#3D3D3D]"
        >
          Phone number
        </label>

        <input
          id="phone"
          name="phone"
          type="tel"
          value={phone}
          onChange={(event) =>
            setPhone(event.target.value)
          }
          placeholder="Enter your phone number"
          autoComplete="tel"
          inputMode="tel"
          disabled={loading}
          className="w-full rounded-xl border border-[#D2B48C]/70 bg-[#F9F7F2] px-4 py-3.5 text-sm text-[#3D3D3D] outline-none transition placeholder:text-[#3D3D3D]/35 focus:border-[#4A5D23] focus:bg-white focus:ring-2 focus:ring-[#4A5D23]/10 disabled:cursor-not-allowed disabled:opacity-60"
        />

        <p className="mt-2 text-xs text-[#3D3D3D]/45">
          Used for delivery-related communication.
        </p>
      </div>

      {/* ================================================= */}
      {/* COUNTRY */}
      {/* ================================================= */}

      <div>
        <label
          htmlFor="country"
          className="mb-2 block text-sm font-medium text-[#3D3D3D]"
        >
          Country <span className="text-[#8B4513]">*</span>
        </label>

        <select
          id="country"
          name="country"
          value={country}
          onChange={(event) =>
            setCountry(event.target.value)
          }
          required
          disabled={loading}
          className={`w-full appearance-none rounded-xl border border-[#D2B48C]/70 bg-[#F9F7F2] px-4 py-3.5 text-sm outline-none transition focus:border-[#4A5D23] focus:bg-white focus:ring-2 focus:ring-[#4A5D23]/10 disabled:cursor-not-allowed disabled:opacity-60 ${
            country
              ? "text-[#3D3D3D]"
              : "text-[#3D3D3D]/40"
          }`}
        >
          <option value="" disabled>
            Select your country
          </option>

          <option value="India">
            India
          </option>

          <option value="United States">
            United States
          </option>

          <option value="United Kingdom">
            United Kingdom
          </option>

          <option value="United Arab Emirates">
            United Arab Emirates
          </option>

          <option value="Australia">
            Australia
          </option>

          <option value="Canada">
            Canada
          </option>

          <option value="Other">
            Other
          </option>
        </select>
      </div>

      {/* ================================================= */}
      {/* ERROR */}
      {/* ================================================= */}

      {error && (
        <div
          role="alert"
          className="rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm leading-6 text-red-700"
        >
          {error}
        </div>
      )}

      {/* ================================================= */}
      {/* SUBMIT */}
      {/* ================================================= */}

      <button
        type="submit"
        disabled={loading}
        className="w-full rounded-full bg-[#4A5D23] px-6 py-3.5 text-sm font-semibold text-white transition hover:-translate-y-0.5 hover:bg-[#3D4D1D] hover:shadow-lg active:translate-y-0 disabled:cursor-not-allowed disabled:opacity-60 disabled:hover:translate-y-0 disabled:hover:shadow-none"
      >
        {loading ? (
          <span className="flex items-center justify-center gap-2">
            <span
              className="h-4 w-4 animate-spin rounded-full border-2 border-white/30 border-t-white"
              aria-hidden="true"
            />
            Saving your details...
          </span>
        ) : (
          "Continue to Account"
        )}
      </button>

      {/* ================================================= */}
      {/* PRIVACY NOTE */}
      {/* ================================================= */}

      <p className="text-center text-xs leading-5 text-[#3D3D3D]/40">
        Your information is used to manage your account
        and help with future orders.
      </p>
    </form>
  );
}