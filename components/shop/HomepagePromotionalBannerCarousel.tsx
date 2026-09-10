"use client";

import { useEffect, useState } from "react";

type HomepageBanner = {
  id: string;
  slot: number;
  image_url: string;
  alt_text: string | null;
  is_active: boolean;
};

type Props = {
  banners: HomepageBanner[];
  variant?: "default" | "hero";
};

export default function HomepagePromotionalBannerCarousel({
  banners,
  variant = "default",
}: Props) {
  const [activeIndex, setActiveIndex] = useState(0);

  useEffect(() => {
    if (banners.length <= 1) return;

    const timer = window.setInterval(() => {
      setActiveIndex((current) => (current + 1) % banners.length);
    }, 5000);

    return () => window.clearInterval(timer);
  }, [banners.length]);

  if (banners.length === 0) {
    return null;
  }

  const activeBanner = banners[activeIndex] ?? banners[0];

  return (
    <section
      className={`homepage-promotional-banner homepage-promotional-banner-${variant}`}
      aria-label="Homepage promotions"
    >
      <div className="homepage-promotional-banner-frame">
        <img
          key={activeBanner.id}
          src={activeBanner.image_url}
          alt={activeBanner.alt_text || "Prakratri Maitri promotion"}
          className="homepage-promotional-banner-image"
        />

        {banners.length > 1 && (
          <>
            <button
              type="button"
              className="homepage-promotional-banner-arrow homepage-promotional-banner-prev"
              aria-label="Previous banner"
              onClick={() =>
                setActiveIndex(
                  (activeIndex - 1 + banners.length) % banners.length
                )
              }
            >
              ‹
            </button>

            <button
              type="button"
              className="homepage-promotional-banner-arrow homepage-promotional-banner-next"
              aria-label="Next banner"
              onClick={() =>
                setActiveIndex((activeIndex + 1) % banners.length)
              }
            >
              ›
            </button>

            <div
              className="homepage-promotional-banner-dots"
              aria-label="Banner navigation"
            >
              {banners.map((banner, index) => (
                <button
                  key={banner.id}
                  type="button"
                  className={`homepage-promotional-banner-dot ${
                    index === activeIndex ? "is-active" : ""
                  }`}
                  aria-label={`Show banner ${index + 1}`}
                  aria-current={index === activeIndex ? "true" : undefined}
                  onClick={() => setActiveIndex(index)}
                />
              ))}
            </div>
          </>
        )}
      </div>

      {activeBanner.alt_text && (
        <div className="homepage-promotional-banner-caption">
          {activeBanner.alt_text}
        </div>
      )}
    </section>
  );
}
