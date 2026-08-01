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

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
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
      setError("Your session has expired. Please log in again.");
      return;
    }

    const { error: profileError } = await supabase
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
      console.error("Profile update error:", profileError);
      setError("Unable to save your profile. Please try again.");
      return;
    }

    router.push("/account");
    router.refresh();
  }

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label htmlFor="firstName">
          First name *
        </label>

        <input
          id="firstName"
          name="firstName"
          type="text"
          value={firstName}
          onChange={(event) => setFirstName(event.target.value)}
          autoComplete="given-name"
          required
        />
      </div>

      <div>
        <label htmlFor="lastName">
          Last name
        </label>

        <input
          id="lastName"
          name="lastName"
          type="text"
          value={lastName}
          onChange={(event) => setLastName(event.target.value)}
          autoComplete="family-name"
        />
      </div>

      <div>
        <label htmlFor="phone">
          Phone number
        </label>

        <input
          id="phone"
          name="phone"
          type="tel"
          value={phone}
          onChange={(event) => setPhone(event.target.value)}
          autoComplete="tel"
        />
      </div>

      <div>
        <label htmlFor="country">
          Country *
        </label>

        <select
          id="country"
          name="country"
          value={country}
          onChange={(event) => setCountry(event.target.value)}
          required
        >
          <option value="">Select your country</option>
          <option value="India">India</option>
          <option value="United States">United States</option>
          <option value="United Kingdom">United Kingdom</option>
          <option value="United Arab Emirates">
            United Arab Emirates
          </option>
          <option value="Australia">Australia</option>
          <option value="Canada">Canada</option>
          <option value="Other">Other</option>
        </select>
      </div>

      {error && (
        <p role="alert">
          {error}
        </p>
      )}

      <button type="submit" disabled={loading}>
        {loading ? "Saving..." : "Continue"}
      </button>
    </form>
  );
}