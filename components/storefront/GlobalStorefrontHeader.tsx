import CartBadge from "@/components/cart/CartBadge";
import ShopNavDropdown from "@/components/shop/ShopNavDropdown";
import ShopModeSwitcher from "@/components/shop/ShopModeSwitcher";
import type { NavbarCustomizationConfig } from "@/lib/shop/navbar-customization";

type Category = {
  id: string;
  name: string;
  slug: string;
  image_url: string | null;
  is_active: boolean;
};

type Subcategory = {
  id: string;
  category_id: string;
  name: string;
  slug: string;
  is_active: boolean;
  display_order: number;
};

type Props = {
  navbarData: {
    categories: Category[];
    subcategories: Subcategory[];
  };
  customization: NavbarCustomizationConfig;
};

export default function GlobalStorefrontHeader({
  navbarData,
  customization,
}: Props) {
  const { categories, subcategories } = navbarData;

  return (
    <>
      <div className="shop-promo-bar">
        <span>Free delivery over ₹100 order value</span>

        <button type="button" aria-label="Next promotion">
          ›
        </button>
      </div>

      <header className="shop-navbar">
        <div className="shop-navbar-top">
          <a
            href="/shop"
            className="shop-brand"
            aria-label="PRAKRITI MAITRI home"
            style={{
              fontFamily: customization.brand_font_family,
              fontSize: `${customization.brand_font_size}px`,
              fontWeight: customization.brand_font_weight,
              fontStyle: customization.brand_font_style,
              color: customization.brand_text_color,
            }}
          >
            <span className="shop-brand-word">PRAKRITI MAITRI</span>
          </a>

          <div className="shop-brand-center">
            <ShopModeSwitcher />
          </div>

          <div className="shop-nav-actions">
            <a href="/account" aria-label="Account">
              ♙
            </a>

            <a href="/wishlist" aria-label="Wishlist">
              ♡
              <span className="nav-count">0</span>
            </a>

            <a href="/cart" aria-label="Cart" className="relative">
              ♧
              <CartBadge />
            </a>
          </div>
        </div>

        <nav className="shop-nav">
          {customization.items
            .filter(
              (item) =>
                item.key.trim().toLowerCase() !== "prev" &&
                item.label?.trim().toUpperCase() !== "PREV",
            )
            .map((item) => {
            if (item.type === "new") {
              return (
                <a key={item.key} href={item.href ?? "/shop"}>
                  {item.label ?? "NEW"}
                </a>
              );
            }

            if (item.type === "reviews") {
              return (
                <a key={item.key} href={item.href ?? "/reviews"}>
                  {item.label ?? "REVIEWS"}
                </a>
              );
            }

            if (item.type === "link") {
              return (
                <a key={item.key} href={item.href ?? "#"}>
                  {item.label ?? "LINK"}
                </a>
              );
            }

            if (item.type === "bulk_orders") {
              return (
                <a
                  key={item.key}
                  href="/bulk-order"
                  className="shop-nav-bulk-link"
                >
                  BULK ORDERS
                </a>
              );
            }

            if (item.type === "category") {
              const category = categories.find(
                (candidate) => candidate.id === item.id,
              );

              if (!category) {
                return null;
              }

              const categorySubcategories = subcategories.filter(
                (subcategory) =>
                  subcategory.category_id === category.id,
              );

              if (categorySubcategories.length === 0) {
                return (
                  <a
                    key={item.key}
                    href={`/shop/${category.slug}`}
                  >
                    {category.name.toUpperCase()}
                  </a>
                );
              }

              return (
                <ShopNavDropdown
                  key={item.key}
                  category={category}
                  subcategories={categorySubcategories}
                />
              );
            }

            const subcategory = subcategories.find(
              (candidate) => candidate.id === item.id,
            );

            if (!subcategory) {
              return null;
            }

            const category = categories.find(
              (candidate) =>
                candidate.id === subcategory.category_id,
            );

            if (!category) {
              return null;
            }

            return (
              <a
                key={item.key}
                href={`/shop/${category.slug}/${subcategory.slug}`}
              >
                {subcategory.name.toUpperCase()}
              </a>
            );
            })}
        </nav>
      </header>
    </>
  );
}
