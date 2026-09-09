"use client";

import { useEffect, useState } from "react";

type Banner = {
  id: string;
  slot: number;
  image_url: string;
  alt_text: string | null;
};

type Props = {
  banners: Banner[];
};

export default function CollectionBanner({ banners }: Props) {
  const [current, setCurrent] = useState(0);

  useEffect(() => {
    if (banners.length <= 1) return;

    const timer = window.setInterval(() => {
      setCurrent((index) => (index + 1) % banners.length);
    }, 5000);

    return () => window.clearInterval(timer);
  }, [banners.length]);

  if (!banners.length) {
    return null;
  }

  const previous = () => {
    setCurrent(
      (index) => (index - 1 + banners.length) % banners.length
    );
  };

  const next = () => {
    setCurrent((index) => (index + 1) % banners.length);
  };

  return (
    <section className="collection-banner-section">
      <div className="collection-banner">
        {banners.map((banner, index) => (
          <img
            key={banner.id}
            src={banner.image_url}
            alt={banner.alt_text ?? "Prakrati Maitri collection banner"}
            className={`collection-banner-image ${
              index === current ? "is-active" : ""
            }`}
            draggable={false}
          />
        ))}

        {banners.length > 1 && (
          <>
            <button
              type="button"
              className="collection-banner-arrow collection-banner-prev"
              onClick={previous}
              aria-label="Previous banner"
            >
              ‹
            </button>

            <button
              type="button"
              className="collection-banner-arrow collection-banner-next"
              onClick={next}
              aria-label="Next banner"
            >
              ›
            </button>

            <div className="collection-banner-dots">
              {banners.map((banner, index) => (
                <button
                  key={banner.id}
                  type="button"
                  className={`collection-banner-dot ${
                    index === current ? "is-active" : ""
                  }`}
                  onClick={() => setCurrent(index)}
                  aria-label={`Show banner ${index + 1}`}
                  aria-current={index === current}
                />
              ))}
            </div>
          </>
        )}
      </div>
    </section>
  );
}