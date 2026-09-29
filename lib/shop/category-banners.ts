import { createClient } from "@/lib/supabase/server";

export type CategoryBanner = {
  id: string;
  category_id: string;
  image_url: string;
  mobile_image_url: string | null;
  alt_text: string | null;
};

export async function getCategoryBanners(): Promise<CategoryBanner[]> {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from("category_banners")
    .select("id, category_id, image_url, mobile_image_url, alt_text")
    .eq("is_active", true)
    .order("created_at", { ascending: true });

  if (error) {
    console.error("Category banner fetch error:", error);
    return [];
  }

  return (data ?? []) as CategoryBanner[];
}

export async function getCategoryBanner(
  categoryId: string
): Promise<CategoryBanner | null> {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from("category_banners")
    .select("id, category_id, image_url, mobile_image_url, alt_text")
    .eq("category_id", categoryId)
    .eq("is_active", true)
    .maybeSingle();

  if (error) {
    console.error("Category banner fetch error:", error);
    return null;
  }

  return data as CategoryBanner | null;
}
