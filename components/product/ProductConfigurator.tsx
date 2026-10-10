"use client";

import Link from "next/link";
import Image from "next/image";
import {
  useEffect,
  useRef,
  useState,
  type ChangeEvent,
  type ComponentProps,
} from "react";
import AddToCartButton from "@/components/cart/AddToCartButton";
import { trackMetaEvent } from "@/components/analytics/MetaPixel";
import SharedProductCard, {
  type SharedProductCardProduct,
} from "@/components/shop/ProductCard";

type ProductImage = {
  id: string;
  image_url: string;
  alt_text: string | null;
  display_order: number | null;
};

type ProductData = {
  id: string;
  name: string;
  slug: string;
  short_description: string | null;
  description: string | null;
  price: number;
  compare_at_price: number | null;
  sku: string | null;
  categoryName: string;
  availableQuantity: number;
  minimum_order_quantity: number;
  images: ProductImage[];
};

type ProductCardConfig =
  ComponentProps<
    typeof SharedProductCard
  >["config"];

type ProductConfiguratorProps = {
  product: ProductData;
  suggestedProducts: SharedProductCardProduct[];
  suggestedProductCardConfig: ProductCardConfig;
};

type PurchaseMode = "standard" | "custom";

function Icon({
  name,
  filled = false,
}: {
  name:
    | "manufacturer"
    | "shipping"
    | "invoice"
    | "leaf"
    | "reusable"
    | "fabric"
    | "care"
    | "safe"
    | "heart"
    | "upload";
  filled?: boolean;
}) {
  const common = {
    className: "pdp-icon",
    viewBox: "0 0 24 24",
    fill: "none",
    stroke: "currentColor",
    strokeWidth: 1.6,
    strokeLinecap: "round" as const,
    strokeLinejoin: "round" as const,
    "aria-hidden": true,
  };

  switch (name) {
    case "manufacturer":
      return (
        <svg {...common}>
          <path d="M3 21h18" />
          <path d="M5 21V9l5 3V9l5 3V5h4v16" />
          <path d="M8 17h2M13 17h2" />
        </svg>
      );

    case "shipping":
      return (
        <svg {...common}>
          <path d="M3 6h11v10H3z" />
          <path d="M14 9h4l3 3v4h-7" />
          <circle cx="7" cy="17.5" r="1.8" />
          <circle cx="17" cy="17.5" r="1.8" />
        </svg>
      );

    case "invoice":
      return (
        <svg {...common}>
          <path d="M6 3h9l3 3v15H6z" />
          <path d="M9 9h6M9 13h6M9 17h3" />
        </svg>
      );

    case "leaf":
      return (
        <svg {...common}>
          <path d="M5 19c0-8 6-14 14-14-1 8-6 14-14 14Z" />
          <path d="M5 19 13 11" />
        </svg>
      );

    case "reusable":
      return (
        <svg {...common}>
          <path d="M4 12a8 8 0 0 1 14-5l2-2v6h-6l2-2a5 5 0 1 0 1 6" />
        </svg>
      );

    case "fabric":
      return (
        <svg {...common}>
          <path d="M4 8c3-2 5 2 8 0s5-2 8 0" />
          <path d="M4 13c3-2 5 2 8 0s5-2 8 0" />
          <path d="M4 18c3-2 5 2 8 0s5-2 8 0" />
        </svg>
      );

    case "care":
      return (
        <svg {...common}>
          <path d="M3 8h18l-2 11H5Z" />
          <path d="M7 12c2 1 3-1 5 0s3 1 5 0" />
        </svg>
      );

    case "safe":
      return (
        <svg {...common}>
          <path d="M12 3 5 6v6c0 4 3 7 7 9 4-2 7-5 7-9V6Z" />
          <path d="m9 12 2 2 4-4" />
        </svg>
      );

    case "heart":
      return (
        <svg {...common}>
          <path
            d="M12 20s-7-4.4-7-10a4 4 0 0 1 7-2.6A4 4 0 0 1 19 10c0 5.6-7 10-7 10Z"
            fill={filled ? "currentColor" : "none"}
          />
        </svg>
      );

    case "upload":
      return (
        <svg {...common}>
          <path d="M12 16V4" />
          <path d="m7 9 5-5 5 5" />
          <path d="M4 16v3a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1v-3" />
        </svg>
      );

    default:
      return null;
  }
}

export default function ProductConfigurator({
  product,
  suggestedProducts,
  suggestedProductCardConfig,
}: ProductConfiguratorProps) {
  useEffect(() => {
    trackMetaEvent("ViewContent", {
      content_type: "product",
      content_ids: [product.id],
      content_name: product.name,
      value: product.price,
      currency: "INR",
    });
  }, [product.id, product.name, product.price]);

  const customizationRef =
    useRef<HTMLDivElement | null>(null);

  const [selectedImage, setSelectedImage] =
    useState(0);

  const [purchaseMode, setPurchaseMode] =
    useState<PurchaseMode>("standard");

  const [quantity, setQuantity] = useState(
    Math.max(
      1,
      product.minimum_order_quantity ?? 1,
    ),
  );

  const [customNote, setCustomNote] =
    useState("");

  const [customFile, setCustomFile] =
    useState<File | null>(null);

  const [wishlist, setWishlist] =
    useState(false);

  const [descriptionExpanded, setDescriptionExpanded] =
    useState(false);

  const minimumOrderQuantity = Math.max(
    1,
    product.minimum_order_quantity ?? 1,
  );

  const selectedProductImage =
    product.images[selectedImage] ??
    product.images[0];

  const quantityAvailable =
    quantity <= product.availableQuantity;

  const customConfigurationValid =
    purchaseMode === "standard" ||
    customFile !== null ||
    customNote.trim().length > 0;

  const increaseQuantity = () => {
    setQuantity((current) => current + 1);
  };

  const decreaseQuantity = () => {
    setQuantity((current) =>
      Math.max(
        minimumOrderQuantity,
        current - 1,
      ),
    );
  };

  const handleQuantityChange = (
    event: ChangeEvent<HTMLInputElement>,
  ) => {
    const value = Number(
      event.target.value,
    );

    if (!Number.isFinite(value)) {
      return;
    }

    setQuantity(
      Math.max(
        minimumOrderQuantity,
        Math.floor(value),
      ),
    );
  };

  const handleCustomMode = () => {
    setPurchaseMode("custom");

    requestAnimationFrame(() => {
      customizationRef.current?.scrollIntoView({
        behavior: "smooth",
        block: "start",
      });
    });
  };

  const handleStandardMode = () => {
    setPurchaseMode("standard");
    setCustomFile(null);
    setCustomNote("");
  };

  const renderCartAction = () => {
    if (product.availableQuantity <= 0) {
      return (
        <button
          type="button"
          disabled
          className="pdp-cart-disabled"
        >
          Out of Stock
        </button>
      );
    }

    if (!quantityAvailable) {
      return (
        <button
          type="button"
          disabled
          className="pdp-cart-disabled"
        >
          Quantity Unavailable
        </button>
      );
    }

    if (
      purchaseMode === "custom" &&
      !customConfigurationValid
    ) {
      return (
        <button
          type="button"
          disabled
          className="pdp-cart-disabled"
        >
          Add a Design or Instructions
        </button>
      );
    }

    return (
      <AddToCartButton
        productId={product.id}
        name={product.name}
        slug={product.slug}
        price={product.price}
        imageUrl={
          product.images[0]?.image_url ?? null
        }
        minimumOrderQuantity={
          minimumOrderQuantity
        }
        quantity={quantity}
        customization={{
          type: purchaseMode,
          imageUrl: null,
          note: customNote.trim(),
        }}
      />
    );
  };

  const featureItems = [
    {
      icon: "leaf" as const,
      title: "100% natural cotton",
      text: "Soft, safe and thoughtfully made",
    },
    {
      icon: "reusable" as const,
      title: "Reusable and durable",
      text: "Built to be used again and again",
    },
    {
      icon: "fabric" as const,
      title: "Breathable fabric",
      text: "Comfortable and practical for everyday use",
    },
    {
      icon: "care" as const,
      title: "Washable, easy care",
      text: "Simple maintenance for regular use",
    },
    {
      icon: "safe" as const,
      title: "Safe and dependable",
      text: "Designed with everyday use in mind",
    },
    {
      icon: "leaf" as const,
      title: "Eco-conscious choice",
      text: "A thoughtful alternative to disposable packaging",
    },
  ];

  const fullDescription =
    product.description?.trim() ||
    product.short_description?.trim() ||
    "Thoughtfully designed products made for practical everyday use, gifting, packaging and business needs.";

  return (
    <>
      <section className="pdp-hero">
        <div className="pdp-container pdp-layout">
          <section className="pdp-gallery">
            <div className="pdp-main-image">
              {selectedProductImage ? (
                <Image
                  src={selectedProductImage.image_url}
                  alt={
                    selectedProductImage.alt_text ||
                    product.name
                  }
                  width={1000}
                  height={1000}
                  priority
                  className="pdp-main-product-image"
                />
              ) : (
                <div className="pdp-image-empty">
                  Product Image
                </div>
              )}
            </div>

            {product.images.length > 0 && (
              <div
                className="pdp-thumbs"
                aria-label="Product images"
              >
                {product.images
                  .slice(0, 4)
                  .map((image, index) => (
                    <button
                      key={image.id}
                      type="button"
                      aria-current={
                        selectedImage === index
                      }
                      aria-label={`View product image ${index + 1}`}
                      onClick={() =>
                        setSelectedImage(index)
                      }
                    >
                      <Image
                        src={image.image_url}
                        alt={
                          image.alt_text ||
                          `${product.name} view ${index + 1}`
                        }
                        width={400}
                        height={400}
                        className="pdp-thumb-image"
                      />
                    </button>
                  ))}
              </div>
            )}
          </section>

          <section className="pdp-info">
            <p className="pdp-crumb">
              <Link href="/shop">Home</Link>
              <span>/</span>
              <Link href="/shop">
                {product.categoryName || "Shop"}
              </Link>
            </p>

            {product.categoryName && (
              <p className="pdp-category">
                {product.categoryName}
              </p>
            )}

            <h1 className="pdp-title">
              {product.name}
            </h1>

            <div
              className="pdp-rating"
              aria-label="Product rating"
            >
              <span className="pdp-stars">
                ★★★★<span>★</span>
              </span>
              <span>Customer favourite</span>
            </div>

            <p className="pdp-price">
              ₹{product.price.toFixed(2)}{" "}
              <span>/ piece</span>
            </p>

            {product.short_description && (
              <ul
                className="pdp-short-list"
                aria-label="Product highlights"
              >
                {product.short_description
                  .trim()
                  .replace(/\\s*[\\r\\n]+\\s*/g, " ")
                  .split(/\\s*(?:•|\\u2022)\\s*/)
                  .flatMap((part) =>
                    part
                      .split(
                        /\\s+-\\s+(?=[A-Za-z][A-Za-z0-9 &/()%,.+-]{0,32}:\\s)/
                      )
                  )
                  .map((item) => item.trim())
                  .filter(Boolean)
                  .map((item, index) => {
                    const separator = item.indexOf(":");
                    const hasLabel =
                      separator > 0 &&
                      separator <= 40;

                    const label = hasLabel
                      ? item.slice(0, separator).trim()
                      : "";

                    const value = hasLabel
                      ? item.slice(separator + 1).trim()
                      : item;

                    return (
                      <li key={`${index}-${item}`}>
                        <span
                          className="pdp-short-bullet"
                          aria-hidden="true"
                        />
                        <span>
                          {hasLabel ? (
                            <>
                              <strong>{label}:</strong>{" "}
                              {value}
                            </>
                          ) : (
                            value
                          )}
                        </span>
                      </li>
                    );
                  })}
              </ul>
            )}

            <p className="pdp-label">
              Print option
            </p>

            <div
              className="pdp-toggle"
              role="group"
              aria-label="Print option"
            >
              <button
                type="button"
                aria-pressed={
                  purchaseMode === "standard"
                }
                onClick={handleStandardMode}
              >
                Standard
              </button>

              <button
                type="button"
                aria-pressed={
                  purchaseMode === "custom"
                }
                onClick={handleCustomMode}
              >
                Custom logo
              </button>
            </div>

            {purchaseMode === "custom" && (
              <div
                ref={customizationRef}
                className="pdp-customization"
              >
                <p className="pdp-label">
                  Your logo
                </p>

                <label
                  className={`pdp-upload ${
                    customFile
                      ? "has-file"
                      : ""
                  }`}
                >
                  <span className="pdp-upload-icon">
                    <Icon name="upload" />
                  </span>

                  <strong>
                    {customFile
                      ? customFile.name
                      : "Upload logo or artwork"}
                  </strong>

                  <small>
                    JPG, PNG, PDF or CDR
                  </small>

                  <input
                    type="file"
                    accept=".jpg,.jpeg,.png,.pdf,.cdr"
                    onChange={(event) =>
                      setCustomFile(
                        event.target.files?.[0] ??
                          null,
                      )
                    }
                  />
                </label>

                <textarea
                  aria-label="Notes for printing"
                  placeholder="Notes for printing (colours, position, size)…"
                  value={customNote}
                  onChange={(event) =>
                    setCustomNote(
                      event.target.value,
                    )
                  }
                />
              </div>
            )}

            {purchaseMode === "standard" && (
              <p className="pdp-plain-note">
                Plain bags ship without printing.
                Switch to Custom logo to add your
                brand.
              </p>
            )}

            {product.sku && (
              <p className="pdp-sku">
                SKU: {product.sku}
              </p>
            )}

            <p className="pdp-label pdp-quantity-label">
              Quantity
            </p>

            <div className="pdp-buy">
              <div className="pdp-qty">
                <button
                  type="button"
                  onClick={decreaseQuantity}
                  disabled={
                    quantity <=
                    minimumOrderQuantity
                  }
                  aria-label="Decrease quantity"
                >
                  −
                </button>

                <input
                  type="number"
                  min={minimumOrderQuantity}
                  step={1}
                  value={quantity}
                  onChange={
                    handleQuantityChange
                  }
                  aria-label="Quantity"
                />

                <button
                  type="button"
                  onClick={increaseQuantity}
                  aria-label="Increase quantity"
                >
                  +
                </button>
              </div>

              <div className="pdp-cart-slot">
                {renderCartAction()}
              </div>

              <button
                type="button"
                className="pdp-wishlist"
                aria-pressed={wishlist}
                aria-label={
                  wishlist
                    ? "Remove from wishlist"
                    : "Add to wishlist"
                }
                onClick={() =>
                  setWishlist(
                    (current) => !current,
                  )
                }
              >
                <Icon
                  name="heart"
                  filled={wishlist}
                />
              </button>
            </div>

            <div className="pdp-trust">
              <div>
                <Icon name="manufacturer" />
                <span>Manufacturer</span>
              </div>

              <div>
                <Icon name="shipping" />
                <span>PAN India</span>
              </div>

              <div>
                <Icon name="invoice" />
                <span>GST invoice</span>
              </div>

              <div>
                <Icon name="leaf" />
                <span>Thoughtful materials</span>
              </div>
            </div>
          </section>
        </div>
      </section>

      <section className="pdp-details">
        <div className="pdp-container pdp-details-inner">
          <div className="pdp-details-copy">
            <h2>
              Simple by nature, sustainable by choice
            </h2>

            <div
              className={`pdp-description-box ${
                descriptionExpanded
                  ? "is-expanded"
                  : "is-collapsed"
              }`}
            >
              <p className="pdp-details-description">
                {fullDescription}
              </p>
            </div>

            <button
              type="button"
              className="pdp-description-toggle"
              aria-expanded={
                descriptionExpanded
              }
              onClick={() =>
                setDescriptionExpanded(
                  (current) => !current,
                )
              }
            >
              {descriptionExpanded
                ? "Hide"
                : "View more"}
            </button>

            <div className="pdp-feature-grid">
              {featureItems.map((item) => (
                <div
                  className="pdp-feature"
                  key={item.title}
                >
                  <span className="pdp-feature-icon">
                    <Icon name={item.icon} />
                  </span>

                  <div>
                    <strong>
                      {item.title}
                    </strong>
                    <span>
                      {item.text}
                    </span>
                  </div>
                </div>
              ))}
            </div>

            <p className="pdp-label pdp-perfect-label">
              Perfect for
            </p>

            <div className="pdp-uses">
              <span>Gift hampers</span>
              <span>Dry fruits</span>
              <span>Cosmetics</span>
              <span>Conference kits</span>
              <span>Return gifts</span>
              <span>Product packaging</span>
            </div>
          </div>

          <div className="pdp-faq">
            <h3 className="pdp-faq-title">
              Frequently asked questions
            </h3>
            <details>
              <summary>
                Bulk and corporate orders
              </summary>
              <p>
                For large quantities, custom sizes
                or branded packaging, use Bulk Orders
                and our team can help with your
                requirement.
              </p>
            </details>

            <details>
              <summary>Delivery</summary>
              <p>
                We deliver PAN India. Delivery timing
                depends on quantity, product and
                customization requirements.
              </p>
            </details>

            <details>
              <summary>GST invoice</summary>
              <p>
                Every order comes with a GST invoice
                for your business records.
              </p>
            </details>
            <details>
              <summary>How can I order products with my logo?</summary>
              <p>
                Select the Custom logo option on the product page and upload your logo while configuring the product.
                The available customization options depend on the product.
              </p>
            </details>
          </div>
        </div>
      </section>

      {suggestedProducts.length > 0 && (
        <section className="pdp-recommendations">
          <div className="pdp-container">
            <div className="pdp-recommendations-heading">
              <p className="pdp-label">
                More to explore
              </p>

              <h2>
                You may also like
              </h2>
            </div>

            <div className="pdp-recommendations-grid">
              {suggestedProducts.map(
                (suggestedProduct) => (
                  <SharedProductCard
                    key={suggestedProduct.id}
                    product={suggestedProduct}
                    config={
                      suggestedProductCardConfig
                    }
                  />
                ),
              )}
            </div>
          </div>
        </section>
      )}

      <div className="pdp-mobile-buy">
        <div>
          <strong>
            ₹{product.price.toFixed(2)}
          </strong>
          <span>/ pc</span>
        </div>

        <div className="pdp-mobile-cart">
          {renderCartAction()}
        </div>
      </div>
    </>
  );
}
