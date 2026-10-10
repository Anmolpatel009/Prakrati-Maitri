"use client";

import { useEffect, useState } from "react";
import styles from "./DiwaliSaleMosaic.module.css";
import type { DiwaliSaleMosaicConfig } from "@/lib/shop/diwali-sale-mosaic";

type CatalogProductImage = {
  image_url: string;
  alt_text: string | null;
  display_order: number;
};

type CatalogProduct = {
  id: string;
  category_id: string | null;
  name: string;
  slug: string;
  price: number;
  compare_at_price: number | null;
  product_images: CatalogProductImage[] | null;
};

type CatalogCategory = {
  id: string;
  name: string;
  slug: string;
};

type Props = {
  products: CatalogProduct[];
  categories: CatalogCategory[];
  config: DiwaliSaleMosaicConfig;
};

type Countdown = {
  days: number;
  hours: number;
  minutes: number;
  seconds: number;
  expired: boolean;
};

type TrackingWindow = Window & {
  dataLayer?: Array<Record<string, unknown>>;
  gtag?: (...args: unknown[]) => void;
  fbq?: (action: string, event: string, data?: Record<string, unknown>) => void;
};

const SLOT_KEYWORDS = [
  ["trolley", "suitcase", "travel bag", "travel"],
  ["water bottle", "bottle", "flask"],
  ["laptop", "sling", "gift box", "laptop bag"],
];

function productImage(product: CatalogProduct | undefined): CatalogProductImage | null {
  if (!product?.product_images?.length) return null;
  return [...product.product_images]
    .filter((image) => typeof image.image_url === "string" && image.image_url.trim())
    .sort((a, b) => a.display_order - b.display_order)[0] ?? null;
}

function formatPrice(price: number): string {
  return `₹${Math.round(price).toLocaleString("en-IN")}`;
}

function safeDestination(value: string | null | undefined, fallback: string): string {
  const candidate = value?.trim();
  if (!candidate) return fallback;
  if (candidate.startsWith("/") && !candidate.startsWith("//")) return candidate;
  if (/^https?:\/\//i.test(candidate)) return candidate;
  return fallback;
}

function trackEvent(eventName: string, metaEvent: string, payload: Record<string, unknown>) {
  if (typeof window === "undefined") return;
  const trackingWindow = window as TrackingWindow;
  try {
    trackingWindow.dataLayer?.push({ event: eventName, ...payload });
    trackingWindow.gtag?.("event", eventName, payload);
    trackingWindow.fbq?.("trackCustom", metaEvent, payload);
  } catch {
    // Analytics must never interfere with a user's navigation.
  }
}

function DiyaIcon() {
  return (
    <svg className={styles["pm-dm-diya"]} viewBox="0 0 48 48" aria-hidden="true">
      <path d="M24 3c-5 6-5 10 0 13 5-3 5-7 0-13Z" fill="#1F6B67" />
      <path d="M24 9c-2 4-2 7 0 9 2-2 2-5 0-9Z" fill="#F4D58A" />
      <path d="M9 28c4 7 10 10 15 10s11-3 15-10H9Z" fill="#8B5A2B" />
      <path d="M6 27h36c-2 9-9 15-18 15S8 36 6 27Z" fill="#4E3320" />
      <path d="M13 31c6 3 16 3 22 0" fill="none" stroke="#E5D6BC" strokeWidth="1.5" strokeLinecap="round" />
      <path d="M24 20v5" stroke="#8B5A2B" strokeWidth="2" strokeLinecap="round" />
    </svg>
  );
}


function DiwaliCountdown({ saleEnd, hideAfterEnd }: { saleEnd: string; hideAfterEnd: boolean }) {
  const [countdown, setCountdown] = useState<Countdown | null>(null);
  const endTime = new Date(saleEnd).getTime();

  useEffect(() => {
    const tick = () => {
      const difference = endTime - Date.now();
      if (!Number.isFinite(endTime) || difference <= 0) {
        setCountdown({ days: 0, hours: 0, minutes: 0, seconds: 0, expired: true });
        return;
      }
      const totalSeconds = Math.floor(difference / 1000);
      setCountdown({
        days: Math.floor(totalSeconds / 86400),
        hours: Math.floor((totalSeconds % 86400) / 3600),
        minutes: Math.floor((totalSeconds % 3600) / 60),
        seconds: totalSeconds % 60,
        expired: false,
      });
    };

    tick();
    const interval = window.setInterval(tick, 1000);
    return () => window.clearInterval(interval);
  }, [endTime]);

  if (hideAfterEnd && countdown?.expired) return null;
  const units = [
    { key: "days", label: "DAYS", value: countdown?.days },
    { key: "hours", label: "HRS", value: countdown?.hours },
    { key: "minutes", label: "MIN", value: countdown?.minutes },
    { key: "seconds", label: "SEC", value: countdown?.seconds },
  ];

  return (
    <div className={styles["pm-dm-timer"]} aria-label="Time remaining in the Diwali sale">
      {units.map((unit) => (
        <span className={styles["pm-dm-cell"]} key={unit.key}>
          <b>{unit.value === undefined ? "--" : String(unit.value).padStart(2, "0")}</b>
          <small>{unit.label}</small>
        </span>
      ))}
    </div>
  );
}

function chooseProducts(
  products: CatalogProduct[],
  config: DiwaliSaleMosaicConfig,
  excludedCategoryId: string | null,
): Array<CatalogProduct | null> {
  const used = new Set<string>();
  return [0, 1, 2].map((index) => {
    const configuredId = config.productSlots[index]?.productId;
    const explicitlyChosen = configuredId
      ? products.find((product) => product.id === configuredId && !used.has(product.id))
      : undefined;
    if (explicitlyChosen) {
      used.add(explicitlyChosen.id);
      return explicitlyChosen;
    }

    const keywords = SLOT_KEYWORDS[index];
    const available = products.filter((product) => !used.has(product.id));
    const outsideToteCategory = available.filter((product) => product.category_id !== excludedCategoryId);
    const pool = outsideToteCategory.length ? outsideToteCategory : available;
    const matching = pool.filter((product) => {
      const name = product.name.toLowerCase();
      return keywords.some((keyword) => name.includes(keyword));
    });
    const withImages = (items: CatalogProduct[]) => items.filter((product) => Boolean(productImage(product)));
    const selected =
      withImages(matching)[0] ??
      matching[0] ??
      withImages(pool)[0] ??
      pool[0] ??
      null;

    if (selected) used.add(selected.id);
    return selected;
  });
}

export default function DiwaliSaleMosaic({ products, categories, config }: Props) {
  if (!config.enabled) return null;

  const toteCategory =
    (config.toteCategoryId
      ? categories.find((category) => category.id === config.toteCategoryId)
      : undefined) ??
    categories.find((category) => category.slug.trim().toLowerCase() === "tote-bags") ??
    categories.find((category) => category.name.trim().toLowerCase() === "tote bags") ??
    categories.find((category) => category.name.toLowerCase().includes("tote"));

  const toteProducts = toteCategory
    ? products.filter((product) => product.category_id === toteCategory.id)
    : [];
  const toteRepresentative =
    toteProducts.find((product) => Boolean(productImage(product))) ?? toteProducts[0];
  const totePhoto = productImage(toteRepresentative);
  const toteHref = toteCategory ? `/shop/${toteCategory.slug}` : "/shop";
  const validPrices = toteProducts.map((product) => product.price).filter((price) => Number.isFinite(price) && price > 0);
  const startingPrice = validPrices.length ? Math.min(...validPrices) : null;
  const selectedProducts = chooseProducts(products, config, toteCategory?.id ?? null);
  const slotClasses = ["pm-dm-tile--trolley", "pm-dm-tile--bottle", "pm-dm-tile--laptop"];
  const slotBadges = ["FEATURED PICK", "FEATURED PICK", "FEATURED PICK"];

  return (
    <section className={styles["pm-dm"]} id="diwali-sale" aria-label="Diwali Sale">
      <svg className={styles["pm-dm-toran"]} viewBox="0 0 100 34" preserveAspectRatio="none" aria-hidden="true">
  <line x1="0" y1="12" x2="100" y2="12" stroke="#8B5A2B" strokeWidth="1.2" />
</svg>

      <div className={styles["pm-dm-inner"]}>
        <div className={styles["pm-dm-head"]}>
          <div className={styles["pm-dm-heading"]}>
            <DiyaIcon />
            <div>
              <span className={styles["pm-dm-eyebrow"]}>LIMITED PERIOD</span>
              <h2 className={styles["pm-dm-h2"]}>Diwali Sale</h2>
            </div>
          </div>
          <div className={styles["pm-dm-timer-wrap"]}>
            <DiwaliCountdown saleEnd={config.saleEnd} hideAfterEnd={config.hideAfterEnd} />
            <span className={styles["pm-dm-ends"]}>Ends Diwali night</span>
          </div>
        </div>

        <div className={styles["pm-dm-grid"]}>
          <a
            className={`${styles["pm-dm-tile"]} ${styles["pm-dm-tile--tote"]}`}
            href={toteHref}
            onClick={() => trackEvent("pm_diwali_tile_click", "DiwaliTileClick", {
              tile: "tote-category",
              category_id: toteCategory?.id ?? null,
              category_name: toteCategory?.name ?? "Tote Bags",
            })}
            aria-label="Shop the Tote Bags category"
          >
            {totePhoto ? (
              <img
                className={styles["pm-dm-tote-photo"]}
                src={totePhoto.image_url}
                alt={totePhoto.alt_text || toteRepresentative?.name || "Tote bags from the catalog"}
                loading="lazy"
              />
            ) : null}
            <span className={styles["pm-dm-badge"]}>FESTIVE COLLECTION</span>
            <div className={styles["pm-dm-tote-copy"]}>
              <span className={styles["pm-dm-tote-kicker"]}>GIVE SOMETHING THOUGHTFUL</span>
              <h3 className={styles["pm-dm-tote-name"]}>{toteCategory?.name || "Tote Bags"}</h3>
              <p>Everyday essentials, made memorable.</p>
              <div className={styles["pm-dm-tote-bottom"]}>
                <span className={styles["pm-dm-price"]}>
                  {startingPrice !== null ? <>From <b>{formatPrice(startingPrice)}</b></> : "Explore the collection"}
                </span>
                <span className={styles["pm-dm-shop-now"]}>Shop now <span aria-hidden="true">→</span></span>
              </div>
            </div>
          </a>

          {selectedProducts.map((product, index) => {
            const image = productImage(product ?? undefined);
            const productHref = safeDestination(
              config.productSlots[index]?.destinationUrl,
              product ? `/products/${product.slug}` : "/shop",
            );
            const kindClass = styles[slotClasses[index]];
            const name = product?.name ?? "Explore the collection";
            const payload = {
              tile: slotClasses[index].replace("pm-dm-tile--", ""),
              slot: index + 1,
              product_id: product?.id ?? null,
              product_name: product?.name ?? null,
              destination_url: productHref,
            };

            return (
              <a
                key={index}
                className={`${styles["pm-dm-tile"]} ${styles["pm-dm-product-tile"]} ${kindClass}`}
                href={productHref}
                onClick={() => trackEvent("pm_diwali_tile_click", "DiwaliTileClick", payload)}
                aria-label={product ? `View ${product.name}` : "Explore the product collection"}
              >
                <span className={styles["pm-dm-badge"]}>{slotBadges[index]}</span>
                <div className={styles["pm-dm-product-media"]}>
                  {image ? (
                    <img
                      className={styles["pm-dm-product-image"]}
                      src={image.image_url}
                      alt={image.alt_text || product?.name || "Product"}
                      loading="lazy"
                    />
                  ) : (
                    <span className={styles["pm-dm-image-fallback"]} aria-hidden="true">âœ¦</span>
                  )}
                </div>
                <div className={styles["pm-dm-info"]}>
                  <span className={styles["pm-dm-name"]}>{name}</span>
                  <div className={styles["pm-dm-row"]}>
                    <b>{product ? formatPrice(product.price) : "Discover"}</b>
                    <span className={styles["pm-dm-shop"]}>Shop <span aria-hidden="true">→</span></span>
                  </div>
                </div>
              </a>
            );
          })}
        </div>

      </div>
    </section>
  );
}