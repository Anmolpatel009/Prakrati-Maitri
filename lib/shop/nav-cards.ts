import { createClient } from "@/lib/supabase/server";

export type StorefrontNavCard = {
  id: string;
  card_type: "category" | "subcategory" | "product" | "custom";
  title: string;
  image_url: string | null;
  href: string | null;
  display_order: number;
};

export async function getStorefrontNavCards() {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from("storefront_nav_cards")
    .select(`
      id,
      card_type,
      title,
      image_url,
      href,
      display_order
    `)
    .eq("is_active", true)
    .order("display_order", { ascending: true });

  if (error) {
    throw new Error(
      `Failed to load storefront navigation cards: ${error.message}`
    );
  }

  return (data ?? []) as StorefrontNavCard[];
}
