import { createClient } from "@/lib/supabase/server";

export default async function ShopPage() {
  const supabase = await createClient();

  const { data: products, error } = await supabase
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
        image_url,
        alt_text,
        display_order
      )
    `)
    .eq("is_active", true)
    .order("created_at", { ascending: false });

  if (error) {
    console.error("Product fetch error:", error);

    return (
      <main>
        <h1>Shop</h1>
        <p>Unable to load products right now.</p>
      </main>
    );
  }

  return (
    <main>
      <h1>Shop</h1>

      {products && products.length > 0 ? (
        <div>
          {products.map((product) => {
            const inventory = Array.isArray(product.inventory)
              ? product.inventory[0]
              : product.inventory;

            const availableQuantity =
              (inventory?.quantity ?? 0) -
              (inventory?.reserved_quantity ?? 0);

            return (
              <article key={product.id}>
                <h2>{product.name}</h2>

                <p>{product.description}</p>

                <p>₹{product.price}</p>

                {product.compare_at_price && (
                  <p>
                    <s>₹{product.compare_at_price}</s>
                  </p>
                )}

                <p>
                  {availableQuantity > 0
                    ? `${availableQuantity} available`
                    : "Out of stock"}
                </p>
              </article>
            );
          })}
        </div>
      ) : (
        <p>No products available.</p>
      )}
    </main>
  );
}