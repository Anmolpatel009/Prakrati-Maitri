import ForgotPasswordForm from "@/components/auth/ForgotPasswordForm";

export default function ForgotPasswordPage() {
  return (
    <main>
      <h1>Reset your password</h1>

      <p>
        Enter your email address and we'll send you a password
        reset link.
      </p>

      <ForgotPasswordForm />
    </main>
  );
}