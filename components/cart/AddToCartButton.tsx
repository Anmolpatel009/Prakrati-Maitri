"use client";

import { useCart } from "./CartProvider";

type AddToCartButtonProps = {
  productId: string;
  name: string;
  slug: string;
  price: number;
  imageUrl: string | null;
  disabled?: boolean;
};

export default function AddToCartButton({
  productId,
  name,
  slug,
  price,
  imageUrl,
  disabled = false,
}: AddToCartButtonProps) {
  const { addItem } = useCart();

  function handleAddToCart() {
    addItem({
      productId,
      name,
      slug,
      price,
      imageUrl,
    });
  }

  return (
    <button
      type="button"
      onClick={handleAddToCart}
      disabled={disabled}
    >
      Add to Cart
    </button>
  );
}