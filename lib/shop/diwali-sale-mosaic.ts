import type { HomepageSection } from "@/lib/shop/homepage";

export type DiwaliProductSlotConfig = {
  productId: string | null;
  destinationUrl: string | null;
};

export type DiwaliSaleMosaicConfig = {
  enabled: boolean;
  toteCategoryId: string | null;
  productSlots: DiwaliProductSlotConfig[];
  saleEnd: string;
  hideAfterEnd: boolean;
};

export const DEFAULT_DIWALI_SALE_END = "2026-11-08T23:59:00+05:30";

const emptySlot = (): DiwaliProductSlotConfig => ({
  productId: null,
  destinationUrl: null,
});

const defaultConfig = (): DiwaliSaleMosaicConfig => ({
  enabled: true,
  toteCategoryId: null,
  productSlots: [emptySlot(), emptySlot(), emptySlot()],
  saleEnd: DEFAULT_DIWALI_SALE_END,
  hideAfterEnd: true,
});

function nullableString(value: unknown): string | null {
  return typeof value === "string" && value.trim() ? value.trim() : null;
}

export function parseDiwaliSaleMosaicConfig(
  sections: HomepageSection[],
): DiwaliSaleMosaicConfig {
  const section = sections.find(
    (item) => item.section_key === "diwali_sale_mosaic",
  );

  if (!section?.description) return defaultConfig();

  try {
    const raw = JSON.parse(section.description) as Record<string, unknown>;
    const rawSlots = Array.isArray(raw.productSlots)
      ? raw.productSlots
      : Array.isArray(raw.product_slots)
        ? raw.product_slots
        : [];

    const productSlots = [0, 1, 2].map((index) => {
      const candidate = rawSlots[index];
      if (!candidate || typeof candidate !== "object" || Array.isArray(candidate)) {
        return emptySlot();
      }
      const slot = candidate as Record<string, unknown>;
      return {
        productId: nullableString(slot.productId ?? slot.product_id),
        destinationUrl: nullableString(
          slot.destinationUrl ?? slot.destination_url ?? slot.href,
        ),
      };
    });

    const candidateEnd = nullableString(raw.saleEnd ?? raw.sale_end);
    const saleEnd = candidateEnd && Number.isFinite(Date.parse(candidateEnd))
      ? candidateEnd
      : DEFAULT_DIWALI_SALE_END;

    return {
      enabled: raw.enabled !== false,
      toteCategoryId: nullableString(raw.toteCategoryId ?? raw.tote_category_id),
      productSlots,
      saleEnd,
      hideAfterEnd: raw.hideAfterEnd !== false && raw.hide_after_end !== false,
    };
  } catch {
    // A missing or malformed optional config must never take down the storefront.
    return defaultConfig();
  }
}