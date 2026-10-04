"use client";

import {
  useCallback,
  useEffect,
  useRef,
} from "react";
import SharedProductCard, {
  type SharedProductCardProduct,
} from "@/components/shop/ProductCard";
import type { ProductCardStylingConfig } from "@/lib/shop/product-card-styling";

type Props = {
  products: SharedProductCardProduct[];
  config: ProductCardStylingConfig;
};

const AUTO_SPEED = 0.55;

export default function NewArrivalsRail({
  products,
  config,
}: Props) {
  const viewportRef =
    useRef<HTMLDivElement | null>(null);

  const firstSetRef =
    useRef<HTMLDivElement | null>(null);

  const frameRef =
    useRef<number | null>(null);

  const lastTimeRef =
    useRef<number | null>(null);

  const pausedRef =
    useRef(false);

  const firstSetWidthRef =
    useRef(0);

  const measure = useCallback(() => {
    if (!firstSetRef.current) {
      return;
    }

    firstSetWidthRef.current =
      firstSetRef.current.scrollWidth;
  }, []);

  useEffect(() => {
    measure();

    const observer =
      new ResizeObserver(measure);

    if (firstSetRef.current) {
      observer.observe(
        firstSetRef.current,
      );
    }

    window.addEventListener(
      "resize",
      measure,
    );

    return () => {
      observer.disconnect();

      window.removeEventListener(
        "resize",
        measure,
      );
    };
  }, [measure]);

  useEffect(() => {
    const animate = (
      timestamp: number,
    ) => {
      if (lastTimeRef.current === null) {
        lastTimeRef.current = timestamp;
      }

      const delta = Math.min(
        timestamp -
          lastTimeRef.current,
        50,
      );

      lastTimeRef.current = timestamp;

      const viewport =
        viewportRef.current;

      const loopWidth =
        firstSetWidthRef.current;

      if (
        viewport &&
        loopWidth > 0 &&
        !pausedRef.current
      ) {
        viewport.scrollLeft +=
          (AUTO_SPEED * delta) /
          16;

        if (
          viewport.scrollLeft >=
          loopWidth
        ) {
          viewport.scrollLeft -=
            loopWidth;
        }
      }

      frameRef.current =
        requestAnimationFrame(
          animate,
        );
    };

    frameRef.current =
      requestAnimationFrame(animate);

    return () => {
      if (frameRef.current !== null) {
        cancelAnimationFrame(
          frameRef.current,
        );
      }
    };
  }, []);

  if (products.length === 0) {
    return null;
  }

  return (
    <div
      ref={viewportRef}
      className="new-arrivals-viewport"
      aria-label="New Arrivals products"
      onPointerDown={() => {
        pausedRef.current = true;
      }}
      onPointerUp={() => {
        pausedRef.current = false;
      }}
      onPointerCancel={() => {
        pausedRef.current = false;
      }}
      onPointerLeave={() => {
        pausedRef.current = false;
      }}
    >
      <div className="new-arrivals-track">
        <div
          ref={firstSetRef}
          className="new-arrivals-set"
        >
          {products.map((product) => (
            <SharedProductCard
              key={`new-arrivals-1-${product.id}`}
              product={product}
              config={config}
            />
          ))}
        </div>

        <div
          className="new-arrivals-set"
          aria-hidden="true"
        >
          {products.map((product) => (
            <SharedProductCard
              key={`new-arrivals-2-${product.id}`}
              product={product}
              config={config}
            />
          ))}
        </div>
      </div>
    </div>
  );
}
