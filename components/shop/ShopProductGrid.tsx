"use client";

import { useMemo, useState } from "react";
import Link from "next/link";

type ProductImage = {
  image_url: string;
  alt_text: string | null;
  display_order: number;
};

type Category = {
  id: string;
  name: string;
  slug: string;
};

type Inventory = {
  quantity: number;
  reserved_quantity: number;
};

type Product = {
  id: string;
  name: string;
  slug: string;
  description: string | null;
  price: number;
  compare_at_price: number | null;
  sku: string | null;

  categories: Category | Category[] | null;

  inventory: Inventory | Inventory[] | null;

  product_images: ProductImage[] | null;
};

type Props = {
  products: Product[];
};

export default function ShopProductGrid({
  products,
}: Props) {
  const [activeCategory, setActiveCategory] =
    useState("all");

  const categories = useMemo(() => {
    const categoryMap = new Map<
      string,
      {
        id: string;
        name: string;
        slug: string;
        image: string | null;
      }
    >();

    products.forEach((product) => {
      const category = Array.isArray(product.categories)
        ? product.categories[0]
        : product.categories;

      if (!category) return;

      const images = [
        ...(product.product_images ?? []),
      ].sort(
        (a, b) =>
          a.display_order - b.display_order
      );

      if (!categoryMap.has(category.id)) {
        categoryMap.set(category.id, {
          id: category.id,
          name: category.name,
          slug: category.slug,
          image: images[0]?.image_url ?? null,
        });
      }
    });

    return Array.from(categoryMap.values());
  }, [products]);

  const filteredProducts = useMemo(() => {
    if (activeCategory === "all") {
      return products;
    }

    return products.filter((product) => {
      const category = Array.isArray(product.categories)
        ? product.categories[0]
        : product.categories;

      return category?.slug === activeCategory;
    });
  }, [products, activeCategory]);

  const activeCategoryData = categories.find(
    (category) =>
      category.slug === activeCategory
  );

  return (
    <main className="shop-page">

      {/* CATEGORY SELECTOR */}
      <section className="shop-categories">

        <button
          type="button"
          className={`category-pill ${
            activeCategory === "all"
              ? "active"
              : ""
          }`}
          onClick={() =>
            setActiveCategory("all")
          }
        >
          <span className="category-pill-image category-all">
            All
          </span>

          <span>All Products</span>
        </button>

        {categories.map((category) => (
          <button
            type="button"
            key={category.id}
            className={`category-pill ${
              activeCategory === category.slug
                ? "active"
                : ""
            }`}
            onClick={() =>
              setActiveCategory(category.slug)
            }
          >
            <span className="category-pill-image">
              {category.image ? (
                <img
                  src={category.image}
                  alt={category.name}
                />
              ) : (
                <span>+</span>
              )}
            </span>

            <span>{category.name}</span>
          </button>
        ))}

      </section>


      {/* COLLECTION HEADER */}
      <section className="shop-heading">

        <p className="shop-eyebrow">
          ECO-FRIENDLY COLLECTION
        </p>

        <h1>
          {activeCategory === "all"
            ? "Our Collection"
            : activeCategoryData?.name ??
              "Our Collection"}
        </h1>

        <p>
          Thoughtfully made bags designed for
          everyday use, gifting, packaging and
          bulk orders.
        </p>

      </section>


      {/* PRODUCT GRID */}
      {filteredProducts.length > 0 ? (

        <section className="product-grid">

          {filteredProducts.map((product) => {

            const inventory = Array.isArray(
              product.inventory
            )
              ? product.inventory[0]
              : product.inventory;

            const availableQuantity =
              (inventory?.quantity ?? 0) -
              (inventory?.reserved_quantity ?? 0);

            const images = [
              ...(product.product_images ?? []),
            ].sort(
              (a, b) =>
                a.display_order -
                b.display_order
            );

            const primaryImage = images[0];
            const secondaryImage = images[1];

            const hasDiscount =
              product.compare_at_price !== null &&
              Number(product.compare_at_price) >
                Number(product.price);

            return (
              <article
                key={product.id}
                className="product-card"
              >

                {/* IMAGE */}
                <Link
                  href={`/product/${product.slug}`}
                  className="product-image-link"
                >

                  <div className="product-image-wrapper">

                    {primaryImage ? (
                      <>
                        <img
                          src={
                            primaryImage.image_url
                          }
                          alt={
                            primaryImage.alt_text ??
                            product.name
                          }
                          className={`product-image ${
                            secondaryImage
                              ? "has-secondary"
                              : ""
                          }`}
                        />

                        {secondaryImage && (
                          <img
                            src={
                              secondaryImage.image_url
                            }
                            alt={
                              secondaryImage.alt_text ??
                              product.name
                            }
                            className="product-image product-image-secondary"
                          />
                        )}
                      </>
                    ) : (
                      <div className="product-image-placeholder">
                        Product image unavailable
                      </div>
                    )}

                    {hasDiscount && (
                      <span className="sale-badge">
                        SALE
                      </span>
                    )}

                  </div>

                </Link>


                {/* PRODUCT INFORMATION */}
                <div className="product-info">

                  <Link
                    href={`/product/${product.slug}`}
                    className="product-name-link"
                  >
                    <h2>{product.name}</h2>
                  </Link>


                  {product.description && (
                    <p className="product-description">
                      {product.description}
                    </p>
                  )}


                  {/* TEMPORARY RATING */}
                  <div
                    className="product-rating"
                    aria-label="New product"
                  >
                    <span aria-hidden="true">
                      ★★★★★
                    </span>

                    <small>
                      New
                    </small>
                  </div>


                  {/* PRICE */}
                  <div className="product-price">

                    <strong>
                      ₹
                      {Number(
                        product.price
                      ).toFixed(2)}
                    </strong>

                    {hasDiscount && (
                      <del>
                        ₹
                        {Number(
                          product.compare_at_price
                        ).toFixed(2)}
                      </del>
                    )}

                  </div>


                  {/* STOCK */}
                  <p
                    className={`stock-status ${
                      availableQuantity > 0
                        ? "in-stock"
                        : "out-of-stock"
                    }`}
                  >
                    {availableQuantity > 0
                      ? `${availableQuantity} available`
                      : "Out of stock"}
                  </p>


                  {/* VIEW PRODUCT */}
                  <Link
                    href={`/product/${product.slug}`}
                    className="view-product-button"
                  >
                    View Product
                  </Link>

                </div>

              </article>
            );
          })}

        </section>

      ) : (

        <section className="empty-products">

          <h2>No products found</h2>

          <p>
            There are currently no products in
            this collection.
          </p>

        </section>

      )}

    </main>
  );
}