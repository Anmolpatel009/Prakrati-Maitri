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

  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  async function handleLogin(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();

    setLoading(true);
    setError("");

    const { error } = await supabase.auth.signInWithPassword({
      email: email.trim(),
      password,
    });

    if (error) {
      setLoading(false);
      setError(error.message);
      return;
    }

    const {
      data: { user },
    } = await supabase.auth.getUser();

    if (!user) {
      setLoading(false);
      setError("Unable to retrieve your account.");
      return;
    }

    const { data: profile, error: profileError } = await supabase
      .from("profiles")
      .select("onboarding_complete")
      .eq("id", user.id)
      .maybeSingle();

    setLoading(false);

    if (profileError) {
      setError("Unable to load your profile.");
      return;
    }

    if (!profile || !profile.onboarding_complete) {
      router.push("/onboarding");
      router.refresh();
      return;
    }

    router.push("/account");
    router.refresh();
  }

  return (
    <form onSubmit={handleLogin}>
      <div>
        <label htmlFor="email">Email address</label>

        <input
          id="email"
          name="email"
          type="email"
          autoComplete="email"
          value={email}
          onChange={(event) => setEmail(event.target.value)}
          required
        />
      </div>

      <div>
        <label htmlFor="password">Password</label>

        <input
          id="password"
          name="password"
          type="password"
          autoComplete="current-password"
          value={password}
          onChange={(event) => setPassword(event.target.value)}
          required
        />
      </div>

      {error && <p role="alert">{error}</p>}

      <button type="submit" disabled={loading}>
        {loading ? "Logging in..." : "Log in"}
      </button>

      <p>
        <Link href="/forgot-password">
          Forgot your password?
        </Link>
      </p>

      <p>
        Don't have an account?{" "}
        <Link href="/signup">
          Create an account
        </Link>
      </p>
    </form>
  );
}