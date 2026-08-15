"use client";

import { FormEvent, useState } from "react";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";

export default function SignupForm() {
  const supabase = createClient();

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [success, setSuccess] = useState(false);

  async function handleSignup(
    event: FormEvent<HTMLFormElement>
  ) {
    event.preventDefault();

    setError("");
    setSuccess(false);

    if (password.length < 8) {
      setError(
        "Password must be at least 8 characters."
      );
      return;
    }

    setLoading(true);

    const { error } =
      await supabase.auth.signUp({
        email: email.trim(),
        password,
        options: {
          emailRedirectTo:
            `${window.location.origin}/auth/callback`,
        },
      });

    setLoading(false);

    if (error) {
      setError(error.message);
      return;
    }

    setSuccess(true);
  }

  {/* ================================================= */}
  {/* SUCCESS */}
  {/* ================================================= */}

  if (success) {
    return (
      <div className="rounded-3xl border border-[#D2B48C]/50 bg-[#F9F7F2] p-7 sm:p-8">

        <div className="flex h-12 w-12 items-center justify-center rounded-full bg-[#E8F5E9] text-xl text-[#4A5D23]">
          ✓
        </div>

        <h2 className="mt-5 font-serif text-3xl text-[#4A5D23]">
          Check your email
        </h2>

        <p className="mt-4 text-sm leading-6 text-[#3D3D3D]/65">
          We sent a verification link to{" "}
          <strong className="font-semibold text-[#3D3D3D]">
            {email}
          </strong>
          .
        </p>

        <p className="mt-2 text-sm leading-6 text-[#3D3D3D]/60">
          Please verify your email before continuing.
        </p>

        <Link
          href="/login"
          className="mt-6 inline-flex rounded-full bg-[#4A5D23] px-6 py-3 text-sm font-semibold text-white transition hover:-translate-y-0.5 hover:bg-[#3D4D1D] hover:shadow-lg"
        >
          Go to login
        </Link>

      </div>
    );
  }

  {/* ================================================= */}
  {/* SIGNUP FORM */}
  {/* ================================================= */}

  return (
    <form
      onSubmit={handleSignup}
      className="space-y-5"
    >

      {/* EMAIL */}

      <div>
        <label
          htmlFor="email"
          className="mb-2 block text-sm font-medium text-[#3D3D3D]"
        >
          Email address
        </label>

        <input
          id="email"
          name="email"
          type="email"
          autoComplete="email"
          value={email}
          onChange={(event) =>
            setEmail(event.target.value)
          }
          placeholder="you@example.com"
          required
          disabled={loading}
          className="w-full rounded-xl border border-[#D2B48C]/70 bg-[#F9F7F2] px-4 py-3.5 text-sm text-[#3D3D3D] outline-none transition placeholder:text-[#3D3D3D]/35 focus:border-[#4A5D23] focus:bg-white focus:ring-2 focus:ring-[#4A5D23]/10 disabled:cursor-not-allowed disabled:opacity-60"
        />
      </div>

      {/* PASSWORD */}

      <div>
        <label
          htmlFor="password"
          className="mb-2 block text-sm font-medium text-[#3D3D3D]"
        >
          Password
        </label>

        <input
          id="password"
          name="password"
          type="password"
          autoComplete="new-password"
          minLength={8}
          value={password}
          onChange={(event) =>
            setPassword(event.target.value)
          }
          placeholder="Create a password"
          required
          disabled={loading}
          className="w-full rounded-xl border border-[#D2B48C]/70 bg-[#F9F7F2] px-4 py-3.5 text-sm text-[#3D3D3D] outline-none transition placeholder:text-[#3D3D3D]/35 focus:border-[#4A5D23] focus:bg-white focus:ring-2 focus:ring-[#4A5D23]/10 disabled:cursor-not-allowed disabled:opacity-60"
        />

        <p className="mt-2 text-xs leading-5 text-[#3D3D3D]/50">
          Password must contain at least 8 characters.
        </p>
      </div>

      {/* ERROR */}

      {error && (
        <div
          role="alert"
          className="rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm leading-6 text-red-700"
        >
          {error}
        </div>
      )}

      {/* SUBMIT */}

      <button
        type="submit"
        disabled={loading}
        className="w-full rounded-full bg-[#4A5D23] px-6 py-3.5 text-sm font-semibold text-white transition hover:-translate-y-0.5 hover:bg-[#3D4D1D] hover:shadow-lg active:translate-y-0 disabled:cursor-not-allowed disabled:opacity-60 disabled:hover:translate-y-0 disabled:hover:shadow-none"
      >
        {loading
          ? "Creating account..."
          : "Create account"}
      </button>

      {/* LOGIN */}

      <p className="pt-2 text-center text-sm text-[#3D3D3D]/60">
        Already have an account?{" "}

        <Link
          href="/login"
          className="font-semibold text-[#4A5D23] transition hover:text-[#8B4513]"
        >
          Log in
        </Link>
      </p>

    </form>
  );
}