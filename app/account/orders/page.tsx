import Link from "next/link";
import { createClient } from "@/lib/supabase/server";

export default async function OrdersPage() {
  const supabase = await createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return (
      <main>
        <h1>My Orders</h1>

        <p>You must be logged in to view your orders.</p>

        <Link href="/login">
          Login
        </Link>
      </main>
    );
  }

  const { data: orders, error } = await supabase
    .from("orders")
    .select(`
      id,
      status,
      subtotal,
      shipping_fee,
      total,
      created_at,
      order_items (
        id,
        product_name,
        product_sku,
        quantity,
        unit_price,
        line_total
      )
    `)
    .eq("user_id", user.id)
    .order("created_at", { ascending: false });

  if (error) {
    console.error("Orders fetch error:", error);

    return (
      <main>
        <h1>My Orders</h1>

        <p>
          Unable to load your orders right now.
        </p>
      </main>
    );
  }

  return (
    <main>
      <h1>My Orders</h1>

      {orders && orders.length > 0 ? (
        <section>
          {orders.map((order) => (
            <article key={order.id}>
              <h2>
                Order #{order.id.slice(0, 8)}
              </h2>

              <p>
                Date:{" "}
                {new Date(order.created_at).toLocaleDateString(
                  "en-IN"
                )}
              </p>

              <p>
                Status: {order.status}
              </p>

              <div>
                {order.order_items?.map((item) => (
                  <p key={item.id}>
                    {item.product_name} × {item.quantity}
                  </p>
                ))}
              </div>

              <p>
                Total: ₹{Number(order.total).toFixed(2)}
              </p>

              <Link
                href={`/account/orders/${order.id}`}
              >
                View Order
              </Link>
            </article>
          ))}
        </section>
      ) : (
        <section>
          <p>You haven't placed any orders yet.</p>

          <Link href="/shop">
            Start Shopping
          </Link>
        </section>
      )}

      <p>
        <Link href="/account">
          ← Back to Account
        </Link>
      </p>
    </main>
  );
}