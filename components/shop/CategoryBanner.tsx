import type { CategoryBanner as CategoryBannerData } from "@/lib/shop/category-banners";

type Props = {
  banner?: CategoryBannerData | null;
};

export default function CategoryBanner({ banner }: Props) {
  if (!banner) {
    return null;
  }

  return (
    <section
      className="category-banner-section"
      aria-label="Category banner"
    >
      <div
        className={
          banner.mobile_image_url
            ? "category-banner-frame category-banner-frame-responsive"
            : "category-banner-frame"
        }
      >
        <picture>
          {banner.mobile_image_url && (
            <source
              media="(max-width: 768px)"
              srcSet={banner.mobile_image_url}
            />
          )}
          <img
            src={banner.image_url}
            alt={banner.alt_text || "Category banner"}
            className="category-banner-image"
            draggable={false}
          />
        </picture>
      </div>
    </section>
  );
}
