import { createClient } from "@/lib/supabase/server";
import CartBadge from "@/components/cart/CartBadge";
import { getShopNavbarData } from "@/lib/shop/navbar";
import { getStorefrontNavCards } from "@/lib/shop/nav-cards";

type ProductImage = {
  image_url: string;
  alt_text: string | null;
  display_order: number;
};

type Product = {
  id: string;
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

const masterCategories = [
  {
    title: "Office Bags",
    description: "Professional, practical and reusable bags.",
  },
  {
    title: "Hamper Bags",
    description: "Thoughtfully designed bags for gifting.",
  },
  {
    title: "Kids Bags",
    description: "Fun and reusable bags made for little ones.",
  },
  {
    title: "Tote Bags",
    description: "Everyday bags for shopping, gifting and more.",
  },
  {
    title: "Jute Bags",
    description: "Natural, durable and eco-friendly choices.",
  },
  {
    title: "Canvas Bags",
    description: "Strong canvas bags for everyday use.",
  },
];

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

  const { categories, subcategories } =
    await getShopNavbarData();
    const navCards = await getStorefrontNavCards();

  const { data, error } = await supabase
    .from("products")
    .select(`
      id,
      name,
      slug,
      description,
      price,
      compare_at_price,
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
    .order("created_at", { ascending: false });

  if (error) {
    console.error("Product fetch error:", error);
  }

  const products = (data ?? []) as Product[];

  const featuredProducts = products.slice(0, 5);
  const mostLovedProducts = products.slice(0, 6);

  return (
    <main className="shop-page">

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

        <div className="shop-brand">
          <span className="brand-mark">✿</span>
          <span>Prakratri Maitri</span>
        </div>

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
              <div
                key={category.id}
                className="nav-dropdown"
              >
                <a href={`/shop/${category.slug}`}>
                  {category.name.toUpperCase()} <span>⌄</span>
                </a>

                <div className="nav-dropdown-menu">
                  <a href={`/shop/${category.slug}`}>
                    All {category.name}
                  </a>

                  {categorySubcategories.map(
                    (subcategory) => (
                      <a
                        key={subcategory.id}
                        href={`/shop/${category.slug}/${subcategory.slug}`}
                      >
                        {subcategory.name}
                      </a>
                    )
                  )}
                </div>
              </div>
            );
          })}

          <a href="/reviews">
            REVIEWS
          </a>

        </nav>

        <div className="shop-nav-actions">

          <button type="button" aria-label="Search">
            ⌕
          </button>

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

      </header>


      {/* =====================================================
          MOVING CATEGORY RAIL
      ===================================================== */}

      <section className="category-rail">

        <div className="category-rail-track">

          {[...navCards, ...navCards].map((card, index) => (
            <a
              key={`${card.id}-${index}`}
              href={card.href || "/shop"}
              className="category-circle-item"
            >
              <div className="category-circle">
                {card.image_url ? (
                  <img
                    src={card.image_url}
                    alt={card.title}
                    loading="lazy"
                  />
                ) : (
                  <span>✿</span>
                )}
              </div>

              <span>{card.title}</span>
            </a>
          ))}

        </div>

      </section>


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
          <span>Hero Image</span>
          <small>Image will be added later</small>
        </div>

      </section>


      {/* =====================================================
          FEATURED COLLECTION
      ===================================================== */}

      <section className="collection-section">

        <div className="section-heading">

          <span className="eyebrow">
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

            <a href="/shop?category=new">
              View More →
            </a>

          </div>


          <div className="product-grid product-grid-five">

            {featuredProducts.length > 0 ? (
              featuredProducts.map((product) => (
                <ProductCard
                  key={product.id}
                  product={product}
                />
              ))
            ) : (
              <EmptyProductCards count={5} />
            )}

          </div>

        </div>

      </section>


      {/* =====================================================
          HERO / BANNER #2
      ===================================================== */}

      <section className="wide-banner">

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
          Banner Image
        </div>

      </section>


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

          {masterCategories.map((category) => (
            <a
              href={`/shop?category=${encodeURIComponent(
                category.title
              )}`}
              className="master-category-card"
              key={category.title}
            >

              <div className="master-category-placeholder">
                <span>{category.title}</span>
              </div>

              <div className="master-category-content">

                <h3>{category.title}</h3>

                <p>{category.description}</p>

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

      <section className="wide-banner wide-banner-reverse">

        <div className="wide-banner-placeholder">
          Banner Image
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
              <ProductCard
                key={product.id}
                product={product}
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

      <section className="story-banner">

        <div className="story-banner-placeholder">
          Story Image
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
          <h3>Prakratri Maitri</h3>

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

function ProductCard({
  product,
}: {
  product: Product;
}) {
  const sale =
    product.compare_at_price &&
    product.compare_at_price > product.price;

  /*
   * Product images are ordered by display_order.
   * display_order = 0 is the primary image uploaded
   * from the admin product form.
   */
  const images = [
    ...(product.product_images ?? []),
  ].sort(
    (a, b) =>
      a.display_order - b.display_order
  );

  const primaryImage = images[0];

  return (
    <article className="product-card">

      <a
        href={`/products/${product.slug}`}
        className="product-image-placeholder"
      >

        {sale && (
          <span className="sale-badge">
            SALE
          </span>
        )}

        {primaryImage ? (
          <img
            src={primaryImage.image_url}
            alt={
              primaryImage.alt_text ??
              product.name
            }
            className="product-image"
          />
        ) : (
          <>
            <span>Product Image</span>

            <small>
              Image will be added later
            </small>
          </>
        )}

      </a>


      <div className="product-card-content">

        <a
          href={`/products/${product.slug}`}
          className="product-name"
        >
          {product.name}
        </a>

        <div className="product-rating">
          <span>★★★★★</span>
          <small>New</small>
        </div>

        <div className="product-price">

          <strong>
            ₹{Number(product.price).toFixed(2)}
          </strong>

          {sale && (
            <s>
              ₹
              {Number(
                product.compare_at_price
              ).toFixed(2)}
            </s>
          )}

        </div>

        <a
          href={`/products/${product.slug}`}
          className="product-view-button"
        >
          View Product
        </a>

      </div>

    </article>
  );
}


/* ============================================================
   EMPTY PRODUCT PLACEHOLDERS
============================================================ */

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