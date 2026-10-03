import { createClient } from "@/lib/supabase/server";
import Link from "next/link";
import { notFound } from "next/navigation";
import ProductConfigurator from "@/components/product/ProductConfigurator";
import { getProductCardStyling } from "@/lib/shop/product-card-styling";

type ProductPageProps = {
  params: Promise<{
    slug: string;
  }>;
};

export default async function ProductPage({
  params,
}: ProductPageProps) {
  const { slug } = await params;
  const supabase = await createClient();

  const { data: product, error } = await supabase
    .from("products")
    .select(`
      id,
      name,
      slug,
      category_id,
      subcategory_id,
      short_description,
      description,
      price,
      compare_at_price,
      sku,
      minimum_order_quantity,
      categories (
        id,
        name,
        slug
      ),
      inventory (
        quantity,
        reserved_quantity
      ),
      product_images (
        id,
        image_url,
        alt_text,
        display_order
      )
    `)
    .eq("slug", slug)
    .eq("is_active", true)
    .maybeSingle();

  if (error) {
    console.error("Product detail error:", error);

    return (
      <main className="min-h-screen bg-[#F9F7F2] px-6 py-16">
        <div className="mx-auto max-w-7xl">
          <h1 className="font-serif text-3xl text-[#4E3320]">
            Unable to load this product
          </h1>

          <Link
            href="/shop"
            className="mt-6 inline-block text-[#8B5A2B] underline"
          >
            ← Back to Shop
          </Link>
        </div>
      </main>
    );
  }

  if (!product) {
    notFound();
  }

  const inventory = Array.isArray(product.inventory)
    ? product.inventory[0]
    : product.inventory;

  const availableQuantity = Math.max(
    0,
    (inventory?.quantity ?? 0) -
      (inventory?.reserved_quantity ?? 0),
  );

  const images = Array.isArray(product.product_images)
    ? [...product.product_images].sort(
        (a, b) =>
          (a.display_order ?? 0) -
          (b.display_order ?? 0),
      )
    : [];

  const category = Array.isArray(product.categories)
    ? product.categories[0]
    : product.categories;

  /*
   * Recommendation strategy:
   * 1. Same subcategory first.
   * 2. Fill remaining slots from same category.
   * 3. Never show the current product.
   * 4. Maximum 4 recommendations.
   *
   * These queries are intentionally independent from the
   * product/cart flow, so recommendation failures cannot
   * break the PDP purchase functionality.
   */
  const productCardStyling =
    await getProductCardStyling();

  const recommendationFields = `
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
  `;

  let suggestedProducts: Array<{
    id: string;
    name: string;
    slug: string;
    price: number;
    product_images: Array<{
      id: string;
      image_url: string;
      alt_text: string | null;
      display_order: number | null;
    }> | null;
  }> = [];

  if (product.subcategory_id) {
    const { data: sameSubcategory } = await supabase
      .from("products")
      .select(recommendationFields)
      .eq(
        "subcategory_id",
        product.subcategory_id,
      )
      .eq("is_active", true)
      .neq("id", product.id)
      .order("display_order", {
        ascending: true,
        nullsFirst: false,
      })
      .order("created_at", {
        ascending: false,
      })
      .limit(4);

    suggestedProducts = sameSubcategory ?? [];
  }

  if (suggestedProducts.length < 4) {
    const { data: sameCategory } = await supabase
      .from("products")
      .select(recommendationFields)
      .eq("category_id", product.category_id)
      .eq("is_active", true)
      .neq("id", product.id)
      .order("display_order", {
        ascending: true,
        nullsFirst: false,
      })
      .order("created_at", {
        ascending: false,
      })
      .limit(8);

    const existingIds = new Set(
      suggestedProducts.map((item) => item.id),
    );

    for (const item of sameCategory ?? []) {
      if (
        existingIds.has(item.id) ||
        suggestedProducts.length >= 4
      ) {
        continue;
      }

      suggestedProducts.push(item);
      existingIds.add(item.id);
    }
  }

  suggestedProducts = suggestedProducts.slice(0, 4);

  return (
    <main className="pdp-page min-h-screen text-[#2E2118]">
      <ProductConfigurator
        product={{
          id: product.id,
          name: product.name,
          slug: product.slug,
          short_description:
            product.short_description,
          description: product.description,
          price: product.price,
          compare_at_price:
            product.compare_at_price,
          sku: product.sku,
          minimum_order_quantity:
            product.minimum_order_quantity ?? 1,
          categoryName: category?.name ?? "",
          availableQuantity,
          images: images.map((image) => ({
            id: image.id,
            image_url: image.image_url,
            alt_text: image.alt_text,
            display_order: image.display_order,
          })),
        }}
        suggestedProducts={suggestedProducts}
        suggestedProductCardConfig={
          productCardStyling
        }
      />
    </main>
  );
}
