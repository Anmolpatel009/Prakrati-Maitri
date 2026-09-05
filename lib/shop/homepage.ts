import { createClient } from "@/lib/supabase/server";

export type HomepageSection = {
  id: string;
  section_key: string;
  section_type: string;
  eyebrow: string | null;
  title: string | null;
  description: string | null;
  cta_text: string | null;
  cta_url: string | null;
  media_id: string | null;
  media_url: string | null;
};

export async function getHomepageSections() {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from("homepage_sections")
    .select(
      `
        id,
        section_key,
        section_type,
        eyebrow,
        title,
        description,
        cta_text,
        cta_url,
        media_id
      `
    )
    .eq("is_active", true)
    .order("display_order", { ascending: true });

  if (error) {
    console.error(
      `Failed to load homepage sections: ${error.message}`
    );
    return [];
  }

  const sections = data ?? [];

  const mediaIds = sections
    .map((section) => section.media_id)
    .filter((id): id is string => Boolean(id));

  if (mediaIds.length === 0) {
    return sections.map((section) => ({
      ...section,
      media_url: null,
    })) as HomepageSection[];
  }

  const { data: media, error: mediaError } = await supabase
    .from("storefront_media")
    .select("id, file_url")
    .in("id", mediaIds)
    .eq("media_type", "image")
    .eq("is_active", true);

  if (mediaError) {
    console.error(
      `Failed to load homepage images: ${mediaError.message}`
    );
  }

  const mediaMap = new Map(
    (media ?? []).map((item) => [
      item.id,
      item.file_url,
    ])
  );

  return sections.map((section) => ({
    ...section,
    media_url: section.media_id
      ? mediaMap.get(section.media_id) ?? null
      : null,
  })) as HomepageSection[];
}
