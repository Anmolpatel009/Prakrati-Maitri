import { createClient } from "@/lib/supabase/server";
import BulkOrderForm from "@/components/shop/BulkOrderForm";

export const dynamic = "force-dynamic";

export default async function BulkOrderPage() {
  const supabase = await createClient();

  const [{ data: categories }, { data: products }] = await Promise.all([
    supabase
      .from("categories")
      .select("id, name")
      .eq("is_active", true)
      .order("name", { ascending: true }),

    supabase
      .from("products")
      .select("id, name, slug, category_id")
      .eq("is_active", true)
      .order("name", { ascending: true }),
  ]);

  return (
    <main className="bulk-order-reference-page">
      <div className="bulk-order-reference-wrap">
        <section className="bulk-order-reference-hero" aria-labelledby="bulk-order-page-title">
          <div>
            <p className="bulk-order-reference-eyebrow">Bulk order enquiry</p>

            <h1 id="bulk-order-page-title">
              Let&apos;s plan your
              <br className="bulk-order-reference-break" />
              bulk requirement.
            </h1>

            <p className="bulk-order-reference-lead">
              Sustainable bags for your business, events and corporate gifting,
              made in our own factory and printed with your logo.
            </p>

            <ul className="bulk-order-reference-trust">
              <li>
                <span className="bulk-order-reference-icon" aria-hidden="true">⌂</span>
                <span>Manufacturer</span>
              </li>
              <li>
                <span className="bulk-order-reference-icon" aria-hidden="true">▣</span>
                <span>PAN India delivery</span>
              </li>
              <li>
                <span className="bulk-order-reference-icon" aria-hidden="true">▤</span>
                <span>GST invoice</span>
              </li>
              <li>
                <span className="bulk-order-reference-icon" aria-hidden="true">▭</span>
                <span>Your logo printed</span>
              </li>
            </ul>

            <div className="bulk-order-reference-how">
              <p className="bulk-order-reference-eyebrow">How it works</p>
              <ol className="bulk-order-reference-steps">
                <li>
                  <span className="bulk-order-reference-num">1</span>
                  <div>
                    <strong>Share your requirement</strong>
                    <span>Takes under a minute.</span>
                  </div>
                </li>
                <li>
                  <span className="bulk-order-reference-num">2</span>
                  <div>
                    <strong>Get your quote</strong>
                    <span>Our team connects with you on call or WhatsApp.</span>
                  </div>
                </li>
                <li>
                  <span className="bulk-order-reference-num">3</span>
                  <div>
                    <strong>Approve and we produce</strong>
                    <span>Delivered anywhere in India.</span>
                  </div>
                </li>
              </ol>
            </div>
          </div>

          <section className="bulk-order-reference-card" aria-labelledby="bulk-order-quote-title">
            <BulkOrderForm
              categories={categories ?? []}
              products={products ?? []}
            />
          </section>
        </section>
      </div>
    </main>
  );
}
