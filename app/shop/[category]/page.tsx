import { createClient } from "@/lib/supabase/server";
import Link from "next/link";
import { notFound } from "next/navigation";
import Image from "next/image";

type CategoryPageProps = {
  params: Promise<{
    category: string;
  }>;
};

export default async function CategoryPage({
  params,
}: CategoryPageProps) {
  const { category } = await params;

  const supabase = await createClient();

  // =====================================================
  // FIND CATEGORY
  // =====================================================

  const {
    data: categoryData,
    error: categoryError,
  } = await supabase
    .from("categories")
    .select(`
      id,
      name,
      slug
    `)
    .eq("slug", category)
    .maybeSingle();

  if (categoryError) {
    console.error(
      "Category fetch error:",
      categoryError
    );

    return (
      <main className="flex min-h-screen items-center justify-center bg-[#F9F7F2] px-6">
        <div className="text-center">
          <h1 className="font-serif text-3xl font-semibold text-[#4A5D23]">
            Something went wrong
          </h1>

          <p className="mt-3 text-[#3D3D3D]/70">
            Unable to load this collection right now.
          </p>

          <Link
            href="/shop"
            className="mt-6 inline-flex rounded-full bg-[#4A5D23] px-6 py-3 text-sm font-semibold text-white"
          >
            Back to Shop
          </Link>
        </div>
      </main>
    );
  }

  if (!categoryData) {
    notFound();
  }

  // =====================================================
  // FETCH PRODUCTS
  // =====================================================

  const {
    data: products,
    error: productsError,
  } = await supabase
    .from("products")
    .select(`
      id,
      name,
      slug,
      description,
      price,
      compare_at_price,
      sku,
      subcategory_id,
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
    .eq("category_id", categoryData.id)
    .eq("is_active", true)
    .order("created_at", {
      ascending: false,
    });

  if (productsError) {
    console.error(
      "Category products fetch error:",
      productsError
    );

    return (
      <main className="flex min-h-screen items-center justify-center bg-[#F9F7F2] px-6">
        <div className="text-center">
          <h1 className="font-serif text-3xl font-semibold text-[#4A5D23]">
            Unable to load products
          </h1>

          <p className="mt-3 text-[#3D3D3D]/70">
            Please try again later.
          </p>

          <Link
            href="/shop"
            className="mt-6 inline-flex rounded-full bg-[#4A5D23] px-6 py-3 text-sm font-semibold text-white"
          >
            Back to Shop
          </Link>
        </div>
      </main>
    );
  }

  // =====================================================
  // PREPARE PRODUCTS
  // =====================================================

  const preparedProducts =
    products?.map((product) => {
      const inventory = Array.isArray(
        product.inventory
      )
        ? product.inventory[0]
        : product.inventory;

      const availableQuantity =
        (inventory?.quantity ?? 0) -
        (inventory?.reserved_quantity ?? 0);

      const images = Array.isArray(
        product.product_images
      )
        ? [...product.product_images].sort(
            (a, b) =>
              a.display_order -
              b.display_order
          )
        : [];

      return {
        ...product,
        availableQuantity,
        images,
      };
    }) ?? [];

  // =====================================================
  // PAGE
  // =====================================================

  return (
    <main className="min-h-screen bg-[#F9F7F2] text-[#3D3D3D]">
      {/* ================================================= */}
      {/* HERO */}
      {/* ================================================= */}

      <section className="px-6 pb-12 pt-16 md:px-10 lg:px-16">
        <div className="mx-auto max-w-7xl">
          <div className="rounded-[2rem] border border-[#D2B48C]/40 bg-[#E8E1D2] px-6 py-16 text-center md:px-12 md:py-24">
            <p className="mb-4 text-sm font-medium uppercase tracking-[0.2em] text-[#4A5D23]">
              Prakrati Maitri Collection
            </p>

            <h1 className="font-serif text-4xl font-semibold text-[#4A5D23] md:text-5xl lg:text-6xl">
              {categoryData.name}
            </h1>

            <p className="mx-auto mt-5 max-w-2xl text-base leading-7 text-[#3D3D3D]/75 md:text-lg">
              Explore our thoughtfully selected{" "}
              {categoryData.name.toLowerCase()} collection.
            </p>
          </div>
        </div>
      </section>

      {/* ================================================= */}
      {/* CATEGORY NAVIGATION */}
      {/* ================================================= */}

      <section className="px-6 pb-10 md:px-10 lg:px-16">
        <div className="mx-auto max-w-7xl">
          <div className="flex gap-3 overflow-x-auto pb-3">
            <Link
              href="/shop"
              className="whitespace-nowrap rounded-full border border-[#D2B48C]/60 bg-white px-5 py-2.5 text-sm font-medium text-[#3D3D3D] transition hover:border-[#4A5D23] hover:text-[#4A5D23]"
            >
              All Products
            </Link>

            <Link
              href={`/shop/${categoryData.slug}`}
              className="whitespace-nowrap rounded-full border border-[#4A5D23] bg-[#4A5D23] px-5 py-2.5 text-sm font-medium text-white shadow-md"
            >
              {categoryData.name}
            </Link>
          </div>
        </div>
      </section>

      {/* ================================================= */}
      {/* FILTER / SORT */}
      {/* ================================================= */}

      <section className="border-y border-[#D2B48C]/30 bg-[#F9F7F2] px-6 py-5 md:px-10 lg:px-16">
        <div className="mx-auto flex max-w-7xl flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
          <p className="text-sm text-[#3D3D3D]/65">
            {preparedProducts.length}{" "}
            {preparedProducts.length === 1
              ? "product"
              : "products"}{" "}
            in this collection
          </p>

          <div className="flex gap-3">
            <button
              type="button"
              className="rounded-full border border-[#D2B48C]/60 bg-white px-5 py-2.5 text-sm transition hover:border-[#4A5D23]"
            >
              Filter
            </button>

            <button
              type="button"
              className="rounded-full border border-[#D2B48C]/60 bg-white px-5 py-2.5 text-sm transition hover:border-[#4A5D23]"
            >
              Sort by
            </button>
          </div>
        </div>
      </section>

      {/* ================================================= */}
      {/* PRODUCT GRID */}
      {/* ================================================= */}

      <section className="px-6 py-14 md:px-10 lg:px-16">
        <div className="mx-auto max-w-7xl">
          <div className="mb-8">
            <p className="text-sm uppercase tracking-[0.15em] text-[#4A5D23]">
              Collection
            </p>

            <h2 className="mt-2 font-serif text-3xl font-semibold text-[#4A5D23] md:text-4xl">
              {categoryData.name}
            </h2>
          </div>

          {preparedProducts.length > 0 ? (
            <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
              {preparedProducts.map((product) => {
                const primaryImage =
                  product.images[0];

                return (
                  <article
                    key={product.id}
                    className="group overflow-hidden rounded-3xl border border-[#D2B48C]/40 bg-white transition-all duration-300 hover:-translate-y-1 hover:shadow-xl"
                  >
                    <Link
                      href={`/products/${product.slug}`}
                      className="block"
                    >
                      {/* IMAGE */}

                      <div className="relative aspect-square overflow-hidden bg-[#F1EDE3]">
                        {primaryImage ? (
                          <Image
                            src={
                              primaryImage.image_url
                            }
                            alt={
                              primaryImage.alt_text ||
                              product.name
                            }
                            width={700}
                            height={700}
                            className="h-full w-full object-cover transition-transform duration-500 group-hover:scale-105"
                            sizes="(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 33vw"
                          />
                        ) : (
                          <div className="flex h-full items-center justify-center">
                            <div className="text-center">
                              <p className="font-serif text-lg text-[#4A5D23]/70">
                                Product Image
                              </p>

                              <p className="mt-1 text-xs text-[#3D3D3D]/45">
                                Image coming soon
                              </p>
                            </div>
                          </div>
                        )}

                        {/* STOCK BADGE */}

                        {product.availableQuantity <=
                          0 && (
                          <div className="absolute left-4 top-4 rounded-full bg-[#3D3D3D]/85 px-3 py-1.5 text-xs font-medium text-white">
                            Out of Stock
                          </div>
                        )}
                      </div>

                      {/* DETAILS */}

                      <div className="p-5">
                        <p className="mb-2 text-xs font-medium uppercase tracking-[0.12em] text-[#4A5D23]/70">
                          {categoryData.name}
                        </p>

                        <h3 className="font-serif text-xl font-semibold text-[#3D3D3D] transition-colors group-hover:text-[#4A5D23]">
                          {product.name}
                        </h3>

                        {product.description && (
                          <p className="mt-2 line-clamp-2 text-sm leading-6 text-[#3D3D3D]/60">
                            {product.description}
                          </p>
                        )}

                        <div className="mt-4 flex items-end justify-between gap-4">
                          <div>
                            <p className="text-lg font-semibold text-[#4A5D23]">
                              ₹{product.price}
                            </p>

                            {product.compare_at_price &&
                              product.compare_at_price >
                                product.price && (
                                <p className="text-sm text-[#3D3D3D]/45">
                                  <s>
                                    ₹
                                    {
                                      product.compare_at_price
                                    }
                                  </s>
                                </p>
                              )}
                          </div>

                          <span className="text-sm font-medium text-[#8B4513]">
                            View Product →
                          </span>
                        </div>
                      </div>
                    </Link>
                  </article>
                );
              })}
            </div>
          ) : (
            /* ================================================= */
            /* EMPTY STATE */
            /* ================================================= */

            <div className="rounded-[2rem] border border-[#D2B48C]/40 bg-white px-6 py-20 text-center">
              <p className="text-sm font-medium uppercase tracking-[0.15em] text-[#4A5D23]">
                Coming Soon
              </p>

              <h3 className="mt-3 font-serif text-3xl font-semibold text-[#4A5D23]">
                More products are on the way.
              </h3>

              <p className="mx-auto mt-4 max-w-xl text-[#3D3D3D]/65">
                We're preparing more products for this
                collection. Explore the rest of our shop
                while you wait.
              </p>

              <Link
                href="/shop"
                className="mt-7 inline-flex rounded-full bg-[#4A5D23] px-7 py-3 text-sm font-semibold text-white transition hover:-translate-y-0.5 hover:shadow-lg"
              >
                Explore All Products
              </Link>
            </div>
          )}
        </div>
      </section>

      {/* ================================================= */}
      {/* STORY / CTA */}
      {/* ================================================= */}

      <section className="px-6 pb-16 md:px-10 lg:px-16">
        <div className="mx-auto max-w-7xl">
          <div className="rounded-[2rem] border border-[#D2B48C]/40 bg-[#E8E1D2] px-6 py-14 text-center md:px-12">
            <p className="text-sm font-medium uppercase tracking-[0.2em] text-[#4A5D23]">
              Made with purpose
            </p>

            <h2 className="mx-auto mt-3 max-w-3xl font-serif text-3xl font-semibold text-[#4A5D23] md:text-4xl">
              Thoughtful products for everyday moments.
            </h2>

            <p className="mx-auto mt-4 max-w-2xl text-[#3D3D3D]/70">
              Discover reusable, practical, and thoughtfully
              designed products from Prakrati Maitri.
            </p>

            <Link
              href="/shop"
              className="mt-7 inline-flex rounded-full bg-[#8B4513] px-7 py-3 text-sm font-semibold text-white transition hover:-translate-y-0.5 hover:shadow-lg"
            >
              Explore All Products
            </Link>
          </div>
        </div>
      </section>
    </main>
  );
}