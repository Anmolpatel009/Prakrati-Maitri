import { createClient } from "@/lib/supabase/server";

export type HomepageBanner = {
  id: string;
  slot: number;
  image_url: string;
  alt_text: string | null;
  is_active: boolean;
};

export async function getHomepageBanners(): Promise<HomepageBanner[]> {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from("homepage_banners")
    .select("id, slot, image_url, alt_text, is_active")
    .eq("is_active", true)
    .order("slot", { ascending: true });

  if (error) {
    console.error("Homepage banner fetch error:", error);
    return [];
  }

  return (data ?? []) as HomepageBanner[];
}
