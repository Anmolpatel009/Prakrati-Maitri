import Link from "next/link";

export default function VerifyEmailPage() {
  return (
    <main>
      <h1>Check your email</h1>

      <p>
        We've sent a verification link to your email address.
      </p>

      <p>
        Click the link in your email to verify your account.
      </p>

      <p>
        After verification, you can log in and continue.
      </p>

      <Link href="/login">Go to login</Link>
    </main>
  );
}