"use client";

import Image from "next/image";
import {
  useMemo,
  useState,
  type ChangeEvent,
} from "react";
import AddToCartButton from "@/components/cart/AddToCartButton";

type ProductImage = {
  id: string;
  image_url: string;
  alt_text: string | null;
  display_order: number;
};

type ProductData = {
  id: string;
  name: string;
  slug: string;
  description: string | null;
  price: number;
  compare_at_price: number | null;
  sku: string | null;
  categoryName: string;
  availableQuantity: number;
  images: ProductImage[];
};

type ProductConfiguratorProps = {
  product: ProductData;
};

type PurchaseMode = "standard" | "custom";

type PriceTier = {
  min: number;
  max: number | null;
  save: number;
  price: number;
};

const STANDARD_TIERS: PriceTier[] = [
  {
    min: 100,
    max: 499,
    save: 0,
    price: 13.6,
  },
  {
    min: 500,
    max: 999,
    save: 3.7,
    price: 13.1,
  },
  {
    min: 1000,
    max: 4999,
    save: 7.4,
    price: 12.6,
  },
  {
    min: 5000,
    max: 9999,
    save: 11.0,
    price: 12.1,
  },
  {
    min: 10000,
    max: 19999,
    save: 13.2,
    price: 11.8,
  },
  {
    min: 20000,
    max: null,
    save: 14.7,
    price: 11.6,
  },
];

const CUSTOM_TIERS: PriceTier[] = [
  {
    min: 100,
    max: 499,
    save: 0,
    price: 15.9,
  },
  {
    min: 500,
    max: 999,
    save: 5.0,
    price: 15.1,
  },
  {
    min: 1000,
    max: 4999,
    save: 9.4,
    price: 14.4,
  },
  {
    min: 5000,
    max: 9999,
    save: 13.2,
    price: 13.8,
  },
  {
    min: 10000,
    max: 19999,
    save: 15.7,
    price: 13.4,
  },
  {
    min: 20000,
    max: null,
    save: 18.9,
    price: 12.9,
  },
];

function formatQuantityRange(
  min: number,
  max: number | null
) {
  if (max === null) {
    return `${min.toLocaleString("en-IN")}+`;
  }

  return `${min.toLocaleString(
    "en-IN"
  )}-${max.toLocaleString("en-IN")}`;
}

export default function ProductConfigurator({
  product,
}: ProductConfiguratorProps) {
  const [selectedImage, setSelectedImage] =
    useState(0);

  const [purchaseMode, setPurchaseMode] =
    useState<PurchaseMode>("standard");

  // =====================================================
  // QUANTITY
  // =====================================================

  // IMPORTANT:
  // No artificial minimum of 100.
  const [quantity, setQuantity] = useState(1);

  // =====================================================
  // CUSTOMIZATION
  // =====================================================

  const [customNote, setCustomNote] =
    useState("");

  const [customFile, setCustomFile] =
    useState<File | null>(null);

  // =====================================================
  // PRICING
  // =====================================================

  const tiers =
    purchaseMode === "custom"
      ? CUSTOM_TIERS
      : STANDARD_TIERS;

  /*
   * Bulk pricing starts at 100 according to the
   * existing pricing tables.
   *
   * For 1-99 units we use the product's normal
   * database price because there is no defined
   * bulk-tier price for that range.
   */
  const activeTier = useMemo(() => {
    return (
      tiers.find((tier) => {
        if (quantity < tier.min) {
          return false;
        }

        if (tier.max === null) {
          return true;
        }

        return quantity <= tier.max;
      }) ?? null
    );
  }, [quantity, tiers]);

  const unitPrice =
    activeTier?.price ?? product.price;

  const total = quantity * unitPrice;

  const selectedProductImage =
    product.images[selectedImage];

  // =====================================================
  // QUANTITY CONTROLS
  // =====================================================

  const increaseQuantity = () => {
    setQuantity((current) => current + 1);
  };

  const decreaseQuantity = () => {
    setQuantity((current) =>
      Math.max(1, current - 1)
    );
  };

  const handleQuantityChange = (
    event: ChangeEvent<HTMLInputElement>
  ) => {
    const rawValue = event.target.value;

    if (rawValue === "") {
      setQuantity(1);
      return;
    }

    const value = Number(rawValue);

    if (!Number.isFinite(value)) {
      return;
    }

    setQuantity(
      Math.max(1, Math.floor(value))
    );
  };

  // =====================================================
  // CUSTOM FILE
  // =====================================================

  const handleCustomFileChange = (
    event: ChangeEvent<HTMLInputElement>
  ) => {
    const file =
      event.target.files?.[0] ?? null;

    setCustomFile(file);
  };

  // =====================================================
  // PURCHASE MODE
  // =====================================================

  const handleStandardMode = () => {
    setPurchaseMode("standard");
    setCustomFile(null);
    setCustomNote("");
  };

  const handleCustomMode = () => {
    setPurchaseMode("custom");
  };

  // =====================================================
  // ADD TO CART VALIDATION
  // =====================================================

  const customConfigurationValid =
    purchaseMode === "standard" ||
    customFile !== null ||
    customNote.trim().length > 0;

  const quantityAvailable =
    quantity <= product.availableQuantity;

  // =====================================================
  // RENDER
  // =====================================================

  return (
    <div className="grid gap-10 lg:grid-cols-2 lg:gap-16">
      {/* ================================================= */}
      {/* PRODUCT GALLERY */}
      {/* ================================================= */}

      <section>
        <div className="overflow-hidden rounded-3xl border border-[#D2B48C]/40 bg-white">
          {selectedProductImage ? (
            <div className="relative aspect-square w-full">
              <Image
                src={
                  selectedProductImage.image_url
                }
                alt={
                  selectedProductImage.alt_text ||
                  product.name
                }
                width={800}
                height={800}
                priority
                className="h-full w-full object-cover"
                sizes="(max-width: 1024px) 100vw, 50vw"
              />
            </div>
          ) : (
            <div className="flex aspect-square items-center justify-center bg-[#F1EDE3]">
              <p className="text-sm text-[#3D3D3D]/60">
                Product image coming soon
              </p>
            </div>
          )}
        </div>

        {/* Image thumbnails */}

        {product.images.length > 0 && (
          <div className="mt-4 grid grid-cols-3 gap-3">
            {product.images
              .slice(0, 3)
              .map((image, index) => (
                <button
                  key={image.id}
                  type="button"
                  onClick={() =>
                    setSelectedImage(index)
                  }
                  aria-label={`View product image ${
                    index + 1
                  }`}
                  className={`relative aspect-square overflow-hidden rounded-2xl border-2 bg-white transition ${
                    selectedImage === index
                      ? "border-[#4A5D23]"
                      : "border-transparent hover:border-[#D2B48C]"
                  }`}
                >
                  <Image
                    src={image.image_url}
                    alt={
                      image.alt_text ||
                      `${product.name} view ${
                        index + 1
                      }`
                    }
                    width={150}
                    height={150}
                    className="h-full w-full object-cover"
                    sizes="150px"
                  />
                </button>
              ))}
          </div>
        )}

        {product.images.length > 3 && (
          <p className="mt-3 text-xs text-[#3D3D3D]/50">
            Showing the first 3 product views.
          </p>
        )}
      </section>

      {/* ================================================= */}
      {/* PRODUCT INFORMATION */}
      {/* ================================================= */}

      <section className="flex flex-col">
        {/* Category */}

        {product.categoryName && (
          <p className="mb-3 text-sm font-semibold uppercase tracking-[0.2em] text-[#4A5D23]">
            {product.categoryName}
          </p>
        )}

        {/* Product name */}

        <h1 className="font-serif text-4xl leading-tight text-[#4A5D23] sm:text-5xl">
          {product.name}
        </h1>

        {/* Description */}

        {product.description && (
          <p className="mt-5 max-w-2xl text-base leading-7 text-[#3D3D3D]/75">
            {product.description}
          </p>
        )}

        {/* SKU */}

        {product.sku && (
          <p className="mt-4 text-sm text-[#3D3D3D]/60">
            SKU: {product.sku}
          </p>
        )}

        {/* Stock */}

        <div className="mt-4">
          {product.availableQuantity > 0 ? (
            <span className="inline-flex rounded-full bg-[#E8F5E9] px-4 py-2 text-sm font-medium text-[#4A5D23]">
              ✓{" "}
              {product.availableQuantity.toLocaleString(
                "en-IN"
              )}{" "}
              available
            </span>
          ) : (
            <span className="inline-flex rounded-full bg-red-50 px-4 py-2 text-sm font-medium text-red-700">
              Out of stock
            </span>
          )}
        </div>

        {/* ================================================= */}
        {/* PURCHASE MODE */}
        {/* ================================================= */}

        <div className="mt-8">
          <p className="mb-3 text-sm font-semibold uppercase tracking-wider text-[#3D3D3D]">
            Choose your bag
          </p>

          <div className="grid grid-cols-2 gap-3">
            {/* STANDARD */}

            <button
              type="button"
              onClick={handleStandardMode}
              className={`rounded-2xl border px-5 py-4 text-left transition ${
                purchaseMode === "standard"
                  ? "border-[#4A5D23] bg-[#4A5D23] text-white"
                  : "border-[#D2B48C] bg-white hover:border-[#4A5D23]"
              }`}
            >
              <span className="block font-semibold">
                Standard Bag
              </span>

              <span
                className={`mt-1 block text-xs ${
                  purchaseMode === "standard"
                    ? "text-white/80"
                    : "text-[#3D3D3D]/60"
                }`}
              >
                No customization
              </span>
            </button>

            {/* CUSTOM */}

            <button
              type="button"
              onClick={handleCustomMode}
              className={`rounded-2xl border px-5 py-4 text-left transition ${
                purchaseMode === "custom"
                  ? "border-[#8B4513] bg-[#8B4513] text-white"
                  : "border-[#D2B48C] bg-white hover:border-[#8B4513]"
              }`}
            >
              <span className="block font-semibold">
                Custom Bag
              </span>

              <span
                className={`mt-1 block text-xs ${
                  purchaseMode === "custom"
                    ? "text-white/80"
                    : "text-[#3D3D3D]/60"
                }`}
              >
                Add your design
              </span>
            </button>
          </div>
        </div>

        {/* ================================================= */}
        {/* QUANTITY */}
        {/* ================================================= */}

        <div className="mt-8">
          <div className="flex items-center justify-between gap-4">
            <p className="text-sm font-semibold uppercase tracking-wider">
              Quantity
            </p>

            <span className="text-xs text-[#3D3D3D]/60">
              Buy as many as you need
            </span>
          </div>

          <div className="mt-3 flex max-w-xs items-center overflow-hidden rounded-2xl border border-[#D2B48C] bg-white">
            <button
              type="button"
              onClick={decreaseQuantity}
              disabled={quantity <= 1}
              className="h-14 w-14 text-xl transition hover:bg-[#F1EDE3] disabled:cursor-not-allowed disabled:opacity-30"
              aria-label="Decrease quantity"
            >
              −
            </button>

            <input
              type="number"
              min={1}
              step={1}
              value={quantity}
              onChange={handleQuantityChange}
              className="h-14 min-w-0 flex-1 border-x border-[#D2B48C] bg-transparent text-center font-semibold outline-none"
              aria-label="Quantity"
            />

            <button
              type="button"
              onClick={increaseQuantity}
              className="h-14 w-14 text-xl transition hover:bg-[#F1EDE3]"
              aria-label="Increase quantity"
            >
              +
            </button>
          </div>
        </div>

        {/* ================================================= */}
        {/* CURRENT PRICE */}
        {/* ================================================= */}

        <div className="mt-8 rounded-3xl border border-[#D2B48C]/60 bg-white p-6">
          <div className="flex flex-wrap items-end justify-between gap-4">
            <div>
              <p className="text-sm text-[#3D3D3D]/60">
                {activeTier
                  ? "Your price"
                  : "Product price"}
              </p>

              <p className="mt-1 font-serif text-4xl text-[#4A5D23]">
                ₹{unitPrice.toFixed(2)}

                <span className="ml-2 font-sans text-sm text-[#3D3D3D]/60">
                  / bag
                </span>
              </p>
            </div>

            {activeTier &&
              activeTier.save > 0 && (
                <span className="rounded-full bg-[#E8F5E9] px-4 py-2 text-sm font-semibold text-[#4A5D23]">
                  Save {activeTier.save}%
                </span>
              )}
          </div>

          <div className="mt-5 border-t border-[#D2B48C]/40 pt-5">
            <p className="text-sm text-[#3D3D3D]/60">
              Estimated total
            </p>

            <p className="mt-1 text-2xl font-bold text-[#3D3D3D]">
              ₹
              {total.toLocaleString(
                "en-IN",
                {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2,
                }
              )}
            </p>
          </div>

          {!activeTier && (
            <p className="mt-3 text-xs text-[#3D3D3D]/50">
              Bulk pricing starts at 100 bags.
            </p>
          )}
        </div>

        {/* ================================================= */}
        {/* BULK PRICING */}
        {/* ================================================= */}

        <div className="mt-8">
          <h2 className="font-serif text-2xl text-[#4A5D23]">
            Bulk Pricing
          </h2>

          <div className="mt-4 overflow-hidden rounded-2xl border border-[#D2B48C]/60 bg-white">
            <div className="grid grid-cols-3 bg-[#F1EDE3] px-4 py-3 text-xs font-semibold uppercase tracking-wide">
              <span>Quantity</span>
              <span>Save</span>
              <span className="text-right">
                Price / Bag
              </span>
            </div>

            {tiers.map((tier) => {
              const isActive =
                quantity >= tier.min &&
                (tier.max === null ||
                  quantity <= tier.max);

              return (
                <div
                  key={`${purchaseMode}-${tier.min}`}
                  className={`grid grid-cols-3 items-center border-t border-[#D2B48C]/30 px-4 py-3 text-sm transition ${
                    isActive
                      ? "bg-[#E8F5E9] font-semibold"
                      : ""
                  }`}
                >
                  <span>
                    {formatQuantityRange(
                      tier.min,
                      tier.max
                    )}
                  </span>

                  <span>
                    {tier.save > 0
                      ? `${tier.save}%`
                      : "—"}
                  </span>

                  <span className="text-right">
                    ₹{tier.price.toFixed(2)}
                  </span>
                </div>
              );
            })}
          </div>
        </div>

        {/* ================================================= */}
        {/* CUSTOMIZATION */}
        {/* ================================================= */}

        {purchaseMode === "custom" && (
          <div className="mt-8 rounded-3xl border border-[#D2B48C] bg-white p-6">
            <div>
              <h2 className="font-serif text-2xl text-[#4A5D23]">
                Customize Your Bag
              </h2>

              <p className="mt-2 text-sm leading-6 text-[#3D3D3D]/65">
                Upload your design and add any
                instructions you want us to know
                about.
              </p>
            </div>

            {/* Upload */}

            <div className="mt-6">
              <label
                htmlFor="custom-design"
                className="block text-sm font-semibold"
              >
                Upload your design
              </label>

              <input
                id="custom-design"
                type="file"
                accept="image/png,image/jpeg,image/webp,application/pdf"
                onChange={
                  handleCustomFileChange
                }
                className="mt-3 block w-full rounded-xl border border-[#D2B48C] bg-[#F9F7F2] p-3 text-sm"
              />

              {customFile && (
                <p className="mt-2 text-xs text-[#4A5D23]">
                  Selected:{" "}
                  {customFile.name}
                </p>
              )}
            </div>

            {/* Note */}

            <div className="mt-6">
              <label
                htmlFor="custom-note"
                className="block text-sm font-semibold"
              >
                Customization instructions
              </label>

              <textarea
                id="custom-note"
                value={customNote}
                onChange={(event) =>
                  setCustomNote(
                    event.target.value
                  )
                }
                rows={5}
                placeholder="Tell us what you want on the bag..."
                className="mt-3 w-full resize-none rounded-xl border border-[#D2B48C] bg-[#F9F7F2] p-4 text-sm outline-none transition focus:border-[#4A5D23] focus:ring-1 focus:ring-[#4A5D23]"
              />
            </div>

            <p className="mt-4 text-xs text-[#3D3D3D]/50">
              Final artwork and customization
              details can be confirmed before
              production.
            </p>
          </div>
        )}

        {/* ================================================= */}
        {/* ADD TO CART */}
        {/* ================================================= */}

        <div className="mt-8">
          {product.availableQuantity <= 0 ? (
            <button
              type="button"
              disabled
              className="w-full cursor-not-allowed rounded-2xl bg-[#3D3D3D]/20 px-6 py-4 font-semibold text-[#3D3D3D]/50"
            >
              Out of Stock
            </button>
          ) : !quantityAvailable ? (
            <div>
              <p className="mb-3 rounded-xl bg-red-50 p-3 text-sm text-red-700">
                Requested quantity exceeds
                current available inventory.
              </p>

              <button
                type="button"
                disabled
                className="w-full cursor-not-allowed rounded-2xl bg-[#3D3D3D]/20 px-6 py-4 font-semibold text-[#3D3D3D]/50"
              >
                Quantity Unavailable
              </button>
            </div>
          ) : purchaseMode === "custom" &&
            !customConfigurationValid ? (
            <button
              type="button"
              disabled
              className="w-full cursor-not-allowed rounded-2xl bg-[#3D3D3D]/20 px-6 py-4 font-semibold text-[#3D3D3D]/50"
            >
              Add a Design or Instructions
            </button>
          ) : (
            <AddToCartButton
              productId={product.id}
              name={product.name}
              slug={product.slug}
              price={unitPrice}
              imageUrl={
                product.images[0]?.image_url ??
                null
              }
              quantity={quantity}
              customization={{
                type: purchaseMode,
                imageUrl: null,
                note: customNote.trim(),
              }}
            />
          )}
        </div>

        {/* Existing product price information */}

        {product.compare_at_price &&
          product.compare_at_price >
            product.price && (
            <p className="mt-4 text-center text-xs text-[#3D3D3D]/45">
              Standard product reference price:{" "}
              <s>
                ₹
                {product.compare_at_price.toFixed(
                  2
                )}
              </s>
            </p>
          )}
      </section>
    </div>
  );
}