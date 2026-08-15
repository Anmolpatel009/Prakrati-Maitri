"use client";

import { FormEvent, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

export default function LoginForm() {
  const router = useRouter();
  const supabase = createClient();

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  async function handleSubmit(
    event: FormEvent<HTMLFormElement>
  ) {
    event.preventDefault();

    setError("");
    setLoading(true);

    try {
      const { error } =
        await supabase.auth.signInWithPassword({
          email: email.trim(),
          password,
        });

      if (error) {
        setError(
          error.message === "Invalid login credentials"
            ? "Email or password is incorrect."
            : error.message
        );

        setLoading(false);
        return;
      }

      router.push("/account");
      router.refresh();
    } catch (error) {
      console.error("Login error:", error);

      setError(
        "Something went wrong. Please try again."
      );

      setLoading(false);
    }
  }

  return (
    <form
      onSubmit={handleSubmit}
      className="space-y-5"
    >
      {/* ================================================= */}
      {/* EMAIL */}
      {/* ================================================= */}

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
          value={email}
          onChange={(event) =>
            setEmail(event.target.value)
          }
          placeholder="you@example.com"
          autoComplete="email"
          required
          disabled={loading}
          className="w-full rounded-xl border border-[#D2B48C]/70 bg-[#F9F7F2] px-4 py-3.5 text-sm text-[#3D3D3D] outline-none transition placeholder:text-[#3D3D3D]/35 focus:border-[#4A5D23] focus:bg-white focus:ring-2 focus:ring-[#4A5D23]/10 disabled:cursor-not-allowed disabled:opacity-60"
        />
      </div>

      {/* ================================================= */}
      {/* PASSWORD */}
      {/* ================================================= */}

      <div>
        <div className="mb-2 flex items-center justify-between">
          <label
            htmlFor="password"
            className="block text-sm font-medium text-[#3D3D3D]"
          >
            Password
          </label>

          <Link
            href="/forgot-password"
            className="text-xs font-medium text-[#4A5D23] transition hover:text-[#8B4513]"
          >
            Forgot password?
          </Link>
        </div>

        <input
          id="password"
          name="password"
          type="password"
          value={password}
          onChange={(event) =>
            setPassword(event.target.value)
          }
          placeholder="Enter your password"
          autoComplete="current-password"
          required
          disabled={loading}
          className="w-full rounded-xl border border-[#D2B48C]/70 bg-[#F9F7F2] px-4 py-3.5 text-sm text-[#3D3D3D] outline-none transition placeholder:text-[#3D3D3D]/35 focus:border-[#4A5D23] focus:bg-white focus:ring-2 focus:ring-[#4A5D23]/10 disabled:cursor-not-allowed disabled:opacity-60"
        />
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
      {/* LOGIN BUTTON */}
      {/* ================================================= */}

      <button
        type="submit"
        disabled={loading}
        className="w-full rounded-full bg-[#4A5D23] px-6 py-3.5 text-sm font-semibold text-white transition hover:-translate-y-0.5 hover:bg-[#3D4D1D] hover:shadow-lg active:translate-y-0 disabled:cursor-not-allowed disabled:opacity-60 disabled:hover:translate-y-0 disabled:hover:shadow-none"
      >
        {loading ? "Logging in..." : "Log in"}
      </button>

      {/* ================================================= */}
      {/* SIGNUP */}
      {/* ================================================= */}

      <p className="pt-2 text-center text-sm text-[#3D3D3D]/60">
        Don't have an account?{" "}
        <Link
          href="/signup"
          className="font-semibold text-[#4A5D23] transition hover:text-[#8B4513]"
        >
          Create an account
        </Link>
      </p>
    </form>
  );
}