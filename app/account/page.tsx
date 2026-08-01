import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import LogoutButton from "@/components/auth/LogoutButton";

export default async function AccountPage() {
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

  if (!profile?.onboarding_complete) {
    redirect("/onboarding");
  }

  return (
    <main>
      <h1>
        Welcome{profile.first_name ? `, ${profile.first_name}` : ""}
      </h1>

      <p>
        You are successfully logged in to Prakratri Matri.
      </p>

      <p>
        Email: {user.email}
      </p>

      <p>
        Country: {profile.country}
      </p>
      <LogoutButton />
    </main>
  );
}