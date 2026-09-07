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
    <main className="bulk-order-page">
      <section className="bulk-order-hero">
        <span className="bulk-order-eyebrow">
          BULK ORDER ENQUIRY
        </span>

        <h1>
          Let&apos;s plan your bulk requirement.
        </h1>

        <p>
          Whether you need sustainable bags for your business, events,
          corporate gifting or a large personal requirement, tell us what
          you&apos;re looking for. Our team will connect with you.
        </p>
      </section>

      <section className="bulk-order-form-section">
        <BulkOrderForm
          categories={categories ?? []}
          products={products ?? []}
        />
      </section>
    </main>
  );
}
