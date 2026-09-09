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
  categoryId: string | null;
  subcategoryId: string | null;
  availableQuantity: number;
  image: {
    imageUrl: string;
    altText: string | null;
  } | null;
};

type Category = {
  id: string;
  name: string;
  slug: string;
};

type Subcategory = {
  id: string;
  name: string;
  slug: string;
  category_id: string;
};

type Props = {
  products: Product[];
  categories: Category[];
  subcategories: Subcategory[];
};

export default function CollectionsClient({
  products,
  categories,
  subcategories,
}: Props) {
  const [search, setSearch] = useState("");
  const [category, setCategory] = useState("all");
  const [subcategory, setSubcategory] = useState("all");
  const [minPrice, setMinPrice] = useState("");
  const [maxPrice, setMaxPrice] = useState("");
  const [sort, setSort] = useState("featured");

  const availableSubcategories = useMemo(() => {
    if (category === "all") return subcategories;

    return subcategories.filter(
      (item) => item.category_id === category
    );
  }, [category, subcategories]);

  const filteredProducts = useMemo(() => {
    const query = search.trim().toLowerCase();
    const minimum = minPrice ? Number(minPrice) : null;
    const maximum = maxPrice ? Number(maxPrice) : null;

    const result = products.filter((product) => {
      const matchesSearch =
        !query ||
        product.name.toLowerCase().includes(query) ||
        product.description?.toLowerCase().includes(query) ||
        product.sku?.toLowerCase().includes(query);

      const matchesCategory =
        category === "all" ||
        product.categoryId === category;

      const matchesSubcategory =
        subcategory === "all" ||
        product.subcategoryId === subcategory;

      const matchesMin =
        minimum === null ||
        product.price >= minimum;

      const matchesMax =
        maximum === null ||
        product.price <= maximum;

      return (
        matchesSearch &&
        matchesCategory &&
        matchesSubcategory &&
        matchesMin &&
        matchesMax
      );
    });

    switch (sort) {
      case "price-low":
        result.sort((a, b) => a.price - b.price);
        break;

      case "price-high":
        result.sort((a, b) => b.price - a.price);
        break;

      case "name":
        result.sort((a, b) =>
          a.name.localeCompare(b.name)
        );
        break;

      default:
        break;
    }

    return result;
  }, [
    products,
    search,
    category,
    subcategory,
    minPrice,
    maxPrice,
    sort,
  ]);

  function handleCategoryChange(value: string) {
    setCategory(value);
    setSubcategory("all");
  }

  function clearFilters() {
    setSearch("");
    setCategory("all");
    setSubcategory("all");
    setMinPrice("");
    setMaxPrice("");
    setSort("featured");
  }

  return (
    <main className="collections-page">
      <section className="collections-hero">
        <p className="shop-eyebrow">PRAKRATI MAITRI</p>

        <h1>Our Collection</h1>

        <p>
          Explore our complete collection of thoughtfully
          made bags, designed for everyday use, gifting,
          packaging and more.
        </p>
      </section>

      <section className="collections-layout">
        <aside className="collections-filters">
          <div className="collections-filter-header">
            <h2>Filter</h2>

            <button
              type="button"
              onClick={clearFilters}
            >
              Clear All
            </button>
          </div>

          <div className="collection-filter-group">
            <label htmlFor="collection-search">
              Search
            </label>

            <input
              id="collection-search"
              type="search"
              value={search}
              onChange={(event) =>
                setSearch(event.target.value)
              }
              placeholder="Search products..."
            />
          </div>

          <div className="collection-filter-group">
            <label htmlFor="collection-category">
              Category
            </label>

            <select
              id="collection-category"
              value={category}
              onChange={(event) =>
                handleCategoryChange(event.target.value)
              }
            >
              <option value="all">
                All Categories
              </option>

              {categories.map((item) => (
                <option
                  key={item.id}
                  value={item.id}
                >
                  {item.name}
                </option>
              ))}
            </select>
          </div>

          <div className="collection-filter-group">
            <label htmlFor="collection-subcategory">
              Subcategory
            </label>

            <select
              id="collection-subcategory"
              value={subcategory}
              onChange={(event) =>
                setSubcategory(event.target.value)
              }
              disabled={availableSubcategories.length === 0}
            >
              <option value="all">
                All Subcategories
              </option>

              {availableSubcategories.map((item) => (
                <option
                  key={item.id}
                  value={item.id}
                >
                  {item.name}
                </option>
              ))}
            </select>
          </div>

          <div className="collection-filter-group">
            <label>Price</label>

            <div className="collection-price-inputs">
              <input
                type="number"
                min="0"
                value={minPrice}
                onChange={(event) =>
                  setMinPrice(event.target.value)
                }
                placeholder="Min ₹"
              />

              <input
                type="number"
                min="0"
                value={maxPrice}
                onChange={(event) =>
                  setMaxPrice(event.target.value)
                }
                placeholder="Max ₹"
              />
            </div>
          </div>
        </aside>

        <div className="collections-results">
          <div className="collections-results-header">
            <div>
              <p className="section-eyebrow">
                ALL PRODUCTS
              </p>

              <h2>
                {filteredProducts.length}{" "}
                {filteredProducts.length === 1
                  ? "Product"
                  : "Products"}
              </h2>
            </div>

            <label className="collection-sort">
              <span>Sort by</span>

              <select
                value={sort}
                onChange={(event) =>
                  setSort(event.target.value)
                }
              >
                <option value="featured">
                  Featured
                </option>
                <option value="price-low">
                  Price: Low to High
                </option>
                <option value="price-high">
                  Price: High to Low
                </option>
                <option value="name">
                  Name: A to Z
                </option>
              </select>
            </label>
          </div>

          {filteredProducts.length > 0 ? (
            <div className="product-grid">
              {filteredProducts.map((product) => {
                const discount =
                  product.compareAtPrice !== null &&
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
                    <Link
                      href={`/products/${product.slug}`}
                      className="product-image-link"
                    >
                      <div className="product-image-wrapper">
                        {product.image ? (
                          <img
                            src={product.image.imageUrl}
                            alt={
                              product.image.altText ??
                              product.name
                            }
                            className="product-image"
                          />
                        ) : (
                          <div className="product-image-placeholder">
                            <span>Product Image</span>
                            <small>
                              Image will be added later
                            </small>
                          </div>
                        )}

                        {discount !== null && (
                          <span className="sale-badge">
                            {discount}% OFF
                          </span>
                        )}
                      </div>
                    </Link>

                    <div className="product-card-content">
                      <Link
                        href={`/products/${product.slug}`}
                        className="product-name"
                      >
                        {product.name}
                      </Link>

                      <div className="product-rating">
                        <span aria-hidden="true">
                          ★★★★★
                        </span>

                        <small>New</small>
                      </div>

                      <div className="product-price">
                        <strong>
                          ₹{product.price.toFixed(2)}
                        </strong>

                        {product.compareAtPrice !== null && (
                          <s>
                            ₹
                            {product.compareAtPrice.toFixed(
                              2
                            )}
                          </s>
                        )}
                      </div>

                      <p
                        className={`stock-status ${
                          product.availableQuantity > 0
                            ? "in-stock"
                            : "out-of-stock"
                        }`}
                      >
                        {product.availableQuantity > 0
                          ? `${product.availableQuantity} available`
                          : "Out of stock"}
                      </p>

                      <Link
                        href={`/products/${product.slug}`}
                        className="collection-view-product-button"
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
              <h2>No products found</h2>

              <p>
                Try changing your filters or search terms.
              </p>

              <button
                type="button"
                onClick={clearFilters}
                className="collection-view-product-button"
              >
                Clear Filters
              </button>
            </div>
          )}
        </div>
      </section>
    </main>
  );
}
