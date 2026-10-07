import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { createClient as createServiceRoleClient } from "@supabase/supabase-js";
import { getProductCardStyling } from "@/lib/shop/product-card-styling";
import SharedProductCard, {
  type SharedProductCardProduct,
} from "@/components/shop/ProductCard";
import styles from "./success.module.css";

type SuccessPageProps = {
  searchParams: Promise<{
    order?: string;
  }>;
};

type OrderItem = {
  id: string;
  product_name: string;
  product_sku: string | null;
  quantity: number;
  unit_price: number;
  line_total: number;
};

type Order = {
  id: string;
  status: string;
  subtotal: number;
  shipping_fee: number;
  total: number;
  shipping_first_name: string | null;
  shipping_last_name: string | null;
  shipping_phone: string | null;
  shipping_address: string | null;
  shipping_city: string | null;
  shipping_state: string | null;
  shipping_country: string | null;
  shipping_postal_code: string | null;
  created_at: string;
  order_items: OrderItem[];
};

function currency(value: number) {
  return `₹${value.toLocaleString("en-IN", {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  })}`;
}

function formatDate(value: string) {
  return new Date(value).toLocaleDateString("en-IN", {
    day: "numeric",
    month: "short",
    year: "numeric",
  });
}

export default async function SuccessPage({
  searchParams,
}: SuccessPageProps) {
  const params = await searchParams;
  const orderId = params.order;

  let order: Order | null = null;
  let customerEmail: string | null = null;
  let suggestedProducts: SharedProductCardProduct[] = [];

  try {
    const supabase = await createClient();

    const {
      data: { user },
    } = await supabase.auth.getUser();

    customerEmail = user?.email ?? null;

    // Order-specific data is fetched only when a real order exists.
    // Authenticated customers remain restricted to their own orders.
    // Guest orders are loaded server-side by their returned order ID.
    if (orderId) {
      const orderClient = user
        ? supabase
        : createServiceRoleClient(
            process.env.NEXT_PUBLIC_SUPABASE_URL!,
            process.env.SUPABASE_SERVICE_ROLE_KEY!,
            {
              auth: {
                autoRefreshToken: false,
                persistSession: false,
              },
            }
          );

      let orderQuery = orderClient
        .from("orders")
        .select(`
          id,
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
          order_items (
            id,
            product_name,
            product_sku,
            quantity,
            unit_price,
            line_total
          )
        `)
        .eq("id", orderId);

      if (user) {
        orderQuery = orderQuery.eq("user_id", user.id);
      }

      const { data } = await orderQuery.single();

      if (data) {
        order = data as Order;
      }
    }

    // Presentation-only product suggestions are loaded even
    // during direct design preview without an order ID.
    const { data: products } = await supabase
      .from("products")
      .select(`
        id,
        name,
        slug,
        price,
        product_images (
          id,
          image_url,
          alt_text,
          display_order
        )
      `)
      .order("display_order", {
        ascending: true,
        nullsFirst: false,
      })
      .limit(4);

    suggestedProducts =
      (products as SharedProductCardProduct[] | null) ?? [];
  } catch (error) {
    console.error(
      "Unable to load post-payment display data:",
      error,
    );
  }

  const itemCount =
    order?.order_items?.reduce(
      (sum, item) => sum + Number(item.quantity || 0),
      0,
    ) ?? 0;

  const productCardStyling = await getProductCardStyling();

  const whatsappHref =
    "https://wa.me/919232040020";

  const displayOrderId = order?.id ?? orderId ?? "Created";

  return (
    <div className={styles.page}>
      <div className={styles.announce}>
        Free shipping on Order above 500/-
      </div>

      <header className={styles.header}>
        <div className={`${styles.wrap} ${styles.headerRow}`}>
          <Link href="/shop" className={styles.logo}>
            PRAKRITI MAITRI
          </Link>

          <span className={styles.secure}>
            Payment secured
          </span>
        </div>
      </header>

      <main>
        <section className={`${styles.wrap} ${styles.hero}`}>
          <div className={styles.tick}>✓</div>

          <p className={styles.eyebrow}>
            Order confirmed
          </p>

          <h1 className={styles.heroTitle}>
            Thank you
          </h1>

          <p className={styles.heroSub}>
            Your order{" "}
            <span className={styles.orderNo}>
              #{displayOrderId}
            </span>{" "}
            has been successfully confirmed.
          </p>

          {order && (
            <>
              <div className={styles.facts}>
                <div className={styles.fact}>
                  <span>Items</span>
                  <b>{itemCount} items</b>
                </div>

                <div className={styles.fact}>
                  <span>Paid</span>
                  <b>{currency(Number(order.total))}</b>
                </div>

                <div className={styles.fact}>
                  <span>Payment</span>
                  <b>Paid</b>
                </div>

                <div className={styles.fact}>
                  <span>Order date</span>
                  <b>{formatDate(order.created_at)}</b>
                </div>
              </div>

              <p className={styles.eco}>
                Every bag you carry replaces single-use plastic.
              </p>
            </>
          )}
        </section>

        <section className={`${styles.wrap} ${styles.cols}`}>
          <div className={styles.stack}>
            <div className={styles.card}>
              <h2 className={styles.cardTitle}>
                What happens next
              </h2>

              <ol className={styles.timeline}>
                <li
                  className={`${styles.timelineItem} ${styles.done}`}
                >
                  <span className={styles.dot} />
                  <div>
                    <b>Order placed</b>
                    <span>
                      Your order has been received successfully.
                    </span>
                  </div>
                </li>

                <li
                  className={`${styles.timelineItem} ${styles.done}`}
                >
                  <span className={styles.dot} />
                  <div>
                    <b>Order approved</b>
                    <span>
                      Your order has been approved for fulfilment.
                    </span>
                  </div>
                </li>

                <li
                  className={`${styles.timelineItem} ${styles.done}`}
                >
                  <span className={styles.dot} />
                  <div>
                    <b>Order confirmed</b>
                    <span>
                      Your order is confirmed and will move through fulfilment.
                    </span>
                  </div>
                </li>

                <li className={styles.timelineItem}>
                  <span className={styles.dot} />
                  <div>
                    <b>Delivered</b>
                    <span>
                      Delivery updates will be available later.
                    </span>
                  </div>
                </li>
              </ol>
            </div>

            {order ? (
              <div className={styles.card}>
                <div className={styles.summaryHeader}>
                  <h2 className={styles.cardTitle}>
                    Order summary
                  </h2>

                  <span className={styles.paidTag}>
                    Paid
                  </span>
                </div>

                {order.order_items.map((item) => (
                  <div
                    className={styles.item}
                    key={item.id}
                  >
                    <span className={styles.thumb}>
                      PM
                    </span>

                    <div>
                      <div className={styles.itemName}>
                        {item.product_name}
                      </div>

                      <p className={styles.itemOpts}>
                        {item.quantity} ×{" "}
                        {currency(Number(item.unit_price))}
                        {item.product_sku
                          ? ` · SKU ${item.product_sku}`
                          : ""}
                      </p>
                    </div>

                    <span className={styles.amount}>
                      {currency(Number(item.line_total))}
                    </span>
                  </div>
                ))}

                <table className={styles.sum}>
                  <tbody>
                    <tr>
                      <td>Subtotal</td>
                      <td>
                        {currency(Number(order.subtotal))}
                      </td>
                    </tr>

                    <tr>
                      <td>Shipping</td>
                      <td>
                        {Number(order.shipping_fee) === 0
                          ? "Free"
                          : currency(
                              Number(order.shipping_fee),
                            )}
                      </td>
                    </tr>

                    <tr className={styles.total}>
                      <td>Total paid</td>
                      <td>
                        {currency(Number(order.total))}
                      </td>
                    </tr>
                  </tbody>
                </table>

                <div className={styles.meta}>
                  <div>
                    <p className={styles.label}>
                      Delivering to
                    </p>

                    <p className={styles.metaValue}>
                      {order.shipping_first_name}{" "}
                      {order.shipping_last_name}
                      <br />
                      {order.shipping_address}
                      <br />
                      {order.shipping_city},{" "}
                      {order.shipping_state}{" "}
                      {order.shipping_postal_code}
                    </p>
                  </div>

                  <div>
                    <p className={styles.label}>
                      Payment
                    </p>

                    <p className={styles.metaValue}>
                      Payment received successfully.
                      {customerEmail && (
                        <>
                          <br />
                          {customerEmail}
                        </>
                      )}
                    </p>
                  </div>
                </div>
              </div>
            ) : (
              <div className={styles.card}>
                <h2 className={styles.cardTitle}>
                  Order received
                </h2>

                <p className={styles.mutedText}>
                  Your order has been created successfully.
                  Keep your order ID for your records.
                </p>
              </div>
            )}
          </div>

          <aside className={styles.stack}>
            {order && (
              <div className={styles.card}>
                <p className={styles.label}>
                  GST invoice
                </p>

                <p
                  className={`${styles.mutedText} ${styles.invoiceText}`}
                >
                  Your GST invoice for order #
                  {displayOrderId.slice(0, 8)} is ready
                  to download.
                </p>

                <div className={styles.btns}>
                  <a
                    className={`${styles.btn} ${styles.primary}`}
                    href={`/api/invoices/${encodeURIComponent(order.id)}`}
                  >
                    Download GST invoice
                  </a>

                  <a
                    className={`${styles.btn} ${styles.secondary}`}
                    href={`mailto:support@prakritimaitri.com?subject=Invoice%20request%20${encodeURIComponent(
                      order.id.slice(0, 8),
                    )}`}
                  >
                    Email invoice
                  </a>
                </div>
              </div>
            )}

            <div
              className={`${styles.card} ${styles.waCard}`}
            >
              <p className={styles.label}>
                Order updates
              </p>

              <p className={styles.waNumber}>
                Get updates on WhatsApp
              </p>

              <p className={styles.mutedText}>
                Contact our team for mockup approval,
                dispatch and delivery updates.
              </p>

              <a
                className={`${styles.btn} ${styles.primary}`}
                href={whatsappHref}
                target="_blank"
                rel="noreferrer"
              >
                WhatsApp +91 9232040020
              </a>
            </div>

            <div className={`${styles.card} ${styles.help}`}>
              <p className={styles.label}>
                Need help?
              </p>

              <p>
                <span>☎</span>
                <span>Call or WhatsApp</span>
                <a
                  className={styles.helpLink}
                  href={whatsappHref}
                  target="_blank"
                  rel="noreferrer"
                >
                  +91 9232040020
                </a>
              </p>

              <p>
                <span>✉</span>
                <span>Email</span>
                <a
                  className={styles.helpLink}
                  href="mailto:support@prakritimaitri.com"
                >
                  support@prakritimaitri.com
                </a>
              </p>

              {/* Track order intentionally removed. */}
            </div>

            <div className={`${styles.card} ${styles.bulk}`}>
              <p className={styles.bulkTitle}>
                Ordering for an event or your team?
              </p>

              <p className={styles.mutedText}>
                Get a custom quote for bulk orders,
                gifting and corporate branding.
              </p>

              <Link
                href="/bulk-order"
                className={`${styles.btn} ${styles.primary}`}
              >
                Request a bulk quote
              </Link>
            </div>
          </aside>
        </section>

        {suggestedProducts.length > 0 && (
          <section className={styles.more}>
            <div className={styles.wrap}>
              <div className={styles.moreHead}>
                <h2 className={styles.moreTitle}>
                  Reorder or add more
                </h2>

                <Link
                  href="/shop"
                  className={styles.moreLink}
                >
                  View all bags →
                </Link>
              </div>

              <div className={styles.suggestedGrid}>
                {suggestedProducts.map((product) => (
                  <SharedProductCard
                    key={product.id}
                    product={product}
                    config={productCardStyling}
                  />
                ))}
              </div>

              <div className={styles.continueWrap}>
                <Link
                  href="/shop"
                  className={`${styles.btn} ${styles.primary} ${styles.continueButton}`}
                >
                  Continue shopping
                </Link>
              </div>
            </div>
          </section>
        )}
      </main>
    </div>
  );
}
