import { createClient } from "@/lib/supabase/server";
import Link from "next/link";
import { notFound } from "next/navigation";
import ProductConfigurator from "@/components/product/ProductConfigurator";

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
      description,
      price,
      compare_at_price,
      sku,
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
          <h1 className="font-serif text-3xl text-[#4A5D23]">
            Unable to load this product
          </h1>

          <Link
            href="/shop"
            className="mt-6 inline-block text-[#8B4513] underline"
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
      (inventory?.reserved_quantity ?? 0)
  );

  const images = Array.isArray(product.product_images)
    ? [...product.product_images].sort(
        (a, b) => a.display_order - b.display_order
      )
    : [];

  const category = Array.isArray(product.categories)
    ? product.categories[0]
    : product.categories;

  return (
    <main className="min-h-screen bg-[#F9F7F2] text-[#3D3D3D]">
      <div className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">

        {/* Back */}
        <Link
          href="/shop"
          className="mb-8 inline-flex items-center text-sm font-medium text-[#4A5D23] transition hover:text-[#8B4513]"
        >
          ← Back to Shop
        </Link>

        <ProductConfigurator
          product={{
            id: product.id,
            name: product.name,
            slug: product.slug,
            description: product.description,
            price: product.price,
            compare_at_price: product.compare_at_price,
            sku: product.sku,
            categoryName: category?.name ?? "",
            availableQuantity,
            images: images.map((image) => ({
              id: image.id,
              image_url: image.image_url,
              alt_text: image.alt_text,
              display_order: image.display_order,
            })),
          }}
        />
      </div>
    </main>
  );
}