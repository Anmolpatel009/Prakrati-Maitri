import { createClient } from "@/lib/supabase/server";

export const NAVBAR_CUSTOMIZATION_KEY = "navbar_customization";

export type NavbarItemType =
  | "new"
  | "category"
  | "subcategory"
  | "reviews"
  | "bulk_orders"
  | "link";

export type NavbarItem = {
  key: string;
  type: NavbarItemType;
  id?: string;
  label?: string;
  href?: string;
};

export type NavbarCustomizationConfig = {
  brand_font_family: string;
  brand_font_size: number;
  brand_font_weight: string;
  brand_font_style: string;
  brand_text_color: string;
  background_color: string;
  items: NavbarItem[];
};

export const DEFAULT_NAVBAR_CUSTOMIZATION: NavbarCustomizationConfig = {
  brand_font_family: "Georgia, serif",
  brand_font_size: 28,
  brand_font_weight: "500",
  brand_font_style: "normal",
  brand_text_color: "#176B78",
  background_color: "#F9F7F2",
  items: [
    { key: "new", type: "new" },
    { key: "reviews", type: "reviews" },
    { key: "bulk_orders", type: "bulk_orders" },
  ],
};

export async function getNavbarCustomization(
  fallbackItems?: NavbarItem[],
): Promise<NavbarCustomizationConfig> {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from("homepage_sections")
    .select("description")
    .eq("section_key", NAVBAR_CUSTOMIZATION_KEY)
    .maybeSingle();

  const fallback: NavbarCustomizationConfig = {
    ...DEFAULT_NAVBAR_CUSTOMIZATION,
    items:
      fallbackItems && fallbackItems.length > 0
        ? fallbackItems
        : DEFAULT_NAVBAR_CUSTOMIZATION.items,
  };

  if (error || !data?.description) {
    return fallback;
  }

  try {
    const saved =
      typeof data.description === "string"
        ? JSON.parse(data.description)
        : data.description;

    return {
      ...DEFAULT_NAVBAR_CUSTOMIZATION,
      ...saved,
      items:
        Array.isArray(saved?.items) && saved.items.length > 0
          ? saved.items
          : fallback.items,
    };
  } catch {
    return fallback;
  }
}
