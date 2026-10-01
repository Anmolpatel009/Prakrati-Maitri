import { createClient } from "@/lib/supabase/server";

export const PRODUCT_CARD_STYLING_KEY = "product_card_styling";

export type ProductCardAnimation =
  | "fade-in"
  | "slide-up"
  | "scale-in";

export type ProductCardStylingConfig = {
  font_family: string;
  font_size: number;
  text_color: string;
  card_color: string;
  animation: ProductCardAnimation;
};

const DEFAULT_PRODUCT_CARD_STYLING: ProductCardStylingConfig = {
  font_family: "system-ui, sans-serif",
  font_size: 16,
  text_color: "#3D3D3D",
  card_color: "#FFFDF9",
  animation: "fade-in",
};

export async function getProductCardStyling(): Promise<ProductCardStylingConfig> {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from("homepage_sections")
    .select("description")
    .eq("section_key", PRODUCT_CARD_STYLING_KEY)
    .maybeSingle();

  if (error || !data?.description) {
    return DEFAULT_PRODUCT_CARD_STYLING;
  }

  try {
    const saved =
      typeof data.description === "string"
        ? JSON.parse(data.description)
        : data.description;

    return {
      ...DEFAULT_PRODUCT_CARD_STYLING,
      ...saved,
    };
  } catch {
    return DEFAULT_PRODUCT_CARD_STYLING;
  }
}
