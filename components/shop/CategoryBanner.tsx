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
      <div className="category-banner-frame">
        <img
          src={banner.image_url}
          alt={banner.alt_text || "Category banner"}
          className="category-banner-image"
          draggable={false}
        />
      </div>
    </section>
  );
}
