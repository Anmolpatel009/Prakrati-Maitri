import { createClient } from "@/lib/supabase/server";
import Link from "next/link";
import { notFound } from "next/navigation";
import Image from "next/image";
import AddToCartButton from "@/components/cart/AddToCartButton";
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
    return <p>Unable to load this product.</p>;
  }

  if (!product) {
    notFound();
  }

  const inventory = Array.isArray(product.inventory)
    ? product.inventory[0]
    : product.inventory;

  const availableQuantity =
    (inventory?.quantity ?? 0) -
    (inventory?.reserved_quantity ?? 0);

  const images = Array.isArray(product.product_images)
    ? [...product.product_images].sort(
        (a, b) => a.display_order - b.display_order
      )
    : [];

  return (
    <main>
      <p>
        <Link href="/shop">← Back to Shop</Link>
      </p>

      <section>
        <div>
          {images.length > 0 ? (
            images.map((image) => (
               <Image
    key={image.id}
    src={image.image_url}
    alt={image.alt_text || product.name}
    width={500}
    height={500}
  />
            ))
          ) : (
            <div>
              <p>Product image coming soon</p>
            </div>
          )}
        </div>

        <div>
       <p>
  {(() => {
    const category = product.categories as
      | { id: string; name: string; slug: string }
      | { id: string; name: string; slug: string }[]
      | null;

    if (!category) {
      return "";
    }

    return Array.isArray(category)
      ? category[0]?.name ?? ""
      : category.name;
  })()}
</p>
          <h1>{product.name}</h1>

          <p>{product.description}</p>

          <h2>₹{product.price}</h2>

          {product.compare_at_price &&
            product.compare_at_price > product.price && (
              <p>
                <s>₹{product.compare_at_price}</s>
              </p>
            )}

          <p>SKU: {product.sku}</p>

          <p>
            {availableQuantity > 0
              ? `${availableQuantity} available`
              : "Out of stock"}
          </p>

         {availableQuantity > 0 && (
  <AddToCartButton
    productId={product.id}
    name={product.name}
    slug={product.slug}
    price={product.price}
    imageUrl={images[0]?.image_url ?? null}
  />
)}
        </div>
      </section>
    </main>
  );
}