"use client";

import { useCart } from "./CartProvider";

export default function CartBadge() {
  const { totalItems } = useCart();

  return (
    <span
      className="absolute -right-2 -top-2 flex min-h-5 min-w-5 items-center justify-center rounded-full bg-[#4A5D23] px-1.5 text-[10px] font-bold text-white"
      aria-label={`${totalItems} items in cart`}
    >
      {totalItems > 99 ? "99+" : totalItems}
    </span>
  );
}