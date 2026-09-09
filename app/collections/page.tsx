import { createClient } from "@/lib/supabase/server";
import CollectionsClient from "@/components/shop/CollectionsClient";

export const dynamic = "force-dynamic";

export default async function CollectionsPage() {
  const supabase = await createClient();

  const [
    { data: products, error: productsError },
    { data: categories, error: categoriesError },
    { data: subcategories, error: subcategoriesError },
  ] = await Promise.all([
    supabase
      .from("products")
      .select(`
        id,
        name,
        slug,
        description,
        price,
        compare_at_price,
        sku,
        category_id,
        subcategory_id,
        inventory (
          quantity,
          reserved_quantity
        ),
        product_images (
          image_url,
          alt_text,
          display_order
        )
      `)
      .eq("is_active", true)
      .order("created_at", { ascending: false }),

    supabase
      .from("categories")
      .select("id, name, slug")
      .eq("is_active", true)
      .order("name", { ascending: true }),

    supabase
      .from("subcategories")
      .select("id, name, slug, category_id")
      .eq("is_active", true)
      .order("name", { ascending: true }),
  ]);

  if (productsError) {
    console.error(
      "Failed to load collection products:",
      productsError.message
    );
  }

  if (categoriesError) {
    console.error(
      "Failed to load collection categories:",
      categoriesError.message
    );
  }

  if (subcategoriesError) {
    console.error(
      "Failed to load collection subcategories:",
      subcategoriesError.message
    );
  }

  const normalizedProducts = (products ?? []).map((product) => {
    const images = [...(product.product_images ?? [])].sort(
      (a, b) => a.display_order - b.display_order
    );

    const inventory = Array.isArray(product.inventory)
      ? product.inventory[0]
      : product.inventory;

    return {
      id: product.id,
      name: product.name,
      slug: product.slug,
      description: product.description,
      price: Number(product.price),
      compareAtPrice:
        product.compare_at_price === null
          ? null
          : Number(product.compare_at_price),
      sku: product.sku,
      categoryId: product.category_id,
      subcategoryId: product.subcategory_id,
      availableQuantity:
        Number(inventory?.quantity ?? 0) -
        Number(inventory?.reserved_quantity ?? 0),
      image: images[0]
        ? {
            imageUrl: images[0].image_url,
            altText: images[0].alt_text,
          }
        : null,
    };
  });

  return (
    <CollectionsClient
      products={normalizedProducts}
      categories={categories ?? []}
      subcategories={subcategories ?? []}
    />
  );
}
