"use client";

import Link from "next/link";
import { useEffect, useMemo, useRef, useState } from "react";
import type { CSSProperties } from "react";
import type {
  ProductCardAnimation,
  ProductCardStylingConfig,
} from "@/lib/shop/product-card-styling";

type ProductCardImage = {
  image_url: string;
  alt_text?: string | null;
  display_order?: number | null;
};

export type SharedProductCardProduct = {
  id: string;
  name: string;
  slug: string;
  price: number;
  product_images?: ProductCardImage[] | null;
  images?: ProductCardImage[] | null;
  image?: {
    imageUrl: string;
    altText?: string | null;
  } | null;
  rating?: number | null;
  reviewCount?: number | null;
};

type ProductCardProps = {
  product: SharedProductCardProduct;
  config: ProductCardStylingConfig;
  href?: string;
  isBulkEnquiry?: boolean;
};

const animationClass: Record<ProductCardAnimation, string> = {
  "fade-in": "product-card-shared--fade-in",
  "slide-up": "product-card-shared--slide-up",
  "scale-in": "product-card-shared--scale-in",
};

export default function ProductCard({
  product,
  config,
  href,
  isBulkEnquiry = false,
}: ProductCardProps) {
  const images = useMemo(
    () =>
      [...(
        product.product_images ??
        product.images ??
        (product.image
          ? [{
              image_url: product.image.imageUrl,
              alt_text: product.image.altText ?? null,
              display_order: 0,
            }]
          : [])
      )].sort(
        (a, b) =>
          (a.display_order ?? 0) - (b.display_order ?? 0),
      ),
    [product.product_images],
  );

  const [activeImageIndex, setActiveImageIndex] = useState(0);
  const cycleTimer = useRef<ReturnType<typeof setInterval> | null>(
    null,
  );

  const clearImageCycle = () => {
    if (cycleTimer.current !== null) {
      clearInterval(cycleTimer.current);
      cycleTimer.current = null;
    }
  };

  const startImageCycle = () => {
    clearImageCycle();

    if (images.length <= 1) {
      return;
    }

    setActiveImageIndex(1);

    cycleTimer.current = setInterval(() => {
      setActiveImageIndex(
        (current) => (current + 1) % images.length,
      );
    }, 900);
  };

  const stopImageCycle = () => {
    clearImageCycle();
    setActiveImageIndex(0);
  };

  useEffect(() => {
    return () => clearImageCycle();
  }, []);

  const destination = isBulkEnquiry
    ? `/bulk-order?product=${encodeURIComponent(product.id)}`
    : href ?? `/products/${product.slug}`;
  const image = images[activeImageIndex] ?? null;

  const rating = Math.max(
    0,
    Math.min(5, Math.round(product.rating ?? 5)),
  );

  const reviewCount = product.reviewCount ?? null;

  const cardStyle = {
    "--product-card-font-family": "Montserrat, Arial, sans-serif",
    "--product-card-font-size": "14px",
    "--product-card-text-color": "#2E2118",
    "--product-card-background": "#E9DCC3",
  } as CSSProperties;

  return (
    <Link
      href={destination}
      className={`product-card product-card-shared ${
        animationClass[config.animation]
      }`}
      style={cardStyle}
      onMouseEnter={startImageCycle}
      onMouseLeave={stopImageCycle}
      onFocus={startImageCycle}
      onBlur={stopImageCycle}

    >
      <div className="product-card-shared-image">
        {image ? (
          <img
            src={image.image_url}
            alt={image.alt_text ?? product.name}
            className="product-image"
          />
        ) : (
          <div className="product-image-placeholder">
            <span>Product Image</span>
          </div>
        )}
      </div>

      <div className="product-card-shared-content">
        <div className="product-card-shared-name">
          {product.name}
        </div>

        <div className="product-card-shared-rating">
          <span
            className="product-card-shared-stars"
            aria-label={`${rating} out of 5 stars`}
          >
            {"★".repeat(rating)}
            {"☆".repeat(5 - rating)}
          </span>

          <span className="product-card-shared-reviews">
            {reviewCount !== null
              ? `${reviewCount} reviews`
              : "New"}
          </span>
        </div>

        {isBulkEnquiry ? (
          <span className="product-card-shared-bulk-enquiry">
            Bulk Enquiry
          </span>
        ) : (
          <div className="product-card-shared-price">
            ₹{product.price.toFixed(0)}
          </div>
        )}
      </div>
    </Link>
  );
}
