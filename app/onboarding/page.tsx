import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import OnboardingForm from "@/components/onboarding/OnboardingForm";

export default async function OnboardingPage() {
  const supabase = await createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    redirect("/login");
  }

  const { data: profile } = await supabase
    .from("profiles")
    .select(
      "first_name, last_name, phone, country, onboarding_complete"
    )
    .eq("id", user.id)
    .maybeSingle();

  if (profile?.onboarding_complete) {
    redirect("/account");
  }

  return (
    <main>
      <h1>Welcome to Prakratri Matri</h1>

      <p>Tell us a little about yourself.</p>

      <OnboardingForm
        initialProfile={profile}
      />
    </main>
  );
}