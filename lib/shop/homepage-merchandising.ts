import type { HomepageSection } from "@/lib/shop/homepage";

export type HomepageCollectionCard = {
  slot: number;
  type: "category" | "subcategory";
  categoryId: string | null;
  subcategoryId: string | null;
  heading: string;
  subheading: string;
  fontFamily: string;
  fontSize: number;
  fontStyle: "normal" | "italic";
  fontWeight: number;
  textColor: string;
  backgroundColor: string;
};

export type HomepageMerchandisingConfig = {
  collectionCards: HomepageCollectionCard[];
  newArrivals: string[];
};

const DEFAULT_COLLECTION_CARDS: HomepageCollectionCard[] = [
  {
    slot: 1,
    type: "category",
    categoryId: "8bd95067-7374-45b4-9df4-d25aa03df3e3",
    subcategoryId: null,
    heading: "Laptop Bags",
    subheading: "",
    fontFamily: "inherit",
    fontSize: 28,
    fontStyle: "normal",
    fontWeight: 600,
    textColor: "#3D3D3D",
    backgroundColor: "#FFFFFF",
  },
  {
    slot: 2,
    type: "category",
    categoryId: "570f3633-51d7-4a1c-b39b-8ef25216db03",
    subcategoryId: null,
    heading: "Hamper Bags",
    subheading: "",
    fontFamily: "inherit",
    fontSize: 28,
    fontStyle: "normal",
    fontWeight: 600,
    textColor: "#3D3D3D",
    backgroundColor: "#FFFFFF",
  },
  {
    slot: 3,
    type: "category",
    categoryId: "f547841f-a2b8-4445-b6ee-491f742459ec",
    subcategoryId: null,
    heading: "Brands Packaging Bags",
    subheading: "",
    fontFamily: "inherit",
    fontSize: 28,
    fontStyle: "normal",
    fontWeight: 600,
    textColor: "#3D3D3D",
    backgroundColor: "#FFFFFF",
  },
];

const DEFAULT_CONFIG: HomepageMerchandisingConfig = {
  collectionCards: DEFAULT_COLLECTION_CARDS,
  newArrivals: [],
};

export function parseHomepageMerchandising(
  sections: HomepageSection[],
): {
  config: HomepageMerchandisingConfig;
  hasSavedConfig: boolean;
} {
  const section = sections.find(
    (item) => item.section_key === "homepage_merchandising",
  );

  if (!section?.description) {
    return {
      config: DEFAULT_CONFIG,
      hasSavedConfig: false,
    };
  }

  try {
    const raw = JSON.parse(section.description) as {
      collectionCards?: unknown;
      newArrivals?: unknown;
    };

    const cards = Array.isArray(raw.collectionCards)
      ? raw.collectionCards.flatMap((value, index) => {
          if (
            typeof value !== "object" ||
            value === null ||
            Array.isArray(value)
          ) {
            return [];
          }

          const card = value as Record<string, unknown>;

          const rawType =
            card.type ?? card.collection_type;

          if (
            rawType !== "category" &&
            rawType !== "subcategory"
          ) {
            return [];
          }

          const rawFontSize =
            card.fontSize ?? card.font_size;

          const fontSize =
            typeof rawFontSize === "number"
              ? rawFontSize
              : rawFontSize === "small"
                ? 20
                : rawFontSize === "medium"
                  ? 24
                  : rawFontSize === "xlarge"
                    ? 36
                    : 28;

          const rawFontWeight =
            card.fontWeight ?? card.font_weight;

          const fontWeightNumber =
            Number(rawFontWeight);

          const rawFontFamily =
            card.fontFamily ?? card.font_family;

          const fontFamily =
            rawFontFamily === "sans"
              ? "sans-serif"
              : rawFontFamily === "mono"
                ? "monospace"
                : rawFontFamily === "serif"
                  ? "serif"
                  : typeof rawFontFamily === "string" &&
                      rawFontFamily.trim()
                    ? rawFontFamily
                    : "inherit";

          const slot =
            typeof card.slot === "number"
              ? card.slot
              : index + 1;

          const categoryId =
            typeof (card.categoryId ?? card.category_id) ===
            "string"
              ? String(
                  card.categoryId ?? card.category_id,
                )
              : null;

          const subcategoryId =
            typeof (
              card.subcategoryId ??
              card.subcategory_id
            ) === "string"
              ? String(
                  card.subcategoryId ??
                    card.subcategory_id,
                )
              : null;

          return [
            {
              slot,
              type: rawType,
              categoryId,
              subcategoryId,
              heading:
                typeof card.heading === "string"
                  ? card.heading
                  : "",
              subheading:
                typeof card.subheading === "string"
                  ? card.subheading
                  : "",
              fontFamily,
              fontSize,
              fontStyle:
                card.fontStyle === "italic" ||
                card.font_style === "italic"
                  ? "italic"
                  : "normal",
              fontWeight: Number.isFinite(
                fontWeightNumber,
              )
                ? fontWeightNumber
                : 600,
              textColor:
                typeof (
                  card.textColor ??
                  card.text_color
                ) === "string"
                  ? String(
                      card.textColor ??
                        card.text_color,
                    )
                  : "#3D3D3D",
              backgroundColor:
                typeof (
                  card.backgroundColor ??
                  card.background_color
                ) === "string"
                  ? String(
                      card.backgroundColor ??
                        card.background_color,
                    )
                  : "#FFFFFF",
            } satisfies HomepageCollectionCard,
          ];
        })
      : [];

    const normalizedCards = cards.sort(
      (a, b) => a.slot - b.slot,
    );

    return {
      config: {
        collectionCards:
          normalizedCards.length === 3
            ? normalizedCards
            : DEFAULT_COLLECTION_CARDS,
        newArrivals: Array.isArray(raw.newArrivals)
          ? raw.newArrivals.filter(
              (id): id is string =>
                typeof id === "string",
            )
          : [],
      },
      hasSavedConfig: true,
    };
  } catch {
    return {
      config: DEFAULT_CONFIG,
      hasSavedConfig: true,
    };
  }
}

