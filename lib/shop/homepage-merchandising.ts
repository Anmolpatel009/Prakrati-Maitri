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
      ? raw.collectionCards.filter(
          (card): card is HomepageCollectionCard =>
            typeof card === "object" &&
            card !== null &&
            typeof (card as HomepageCollectionCard).slot === "number" &&
            ((card as HomepageCollectionCard).type === "category" ||
              (card as HomepageCollectionCard).type === "subcategory"),
        )
      : [];

    return {
      config: {
        collectionCards:
          cards.length === 3
            ? cards
            : DEFAULT_COLLECTION_CARDS,
        newArrivals: Array.isArray(raw.newArrivals)
          ? raw.newArrivals.filter(
              (id): id is string => typeof id === "string",
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
