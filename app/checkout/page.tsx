"use client";

import { FormEvent, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useCart } from "@/components/cart/CartProvider";

type CheckoutForm = {
  firstName: string;
  lastName: string;
  phone: string;
  address: string;
  city: string;
  state: string;
  country: string;
  postalCode: string;
};

export default function CheckoutPage() {
  const router = useRouter();

  const { items, subtotal } = useCart();

  const [form, setForm] = useState<CheckoutForm>({
    firstName: "",
    lastName: "",
    phone: "",
    address: "",
    city: "",
    state: "",
    country: "India",
    postalCode: "",
  });

  const [error, setError] = useState("");

  function updateField(
    field: keyof CheckoutForm,
    value: string
  ) {
    setForm((current) => ({
      ...current,
      [field]: value,
    }));
  }

 function handleSubmit(event: FormEvent<HTMLFormElement>) {
  event.preventDefault();

  setError("");

  if (items.length === 0) {
    setError("Your cart is empty.");
    return;
  }

  if (form.phone.trim().length < 10) {
    setError("Please enter a valid phone number.");
    return;
  }

  if (form.postalCode.trim().length < 4) {
    setError("Please enter a valid postal code.");
    return;
  }

  sessionStorage.setItem(
    "prakratri-matri-checkout",
    JSON.stringify(form)
  );

  router.push("/checkout/review");
}

  if (items.length === 0) {
    return (
      <main>
        <h1>Checkout</h1>

        <p>Your cart is empty.</p>

        <Link href="/shop">
          Continue Shopping
        </Link>
      </main>
    );
  }

  return (
    <main>
      <h1>Checkout</h1>

      <form onSubmit={handleSubmit}>
        <section>
          <h2>Delivery Information</h2>

          <div>
            <label htmlFor="firstName">
              First name
            </label>

            <input
              id="firstName"
              name="firstName"
              type="text"
              value={form.firstName}
              onChange={(event) =>
                updateField("firstName", event.target.value)
              }
              required
              autoComplete="given-name"
            />
          </div>

          <div>
            <label htmlFor="lastName">
              Last name
            </label>

            <input
              id="lastName"
              name="lastName"
              type="text"
              value={form.lastName}
              onChange={(event) =>
                updateField("lastName", event.target.value)
              }
              required
              autoComplete="family-name"
            />
          </div>

          <div>
            <label htmlFor="phone">
              Phone
            </label>

            <input
              id="phone"
              name="phone"
              type="tel"
              value={form.phone}
              onChange={(event) =>
                updateField("phone", event.target.value)
              }
              required
              autoComplete="tel"
            />
          </div>

          <div>
            <label htmlFor="address">
              Address
            </label>

            <textarea
              id="address"
              name="address"
              value={form.address}
              onChange={(event) =>
                updateField("address", event.target.value)
              }
              required
              autoComplete="street-address"
            />
          </div>

          <div>
            <label htmlFor="city">
              City
            </label>

            <input
              id="city"
              name="city"
              type="text"
              value={form.city}
              onChange={(event) =>
                updateField("city", event.target.value)
              }
              required
              autoComplete="address-level2"
            />
          </div>

          <div>
            <label htmlFor="state">
              State
            </label>

            <input
              id="state"
              name="state"
              type="text"
              value={form.state}
              onChange={(event) =>
                updateField("state", event.target.value)
              }
              required
              autoComplete="address-level1"
            />
          </div>

          <div>
            <label htmlFor="country">
              Country
            </label>

            <input
              id="country"
              name="country"
              type="text"
              value={form.country}
              onChange={(event) =>
                updateField("country", event.target.value)
              }
              required
              autoComplete="country-name"
            />
          </div>

          <div>
            <label htmlFor="postalCode">
              Postal code
            </label>

            <input
              id="postalCode"
              name="postalCode"
              type="text"
              value={form.postalCode}
              onChange={(event) =>
                updateField("postalCode", event.target.value)
              }
              required
              autoComplete="postal-code"
            />
          </div>
        </section>

        {error && (
          <p role="alert">
            {error}
          </p>
        )}

        <section>
          <h2>Order Summary</h2>

          {items.map((item) => (
            <div key={item.productId}>
              <span>
                {item.name} × {item.quantity}
              </span>

              <span>
                ₹{(item.price * item.quantity).toFixed(2)}
              </span>
            </div>
          ))}

          <p>
            Subtotal: ₹{subtotal.toFixed(2)}
          </p>

          <p>
            Shipping: Calculated later
          </p>

          <strong>
            Current total: ₹{subtotal.toFixed(2)}
          </strong>
        </section>

        <button type="submit">
          Continue to Review
        </button>
      </form>

      <p>
        <Link href="/cart">
          ← Back to Cart
        </Link>
      </p>
    </main>
  );
}