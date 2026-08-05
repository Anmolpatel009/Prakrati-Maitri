import Link from "next/link";
import { notFound } from "next/navigation";
import { createClient } from "@/lib/supabase/server";

type OrderDetailsPageProps = {
  params: Promise<{
    id: string;
  }>;
};

export default async function OrderDetailsPage({
  params,
}: OrderDetailsPageProps) {
  const { id } = await params;

  const supabase = await createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return (
      <main>
        <h1>Order Details</h1>

        <p>
          You must be logged in to view this order.
        </p>

        <Link href="/login">
          Login
        </Link>
      </main>
    );
  }

  const { data: order, error } = await supabase
    .from("orders")
    .select(`
      id,
      user_id,
      status,
      subtotal,
      shipping_fee,
      total,
      shipping_first_name,
      shipping_last_name,
      shipping_phone,
      shipping_address,
      shipping_city,
      shipping_state,
      shipping_country,
      shipping_postal_code,
      created_at,
      updated_at,
      order_items (
        id,
        product_id,
        product_name,
        product_sku,
        quantity,
        unit_price,
        line_total,
        created_at
      )
    `)
    .eq("id", id)
    .eq("user_id", user.id)
    .single();

  if (error || !order) {
    notFound();
  }

  return (
    <main>
      <h1>Order Details</h1>

      <section>
        <h2>
          Order #{order.id.slice(0, 8)}
        </h2>

        <p>
          Order ID: {order.id}
        </p>

        <p>
          Date:{" "}
          {new Date(order.created_at).toLocaleString(
            "en-IN"
          )}
        </p>

        <p>
          Status: {order.status}
        </p>
      </section>

      <section>
        <h2>Items</h2>

        {order.order_items.map((item) => (
          <article key={item.id}>
            <h3>{item.product_name}</h3>

            {item.product_sku && (
              <p>
                SKU: {item.product_sku}
              </p>
            )}

            <p>
              ₹{Number(item.unit_price).toFixed(2)} ×{" "}
              {item.quantity}
            </p>

            <p>
              Line total: ₹
              {Number(item.line_total).toFixed(2)}
            </p>
          </article>
        ))}
      </section>

      <section>
        <h2>Delivery Information</h2>

        <p>
          <strong>
            {order.shipping_first_name}{" "}
            {order.shipping_last_name}
          </strong>
        </p>

        <p>
          Phone: {order.shipping_phone}
        </p>

        <p>
          {order.shipping_address}
          <br />
          {order.shipping_city},{" "}
          {order.shipping_state}
          <br />
          {order.shipping_country} -{" "}
          {order.shipping_postal_code}
        </p>
      </section>

      <section>
        <h2>Order Summary</h2>

        <p>
          Subtotal: ₹
          {Number(order.subtotal).toFixed(2)}
        </p>

        <p>
          Shipping: ₹
          {Number(order.shipping_fee).toFixed(2)}
        </p>

        <p>
          <strong>
            Total: ₹{Number(order.total).toFixed(2)}
          </strong>
        </p>
      </section>

      <p>
        <Link href="/account/orders">
          ← Back to My Orders
        </Link>
      </p>

      <p>
        <Link href="/shop">
          Continue Shopping
        </Link>
      </p>
    </main>
  );
}