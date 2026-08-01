import ResetPasswordForm from "@/components/auth/ResetPasswordForm";

export default function ResetPasswordPage() {
  return (
    <main>
      <h1>Set a new password</h1>

      <p>
        Enter your new password below.
      </p>

      <ResetPasswordForm />
    </main>
  );
}