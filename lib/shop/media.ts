import { createClient } from "@/lib/supabase/server";

export type StorefrontVideo = {
  id: string;
  title: string;
  file_url: string;
  thumbnail_url: string | null;
  alt_text: string | null;
};

export async function getStorefrontVideos() {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from("storefront_media")
    .select(
      "id, title, file_url, thumbnail_url, alt_text"
    )
    .eq("media_type", "video")
    .eq("is_active", true)
    .order("created_at", { ascending: false });

  if (error) {
    console.error(
      `Failed to load storefront videos: ${error.message}`
    );
    return [];
  }

  return (data ?? []) as StorefrontVideo[];
}
