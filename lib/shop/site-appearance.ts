import { createClient } from "@/lib/supabase/server";

export const SITE_APPEARANCE_KEY = "site_appearance";
export const DEFAULT_SITE_BACKGROUND = "#F9F7F2";

export type SiteAppearanceConfig = {
  background_color: string;
};

export async function getSiteAppearance(): Promise<SiteAppearanceConfig> {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from("homepage_sections")
    .select("description")
    .eq("section_key", SITE_APPEARANCE_KEY)
    .maybeSingle();

  if (error || !data?.description) {
    return {
      background_color: DEFAULT_SITE_BACKGROUND,
    };
  }

  try {
    const saved =
      typeof data.description === "string"
        ? JSON.parse(data.description)
        : data.description;

    return {
      background_color:
        typeof saved?.background_color === "string"
          ? saved.background_color
          : DEFAULT_SITE_BACKGROUND,
    };
  } catch {
    return {
      background_color: DEFAULT_SITE_BACKGROUND,
    };
  }
}
