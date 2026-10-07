import { createClient } from "@/lib/supabase/server";
import { getShopNavbarData } from "@/lib/shop/navbar";
import { getStorefrontNavCards } from "@/lib/shop/nav-cards";
import { getStorefrontVideos } from "@/lib/shop/media";
import { getHomepageSections } from "@/lib/shop/homepage";
import AdvertisingVideoSection from "@/components/shop/AdvertisingVideoSection";
import BulkOrderPopup from "@/components/shop/BulkOrderPopup";
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
import NewArrivalsRail from "@/components/shop/NewArrivalsRail";
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

type ShopPageProps = {
  searchParams: Promise<{
    door?: string;
  }>;
};

export default async function ShopPage({
  searchParams,
}: ShopPageProps) {
  const params = await searchParams;
  const isBulkMode = params.door === "bulk";

  const supabase = await createClient();

  const [
    { categories, subcategories },
  ] = await Promise.all([
    getShopNavbarData(),
  ]);

  if (isBulkMode) {
    const bulkCategory = categories.find(
      (category) =>
        category.name.trim().toLowerCase() === "corporate & bulk",
    );

    if (!bulkCategory) {
      return (
        <main className="min-h-screen bg-[#F9F7F2] px-6 py-20 text-center">
          <h1 className="font-serif text-4xl font-semibold text-[#4A5D23]">
            Corporate & Bulk
          </h1>
          <p className="mx-auto mt-4 max-w-xl text-[#3D3D3D]/70">
            The Corporate & Bulk catalogue is currently unavailable.
          </p>
        </main>
      );
    }

    const { data: bulkProducts, error: bulkProductsError } =
      await supabase
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
          product_images (
            image_url,
            alt_text,
            display_order
          )
        `)
        .eq("category_id", bulkCategory.id)
        .eq("is_active", true)
        .order("display_order", {
          ascending: true,
          nullsFirst: false,
        })
        .order("created_at", { ascending: false });

    if (bulkProductsError) {
      console.error(
        "Corporate & Bulk products fetch error:",
        bulkProductsError,
      );
    }

    const bulkProductCardStyling =
      await getProductCardStyling();

    return (
      <main className="min-h-screen bg-[#F9F7F2] text-[#3D3D3D] shop-listing-page">
        <section className="shop-listing-promo">
          <div className="mx-auto max-w-7xl px-6 py-10 md:px-10 lg:px-16">
            <div className="rounded-[2rem] border border-[#D2B48C]/40 bg-[#E8E1D2] px-6 py-16 text-center md:px-12 md:py-24">
              <p className="mb-4 text-sm font-medium uppercase tracking-[0.2em] text-[#4A5D23]">
                Prakriti Maitri
              </p>

              <h1 className="font-serif text-4xl font-semibold text-[#4A5D23] md:text-5xl">
                Corporate & Bulk
              </h1>

              <p className="mx-auto mt-5 max-w-2xl text-base leading-7 text-[#3D3D3D]/75 md:text-lg">
                Explore our Corporate & Bulk catalogue for
                business orders, gifting and custom requirements.
              </p>
            </div>
          </div>
        </section>

        <section className="px-6 pb-20 md:px-10 lg:px-16">
          <div className="mx-auto max-w-7xl">
            {bulkProducts && bulkProducts.length > 0 ? (
              <div className="product-grid product-grid-three storefront-product-grid">
                {bulkProducts.map((product) => (
                  <SharedProductCard
                    key={product.id}
                    product={product}
                    config={bulkProductCardStyling}
                    isBulkEnquiry
                  />
                ))}
              </div>
            ) : (
              <div className="rounded-[2rem] border border-[#D2B48C]/40 bg-white px-6 py-20 text-center">
                <p className="text-sm font-medium uppercase tracking-[0.15em] text-[#4A5D23]">
                  Coming Soon
                </p>

                <h2 className="mt-3 font-serif text-3xl font-semibold text-[#4A5D23]">
                  More products are on the way.
                </h2>
              </div>
            )}
          </div>
        </section>
      </main>
    );
  }

  const categoryBannersPromise = getCategoryBanners();

  const [
    navCards,
    videos,
    homepageSections,
    homepageBanners,
  ] = await Promise.all([
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

  const homepageCategoryRows = categories
    .map((category, index) => ({
      category,
      index,
      banner: categoryBannerById.get(category.id) ?? null,
      products: products
        .filter((product) => product.category_id === category.id)
        .slice(0, 4),
    }))
    .filter((row) => row.products.length > 0);

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


          <NewArrivalsRail
            products={featuredProducts}
            config={productCardStyling}
          />        </div>

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

          {homepageCategoryRows.map(
            ({ category, banner, products: categoryProducts, index }) => (
              <div
                className={`master-category-row ${
                  index % 2 === 1 ? "is-flip" : ""
                }`}
                key={category.id}
              >
                <a
                  href={`/shop/${category.slug}`}
                  className="master-category-row-banner"
                  aria-label={`Explore ${category.name}`}
                >
                  {banner ? (
                    <CategoryBannerView banner={banner} />
                  ) : (
                    <section
                      className="category-banner-section"
                      aria-label={`${category.name} category banner`}
                    >
                      <div className="category-banner-frame">
                        {category.image_url ? (
                          <img
                            src={category.image_url}
                            alt={category.name}
                            className="category-banner-image"
                            loading="lazy"
                            draggable={false}
                          />
                        ) : (
                          <div className="master-category-banner-fallback">
                            {category.name}
                          </div>
                        )}
                      </div>
                    </section>
                  )}
                </a>

                <div className="master-category-row-products">
                  {categoryProducts.map((product) => (
                    <SharedProductCard
                      key={product.id}
                      product={product}
                      config={productCardStyling}
                      isBulkEnquiry={
                        category.name.trim().toLowerCase() ===
                        "corporate & bulk"
                      }
                    />
                  ))}
                </div>
              </div>
            ),
          )}

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


        <div className="product-grid product-grid-three storefront-product-grid">

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

        <div className="product-grid category-product-grid storefront-product-grid">
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
