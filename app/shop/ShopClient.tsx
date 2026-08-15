"use client";

import Link from "next/link";
import { useMemo, useState } from "react";

type Product = {
  id: string;
  name: string;
  slug: string;
  description: string | null;
  price: number;
  compareAtPrice: number | null;
  sku: string | null;
  category: {
    id: string;
    name: string;
    slug: string;
  } | null;
  availableQuantity: number;
  image: {
    imageUrl: string;
    altText: string | null;
  } | null;
};

type ShopClientProps = {
  products: Product[];
};

export default function ShopClient({
  products,
}: ShopClientProps) {
  const [activeCategory, setActiveCategory] = useState("all");

  const categories = useMemo(() => {
    const map = new Map<
      string,
      { name: string; slug: string }
    >();

    products.forEach((product) => {
      if (product.category) {
        map.set(product.category.slug, {
          name: product.category.name,
          slug: product.category.slug,
        });
      }
    });

    return Array.from(map.values());
  }, [products]);

  const filteredProducts = useMemo(() => {
    if (activeCategory === "all") {
      return products;
    }

    return products.filter(
      (product) =>
        product.category?.slug === activeCategory
    );
  }, [products, activeCategory]);

  return (
    <main className="shop-page">
      {/* HERO */}
      <section className="shop-hero">
        <p className="shop-eyebrow">
          PRAKRATI MAITRI
        </p>

        <h1>Thoughtfully made. Naturally better.</h1>

        <p className="shop-intro">
          Discover sustainable products made for everyday
          living, thoughtfully designed with nature in mind.
        </p>
      </section>

      {/* CATEGORY TABS */}
      <nav
        className="shop-categories"
        aria-label="Product categories"
      >
        <button
          type="button"
          className={
            activeCategory === "all"
              ? "category-tab active"
              : "category-tab"
          }
          onClick={() => setActiveCategory("all")}
        >
          All
        </button>

        {categories.map((category) => (
          <button
            key={category.slug}
            type="button"
            className={
              activeCategory === category.slug
                ? "category-tab active"
                : "category-tab"
            }
            onClick={() =>
              setActiveCategory(category.slug)
            }
          >
            {category.name}
          </button>
        ))}
      </nav>

      {/* COLLECTION */}
      <section className="shop-collection">
        <div className="shop-section-heading">
          <div>
            <p className="section-eyebrow">
              OUR COLLECTION
            </p>

            <h2>Most-Loved Collections</h2>
          </div>

          <p>
            {filteredProducts.length}{" "}
            {filteredProducts.length === 1
              ? "product"
              : "products"}
          </p>
        </div>

        {filteredProducts.length > 0 ? (
          <div className="product-grid">
            {filteredProducts.map((product) => {
              const discount =
                product.compareAtPrice &&
                product.compareAtPrice > product.price
                  ? Math.round(
                      ((product.compareAtPrice -
                        product.price) /
                        product.compareAtPrice) *
                        100
                    )
                  : null;

              return (
                <article
                  key={product.id}
                  className="product-card"
                >
                  {/* IMAGE */}
                  <Link
                    href={`/products/${product.slug}`}
                    className="product-image-link"
                  >
                    <div className="product-image-wrapper">
                      {product.image ? (
                        <img
                          src={product.image.imageUrl}
                          alt={
                            product.image.altText ||
                            product.name
                          }
                          className="product-image"
                        />
                      ) : (
                        <div className="product-image-placeholder">
                          No image available
                        </div>
                      )}

                      {discount && (
                        <span className="product-badge">
                          {discount}% OFF
                        </span>
                      )}

                      <span className="shop-it-overlay">
                        Shop It →
                      </span>
                    </div>
                  </Link>

                  {/* DETAILS */}
                  <div className="product-details">
                    {product.category && (
                      <span className="product-category">
                        {product.category.name}
                      </span>
                    )}

                    <h3>
                      <Link
                        href={`/products/${product.slug}`}
                      >
                        {product.name}
                      </Link>
                    </h3>

                    {product.description && (
                      <p className="product-description">
                        {product.description}
                      </p>
                    )}

                    <div className="product-price">
                      <span>
                        ₹{product.price.toFixed(0)}
                      </span>

                      {product.compareAtPrice && (
                        <s>
                          ₹
                          {product.compareAtPrice.toFixed(
                            0
                          )}
                        </s>
                      )}
                    </div>

                    <div className="product-stock">
                      {product.availableQuantity > 0 ? (
                        <>
                          <span className="stock-dot" />
                          {product.availableQuantity}{" "}
                          available
                        </>
                      ) : (
                        <span className="out-of-stock">
                          Out of stock
                        </span>
                      )}
                    </div>

                    <Link
                      href={`/products/${product.slug}`}
                      className="product-button"
                    >
                      View Product
                    </Link>
                  </div>
                </article>
              );
            })}
          </div>
        ) : (
          <div className="empty-products">
            <h3>No products found</h3>
            <p>
              There are no products in this collection yet.
            </p>

            <button
              type="button"
              onClick={() => setActiveCategory("all")}
              className="product-button"
            >
              View All Products
            </button>
          </div>
        )}
      </section>

      {/* TRUST SECTION */}
      <section className="why-section">
        <div className="shop-section-heading centered">
          <p className="section-eyebrow">
            WHY PRAKRATI MAITRI
          </p>

          <h2>Made with purpose</h2>

          <p>
            Products designed to be useful, durable and
            kinder to the planet.
          </p>
        </div>

        <div className="why-grid">
          <div className="why-card">
            <div className="why-icon">🌿</div>
            <h3>Sustainable Material</h3>
            <p>
              Thoughtfully selected materials with a focus
              on sustainability.
            </p>
          </div>

          <div className="why-card">
            <div className="why-icon">🛡</div>
            <h3>Durable & Long-Lasting</h3>
            <p>
              Designed for everyday use without
              compromising on quality.
            </p>
          </div>

          <div className="why-card">
            <div className="why-icon">♻</div>
            <h3>Reusable</h3>
            <p>
              Products made to be used again and again.
            </p>
          </div>
        </div>
      </section>
    </main>
  );
}