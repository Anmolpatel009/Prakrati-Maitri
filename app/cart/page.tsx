"use client";

import Link from "next/link";
import { useCart } from "@/components/cart/CartProvider";

export default function CartPage() {
  const {
    items,
    removeItem,
    updateQuantity,
    subtotal,
  } = useCart();

  if (items.length === 0) {
    return (
      <main>
        <h1>Your Cart</h1>

        <p>Your cart is currently empty.</p>

        <Link href="/shop">
          Continue Shopping
        </Link>
      </main>
    );
  }

  return (
    <main>
      <h1>Your Cart</h1>

      {items.map((item) => (
        <article key={item.productId}>
          {item.imageUrl && (
            <img
              src={item.imageUrl}
              alt={item.name}
              width={150}
              height={150}
            />
          )}

          <div>
            <h2>{item.name}</h2>

            <p>
              ₹{item.price}
            </p>

            <div>
              <button
                type="button"
                onClick={() =>
                  updateQuantity(
                    item.productId,
                    item.quantity - 1
                  )
                }
              >
                -
              </button>

              <span>
                {item.quantity}
              </span>

              <button
                type="button"
                onClick={() =>
                  updateQuantity(
                    item.productId,
                    item.quantity + 1
                  )
                }
              >
                +
              </button>
            </div>

            <p>
              Item total: ₹
              {(item.price * item.quantity).toFixed(2)}
            </p>

            <button
              type="button"
              onClick={() =>
                removeItem(item.productId)
              }
            >
              Remove
            </button>
          </div>
        </article>
      ))}

      <hr />

      <section>
        <h2>Order Summary</h2>

        <p>
          Subtotal: ₹{subtotal.toFixed(2)}
        </p>

        <Link href="/checkout">
          Proceed to Checkout
        </Link>
      </section>
    </main>
  );
}