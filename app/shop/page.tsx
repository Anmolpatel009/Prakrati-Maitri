import { createClient } from "@/lib/supabase/server";
import CartBadge from "@/components/cart/CartBadge";
import { getShopNavbarData } from "@/lib/shop/navbar";
import { getStorefrontNavCards } from "@/lib/shop/nav-cards";
import { getStorefrontVideos } from "@/lib/shop/media";
import { getHomepageSections } from "@/lib/shop/homepage";
import AdvertisingVideoSection from "@/components/shop/AdvertisingVideoSection";
import BulkOrderPopup from "@/components/shop/BulkOrderPopup";
import ShopNavDropdown from "@/components/shop/ShopNavDropdown";
import CategoryRail from "@/components/shop/CategoryRail";
import HomepagePromotionalBannerCarousel from "@/components/shop/HomepagePromotionalBannerCarousel";
import { getHomepageBanners } from "@/lib/shop/homepage-banners";
import {
  getCategoryBanners,
} from "@/lib/shop/category-banners";
import CategoryBannerView from "@/components/shop/CategoryBanner";
import type { CSSProperties } from "react";
import { parseHomepageMerchandising } from "@/lib/shop/homepage-merchandising";
import SharedProductCard from "@/components/shop/ProductCard";
import { getProductCardStyling } from "@/lib/shop/product-card-styling";
import type { ProductCardStylingConfig } from "@/lib/shop/product-card-styling";

export const dynamic = "force-dynamic";

type ProductImage = {
  image_url: string;
  alt_text: string | null;
  display_order: number;
};

type Product = {
  id: string;
  category_id: string | null;
  subcategory_id: string | null;
  display_order: number | null;
  name: string;
  slug: string;
  description: string | null;
  price: number;
  compare_at_price: number | null;
  categories:
    | {
        id: string;
        name: string;
        slug: string;
      }
    | {
        id: string;
        name: string;
        slug: string;
      }[]
    | null;
  product_images: ProductImage[] | null;
};

const testimonials = [
  {
    name: "Happy Customer",
    text: "Beautiful quality and exactly what we were looking for.",
  },
  {
    name: "Business Customer",
    text: "The bags were practical, elegant and perfect for our requirements.",
  },
  {
    name: "Repeat Customer",
    text: "A simple, thoughtful and sustainable shopping experience.",
  },
];

export default async function ShopPage() {
  const supabase = await createClient();

  const categoryBannersPromise = getCategoryBanners();

  const [
    { categories, subcategories },
    navCards,
    videos,
    homepageSections,
    homepageBanners,
  ] = await Promise.all([
    getShopNavbarData(),
    getStorefrontNavCards(),
    getStorefrontVideos(),
    getHomepageSections(),
    getHomepageBanners(),
  ]);

    const categoryBanners = await categoryBannersPromise;

    const homepageSectionMap = Object.fromEntries(
      homepageSections.map((section) => [
        section.section_key,
        section,
      ])
    );

    const heroSection = homepageSectionMap.hero;
    const purposeBanner = homepageSectionMap.purpose_banner;
    const giftingBanner = homepageSectionMap.gifting_banner;
    const storyBanner = homepageSectionMap.story_banner;

  const { data, error } = await supabase
    .from("products")
    .select(`
      id,
      name,
      slug,
      description,
      price,
      compare_at_price,
      category_id,
      subcategory_id,
      display_order,
      categories (
        id,
        name,
        slug
      ),
      inventory (
        quantity,
        reserved_quantity
      ),
      product_images (
        image_url,
        alt_text,
        display_order
      )
    `)
    .eq("is_active", true)
    .order("display_order", { ascending: true, nullsFirst: false }).order("created_at", { ascending: false });

  if (error) {
    console.error("Product fetch error:", error);
  }

  const products = (data ?? []) as Product[];
  const productCardStyling = await getProductCardStyling();

  const {
    config: merchandisingConfig,
    hasSavedConfig: hasSavedMerchandisingConfig,
  } = parseHomepageMerchandising(homepageSections);

  const productById = new Map(
    products.map((product) => [product.id, product]),
  );

  const configuredNewArrivals = merchandisingConfig.newArrivals
    .map((id) => productById.get(id))
    .filter((product): product is Product => Boolean(product));

  // Keep existing storefront behavior until Admin has saved the new config.
  const featuredProducts =
    configuredNewArrivals.length > 0
      ? configuredNewArrivals
      : hasSavedMerchandisingConfig
        ? []
        : products.slice(0, 5);

  const mostLovedProducts = products.slice(0, 6);

  const categoryBannerById = new Map(
    categoryBanners.map((banner) => [banner.category_id, banner]),
  );

  const homepageCollectionCards = merchandisingConfig.collectionCards
    .slice(0, 3)
    .map((card, index) => {
      const category = card.categoryId
        ? categories.find((item) => item.id === card.categoryId) ?? null
        : null;

      const subcategory = card.subcategoryId
        ? subcategories.find((item) => item.id === card.subcategoryId) ?? null
        : null;

      const resolvedCategoryId =
        card.type === "subcategory"
          ? subcategory?.category_id ?? null
          : card.categoryId;

      const productsForCard =
        card.type === "subcategory" && card.subcategoryId
          ? products
              .filter(
                (product) =>
                  product.subcategory_id === card.subcategoryId,
              )
              .slice(0, 4)
          : products
              .filter(
                (product) =>
                  product.category_id === resolvedCategoryId,
              )
              .slice(0, 4);

      const href =
        card.type === "subcategory" &&
        category &&
        subcategory
          ? `/shop/${category.slug}/${subcategory.slug}`
          : category
            ? `/shop/${category.slug}`
            : "/collections";

      const eyebrow =
        card.type === "subcategory"
          ? subcategory?.name?.toUpperCase() ?? "COLLECTION"
          : category?.name?.toUpperCase() ?? "COLLECTION";

      const boxStyle: CSSProperties = {
        backgroundColor: card.backgroundColor,
        color: card.textColor,
      };

      const headingStyle: CSSProperties = {
        fontFamily: card.fontFamily,
        fontSize: `${card.fontSize}px`,
        fontStyle: card.fontStyle,
        fontWeight: card.fontWeight,
        color: card.textColor,
      };

      return {
        card,
        index,
        category,
        subcategory,
        banner: resolvedCategoryId
          ? categoryBannerById.get(resolvedCategoryId) ?? null
          : null,
        products: productsForCard,
        href,
        eyebrow,
        boxStyle,
        headingStyle,
      };
    });


  const getProductCategorySlug = (product: Product) => {
    const category = Array.isArray(product.categories)
      ? product.categories[0]
      : product.categories;

    return category?.slug ?? null;
  };

  const laptopBagProducts = products
    .filter((product) => getProductCategorySlug(product) === "hand-bags")
    .slice(0, 4);

  const hamperBagProducts = products
    .filter((product) => getProductCategorySlug(product) === "hamper-bags")
    .slice(0, 4);

  const packagingBagProducts = products
    .filter((product) => getProductCategorySlug(product) === "packaging-bags")
    .slice(0, 4);

    const getCategoryBannerForSlug = (slug: string) => {
      const category = categories.find((item) => item.slug === slug);

      return category
        ? categoryBannerById.get(category.id) ?? null
        : null;
    };

    const laptopBagBanner = getCategoryBannerForSlug("hand-bags");
    const hamperBagBanner = getCategoryBannerForSlug("hamper-bags");
    const packagingBagBanner =
      getCategoryBannerForSlug("packaging-bags");


  return (
    <main className="shop-page">

      <BulkOrderPopup />

      {/* =====================================================
          PROMO BAR
      ===================================================== */}

      <div className="shop-promo-bar">
        <button type="button" aria-label="Previous promotion">
          ‹
        </button>

        <span>Free shipping on Order above 500/-</span>

        <button type="button" aria-label="Next promotion">
          ›
        </button>
      </div>


      {/* =====================================================
          NAVBAR
      ===================================================== */}

      <header className="shop-navbar">

        {/* ROW 1: Brand + utility actions */}
        <div className="shop-navbar-top">

          <a
            href="/shop"
            className="shop-brand"
            aria-label="PRAKRITI MAITRI home"
          >
            <span className="shop-brand-word">PRAKRITI MAITRI</span>
          </a>

          <a
            href="/shop"
            className="shop-brand-center"
            aria-label="PRAKRITI MAITRI home"
          >
            <span className="shop-brand-seal">
              <img
                src="/prakrati-maitri-logo.jpg"
                alt="PRAKRITI MAITRI"
                className="shop-brand-logo"
              />
            </span>
          </a>

          <div className="shop-nav-actions">

            <a href="/account" aria-label="Account">
              ♙
            </a>

            <a href="/wishlist" aria-label="Wishlist">
              ♡
              <span className="nav-count">0</span>
            </a>

            <a
              href="/cart"
              aria-label="Cart"
              className="relative"
            >
              ♧
              <CartBadge />
            </a>

          </div>

        </div>

        {/* ROW 2: Main navigation */}
        <nav className="shop-nav">

          <a href="/shop">NEW</a>

          {categories.map((category) => {
            const categorySubcategories = subcategories.filter(
              (subcategory) =>
                subcategory.category_id === category.id
            );

            if (categorySubcategories.length === 0) {
              return (
                <a
                  key={category.id}
                  href={`/shop/${category.slug}`}
                >
                  {category.name.toUpperCase()}
                </a>
              );
            }

            return (
              <ShopNavDropdown
                key={category.id}
                category={category}
                subcategories={categorySubcategories}
              />
            );
          })}

          <a href="/reviews">
            REVIEWS
          </a>

          <a href="/bulk-order" className="shop-nav-bulk-link">
            BULK ORDERS
          </a>

        </nav>

      </header>


      {/* =====================================================
          MOVING CATEGORY RAIL
      ===================================================== */}

      <CategoryRail navCards={navCards} />


      <HomepagePromotionalBannerCarousel banners={homepageBanners} />

{/* =====================================================
          MAIN HERO
      ===================================================== */}

      <section className="shop-hero">

        <div className="hero-content">

          <span className="eyebrow">
            ECO-FRIENDLY COLLECTION
          </span>

          <h1>
            Thoughtful products.
            <br />
            Meaningful choices.
          </h1>

          <p>
            Sustainable bags designed for everyday life,
            gifting, celebrations and businesses.
          </p>

          <a href="/shop?category=new" className="primary-button">
            Explore Collection
          </a>

        </div>

        <div className="hero-placeholder">
          {heroSection?.media_url ? (
            <img
              src={heroSection.media_url}
              alt={heroSection.title || "PRAKRITI MAITRI"}
              className="homepage-cms-image"
            />
          ) : (
            <>
              <span>Hero Image</span>
              <small>Image will be added later</small>
            </>
          )}
        </div>

      </section>


      {/* =====================================================
          FEATURED COLLECTION
      ===================================================== */}

      <section className="collection-section new-arrivals-section">

        <div className="section-heading">

          <span className="eyebrow collection-eyebrow">
            OUR COLLECTION
          </span>

          <h2>Made for every occasion</h2>

          <p>
            Thoughtfully designed bags for everyday use,
            gifting, packaging and bulk orders.
          </p>

        </div>


        <div className="collection-box">

          <div className="collection-box-header">

            <div>
              <span className="collection-label">
                FEATURED COLLECTION
              </span>

              <h3>New Arrivals</h3>
            </div>

            <a href="/collections">
              View More →
            </a>

          </div>


          <div className="new-arrivals-viewport">

              <div className="new-arrivals-track">

                <div className="new-arrivals-set">
                  {featuredProducts.map((product) => (
                    <SharedProductCard
                      key={`new-arrivals-1-${product.id}`}
                      product={product}
                      config={productCardStyling}
                    />
                  ))}
                </div>

                <div
                  className="new-arrivals-set"
                  aria-hidden="true"
                >
                  {featuredProducts.map((product) => (
                    <SharedProductCard
                      key={`new-arrivals-2-${product.id}`}
                      product={product}
                      config={productCardStyling}
                    />
                  ))}
                </div>

              </div>

            </div>

        </div>

      </section>


      {/* =====================================================
          HERO / BANNER #2
      ===================================================== */}

      <section className="wide-banner wide-banner-purpose">

        <div className="wide-banner-content">

          <span className="eyebrow">
            MADE WITH PURPOSE
          </span>

          <h2>
            Carry something
            <br />
            that means more.
          </h2>

          <p>
            Eco-friendly choices that bring beauty,
            usefulness and purpose together.
          </p>

          <a href="/shop" className="secondary-button">
            Shop Collection
          </a>

        </div>

        <div className="wide-banner-placeholder">
          {purposeBanner?.media_url ? (
            <img
              src={purposeBanner.media_url}
              alt={purposeBanner.title || "PRAKRITI MAITRI"}
              className="homepage-cms-image"
            />
          ) : (
            <span>Banner Image</span>
          )}
        </div>

      </section>


      {homepageCollectionCards.map(
        ({
          card,
          index,
          banner,
          products,
          href,
          eyebrow,
          boxStyle,
          headingStyle,
        }) => (
          <div
            key={card.slot || index}
            className={`category-editorial-group category-editorial-group-0${
              index + 1
            } category-editorial-group-tall-banner`}
          >
            <CategoryBannerView banner={banner} />

            <CategoryProductSection
              productCardStyling={productCardStyling}
              title={card.heading}
              eyebrow={eyebrow}
              subheading={card.subheading}
              href={href}
              products={products}
              boxStyle={boxStyle}
              headingStyle={headingStyle}
            />
          </div>
        ),
      )}

      {/* =====================================================
          MASTER CATEGORIES
      ===================================================== */}

      <section className="master-category-section">

        <div className="section-heading">

          <span className="eyebrow">
            EXPLORE
          </span>

          <h2>Shop by Category</h2>

          <p>
            Find the right bag for every purpose.
          </p>

        </div>


        <div className="master-category-grid">

          {categories.map((category) => (
            <a
              href={`/shop/${category.slug}`}
              className="master-category-card"
              key={category.id}
            >
              <div className="master-category-placeholder">
                {category.image_url ? (
                  <img
                    src={category.image_url}
                    alt={category.name}
                    className="master-category-image"
                    loading="lazy"
                  />
                ) : (
                  <span>{category.name}</span>
                )}
              </div>

              <div className="master-category-content">
                <h3>{category.name}</h3>

                <p>
                  Explore products from our {category.name.toLowerCase()} collection.
                </p>

                <span>
                  Explore →
                </span>
              </div>
            </a>
          ))}

        </div>

      </section>


      {/* =====================================================
          HERO / BANNER #3
      ===================================================== */}

      <section className="wide-banner wide-banner-reverse wide-banner-gifting-full-bleed">

        <div className="wide-banner-placeholder">
          {giftingBanner?.media_url ? (
            <img
              src={giftingBanner.media_url}
              alt={giftingBanner.title || "PRAKRITI MAITRI"}
              className="homepage-cms-image"
            />
          ) : (
            <span>Banner Image</span>
          )}
        </div>

        <div className="wide-banner-content">

          <span className="eyebrow">
            CELEBRATE SUSTAINABLY
          </span>

          <h2>
            Gifts that make
            <br />
            moments memorable.
          </h2>

          <p>
            Discover thoughtful bags for celebrations,
            gifting and special occasions.
          </p>

          <a
            href="/shop?event=raksha-bandhan"
            className="secondary-button"
          >
            Explore Collection
          </a>

        </div>

      </section>


      {/* =====================================================
          MOST LOVED
      ===================================================== */}

      <AdvertisingVideoSection videos={videos} />

    <section className="most-loved-section">

        <div className="section-heading">

          <span className="eyebrow">
            CUSTOMER FAVOURITES
          </span>

          <h2>Most Loved Products</h2>

          <p>
            Some of the products our customers keep coming back
            for.
          </p>

        </div>


        <div className="product-grid product-grid-three">

          {mostLovedProducts.length > 0 ? (
            mostLovedProducts.map((product) => (
              <SharedProductCard
                key={product.id}
                product={product}
                config={productCardStyling}
              />
            ))
          ) : (
            <EmptyProductCards count={6} />
          )}

        </div>

      </section>


      {/* =====================================================
          TESTIMONIALS
      ===================================================== */}

      <section className="testimonials-section">

        <div className="section-heading">

          <span className="eyebrow">
            CUSTOMER STORIES
          </span>

          <h2>Loved by our customers</h2>

        </div>


        <div className="testimonial-grid">

          {testimonials.map((testimonial) => (
            <article
              className="testimonial-card"
              key={testimonial.name}
            >

              <div className="testimonial-stars">
                ★★★★★
              </div>

              <p>
                “{testimonial.text}”
              </p>

              <strong>
                {testimonial.name}
              </strong>

            </article>
          ))}

        </div>

      </section>


      {/* =====================================================
          STORYTELLING BANNER
      ===================================================== */}

      <section className="story-banner story-banner-full-bleed">

        <div className="story-banner-placeholder">
          {storyBanner?.media_url ? (
            <img
              src={storyBanner.media_url}
              alt={storyBanner.title || "Our Story"}
              className="homepage-cms-image"
            />
          ) : (
            <span>Story Image</span>
          )}
        </div>

        <div className="story-content">

          <span className="eyebrow">
            OUR STORY
          </span>

          <h2>
            More than a bag.
            <br />
            A choice for tomorrow.
          </h2>

          <p>
            We believe everyday products can be beautiful,
            useful and kinder to the world around us.
          </p>

          <a href="/our-story" className="primary-button">
            Our Story →
          </a>

        </div>

      </section>


      {/* =====================================================
          FOOTER
      ===================================================== */}

      <footer className="shop-footer">

        <div className="footer-brand">
          <h3>PRAKRITI MAITRI</h3>

          <p>
            Thoughtful products for a more sustainable
            everyday.
          </p>
        </div>

        <div>
          <h4>Shop</h4>
          <a href="/shop">All Products</a>
          <a href="/shop?category=hand-bags">Hand Bags</a>
          <a href="/shop?category=packaging-bags">
            Packaging Bags
          </a>
          <a href="/shop?category=sample-kits">
            Sample Kits
          </a>
        </div>

        <div>
          <h4>Explore</h4>
          <a href="/our-story">Our Story</a>
          <a href="/reviews">Reviews</a>
          <a href="/contact">Contact</a>
        </div>

        <div>
          <h4>Customer Care</h4>
          <a href="/cart">Cart</a>
          <a href="/account">My Account</a>
          <a href="/shipping">Shipping</a>
        </div>

      </footer>

    </main>
  );
}


/* ============================================================
   PRODUCT CARD
============================================================ */

function CategoryProductSection({
  productCardStyling,
  title,
  eyebrow,
  subheading,
  href,
  products,
  boxStyle,
  headingStyle,
}: {
  title: string;
  eyebrow: string;
  subheading: string;
  href: string;
  products: Product[];
  boxStyle: CSSProperties;
  headingStyle: CSSProperties;
  productCardStyling: ProductCardStylingConfig;
}) {
  return (
    <section className="collection-section category-product-section">
      <div className="collection-box" style={boxStyle}>
        <div className="collection-box-header">
          <div>
            <span className="collection-label">{eyebrow}</span>
            <h3 style={headingStyle}>{title}</h3>
            {subheading ? (
              <p className="category-product-subheading">
                {subheading}
              </p>
            ) : null}
          </div>

          <a href={href}>View More →</a>
        </div>

        <div className="product-grid category-product-grid">
          {products.length > 0 ? (
            products.map((product) => (
              <SharedProductCard
                key={product.id}
                product={product}
                config={productCardStyling}
              />
            ))
          ) : (
            <EmptyProductCards count={4} />
          )}
        </div>
      </div>
    </section>
  );
}


function EmptyProductCards({
  count,
}: {
  count: number;
}) {
  return (
    <>
      {Array.from({ length: count }).map((_, index) => (
        <article
          className="product-card placeholder-card"
          key={index}
        >

          <div className="product-image-placeholder">
            <span>Product Image</span>
            <small>Coming soon</small>
          </div>

          <div className="product-card-content">

            <span className="placeholder-line large" />

            <span className="placeholder-line medium" />

            <span className="placeholder-line small" />

          </div>

        </article>
      ))}
    </>
  );
}
