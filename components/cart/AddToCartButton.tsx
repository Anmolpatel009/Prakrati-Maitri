"use client";

import { useState } from "react";
import { useCart } from "./CartProvider";

type AddToCartButtonProps = {
  productId: string;
  name: string;
  slug: string;
  price: number;
  imageUrl: string | null;

  quantity?: number;

  customization?: {
    type: "standard" | "custom";
    imageUrl: string | null;
    note: string;
  } | null;
};

export default function AddToCartButton({
  productId,
  name,
  slug,
  price,
  imageUrl,
  quantity = 1,
  customization = null,
}: AddToCartButtonProps) {
  const { addItem } = useCart();

  const [added, setAdded] = useState(false);

  function handleAddToCart() {
    addItem(
      {
        productId,
        name,
        slug,
        price,
        imageUrl,
        customization,
      },
      quantity
    );

    setAdded(true);

    window.setTimeout(() => {
      setAdded(false);
    }, 1800);
  }

  return (
    <button
      type="button"
      onClick={handleAddToCart}
      className="w-full rounded-full bg-[#4A5D23] px-6 py-3.5 text-sm font-semibold text-white transition hover:-translate-y-0.5 hover:bg-[#3D4D1D] hover:shadow-lg active:translate-y-0"
    >
      {added ? "Added to Cart ✓" : "Add to Cart"}
    </button>
  );
}