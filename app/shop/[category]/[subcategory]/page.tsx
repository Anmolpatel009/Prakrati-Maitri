import { createClient } from "@/lib/supabase/server";
import Link from "next/link";
import { notFound } from "next/navigation";
import Image from "next/image";

type SubcategoryPageProps = {
  params: Promise<{
    category: string;
    subcategory: string;
  }>;
};

export default async function SubcategoryPage({
  params,
}: SubcategoryPageProps) {
  const { category, subcategory } = await params;

  const categorySlug = category.trim().toLowerCase();
  const subcategorySlug = subcategory.trim().toLowerCase();

  const supabase = await createClient();

  // =====================================================
  // 1. FIND PARENT CATEGORY
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
    .eq("slug", categorySlug)
    .eq("is_active", true)
    .maybeSingle();

  if (categoryError) {
    console.error("Category fetch error:", categoryError);

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
            className="mt-6 inline-flex rounded-full bg-[#4A5D23] px-6 py-3 text-sm font-semibold text-white transition hover:opacity-90"
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
  // 2. FIND SUBCATEGORY
  // =====================================================
  //
  // Find by slug first.
  // Then verify that it belongs to the requested category.
  //
  // This keeps the category → subcategory relationship
  // explicit instead of hiding both checks inside one query.
  // =====================================================

  const {
    data: subcategoryData,
    error: subcategoryError,
  } = await supabase
    .from("subcategories")
    .select(`
      id,
      category_id,
      name,
      slug,
      description,
      display_order,
      is_active
    `)
    .eq("slug", subcategorySlug)
    .eq("is_active", true)
    .maybeSingle();

  if (subcategoryError) {
    console.error(
      "Subcategory fetch error:",
      subcategoryError
    );

    return (
      <main className="flex min-h-screen items-center justify-center bg-[#F9F7F2] px-6">
        <div className="text-center">
          <h1 className="font-serif text-3xl font-semibold text-[#4A5D23]">
            Unable to load collection
          </h1>

          <p className="mt-3 text-[#3D3D3D]/70">
            Please try again later.
          </p>

          <Link
            href={`/shop/${categoryData.slug}`}
            className="mt-6 inline-flex rounded-full bg-[#4A5D23] px-6 py-3 text-sm font-semibold text-white transition hover:opacity-90"
          >
            Back to {categoryData.name}
          </Link>
        </div>
      </main>
    );
  }

  if (!subcategoryData) {
    notFound();
  }

  // =====================================================
  // 3. VERIFY CATEGORY → SUBCATEGORY RELATIONSHIP
  // =====================================================

  if (subcategoryData.category_id !== categoryData.id) {
    notFound();
  }

  // =====================================================
  // 4. FETCH PRODUCTS
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
    .eq("subcategory_id", subcategoryData.id)
    .eq("is_active", true)
    .order("created_at", {
      ascending: false,
    });

  if (productsError) {
    console.error(
      "Subcategory products fetch error:",
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
            href={`/shop/${categoryData.slug}`}
            className="mt-6 inline-flex rounded-full bg-[#4A5D23] px-6 py-3 text-sm font-semibold text-white transition hover:opacity-90"
          >
            Back to {categoryData.name}
          </Link>
        </div>
      </main>
    );
  }

  // =====================================================
  // 5. PREPARE PRODUCTS
  // =====================================================

  const preparedProducts =
    products?.map((product) => {
      const inventory = Array.isArray(product.inventory)
        ? product.inventory[0]
        : product.inventory;

      const availableQuantity =
        (inventory?.quantity ?? 0) -
        (inventory?.reserved_quantity ?? 0);

      const images = Array.isArray(product.product_images)
        ? [...product.product_images].sort(
            (a, b) =>
              (a.display_order ?? 0) -
              (b.display_order ?? 0)
          )
        : [];

      return {
        ...product,
        availableQuantity,
        images,
      };
    }) ?? [];

  // =====================================================
  // 6. PAGE
  // =====================================================

  return (
    <main className="min-h-screen bg-[#F9F7F2] text-[#3D3D3D]">

      {/* ================================================= */}
      {/* BREADCRUMB */}
      {/* ================================================= */}

      <section className="px-6 pt-8 md:px-10 lg:px-16">
        <div className="mx-auto max-w-7xl">
          <nav
            aria-label="Breadcrumb"
            className="flex flex-wrap items-center gap-2 text-sm text-[#3D3D3D]/60"
          >
            <Link
              href="/shop"
              className="transition hover:text-[#4A5D23]"
            >
              Shop
            </Link>

            <span>/</span>

            <Link
              href={`/shop/${categoryData.slug}`}
              className="transition hover:text-[#4A5D23]"
            >
              {categoryData.name}
            </Link>

            <span>/</span>

            <span className="text-[#4A5D23]">
              {subcategoryData.name}
            </span>
          </nav>
        </div>
      </section>

      {/* ================================================= */}
      {/* HERO */}
      {/* ================================================= */}

      <section className="px-6 pb-12 pt-8 md:px-10 lg:px-16">
        <div className="mx-auto max-w-7xl">
          <div className="rounded-[2rem] border border-[#D2B48C]/40 bg-[#E8E1D2] px-6 py-14 text-center md:px-12 md:py-20">

            <p className="mb-4 text-sm font-medium uppercase tracking-[0.2em] text-[#4A5D23]">
              {categoryData.name}
            </p>

            <h1 className="font-serif text-4xl font-semibold text-[#4A5D23] md:text-5xl">
              {subcategoryData.name}
            </h1>

            <p className="mx-auto mt-5 max-w-2xl text-base leading-7 text-[#3D3D3D]/75 md:text-lg">
              {subcategoryData.description ||
                `Explore our ${subcategoryData.name.toLowerCase()} collection.`}
            </p>

          </div>
        </div>
      </section>

      {/* ================================================= */}
      {/* NAVIGATION */}
      {/* ================================================= */}

      <section className="px-6 pb-10 md:px-10 lg:px-16">
        <div className="mx-auto max-w-7xl">
          <div className="flex flex-wrap gap-3">

            <Link
              href="/shop"
              className="rounded-full border border-[#D2B48C]/60 bg-white px-5 py-2.5 text-sm font-medium transition hover:border-[#4A5D23] hover:text-[#4A5D23]"
            >
              All Products
            </Link>

            <Link
              href={`/shop/${categoryData.slug}`}
              className="rounded-full border border-[#D2B48C]/60 bg-white px-5 py-2.5 text-sm font-medium transition hover:border-[#4A5D23] hover:text-[#4A5D23]"
            >
              {categoryData.name}
            </Link>

            <span className="rounded-full border border-[#4A5D23] bg-[#4A5D23] px-5 py-2.5 text-sm font-medium text-white shadow-sm">
              {subcategoryData.name}
            </span>

          </div>
        </div>
      </section>

      {/* ================================================= */}
      {/* PRODUCT COUNT */}
      {/* ================================================= */}

      <section className="border-y border-[#D2B48C]/30 bg-[#F9F7F2] px-6 py-5 md:px-10 lg:px-16">
        <div className="mx-auto max-w-7xl">
          <p className="text-sm text-[#3D3D3D]/65">
            {preparedProducts.length}{" "}
            {preparedProducts.length === 1
              ? "product"
              : "products"}{" "}
            in this collection
          </p>
        </div>
      </section>

      {/* ================================================= */}
      {/* PRODUCTS */}
      {/* ================================================= */}

      <section className="px-6 py-14 md:px-10 lg:px-16">
        <div className="mx-auto max-w-7xl">

          {preparedProducts.length > 0 ? (
            <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">

              {preparedProducts.map((product) => {
                const primaryImage = product.images[0];

                return (
                  <article
                    key={product.id}
                    className="group overflow-hidden rounded-3xl border border-[#D2B48C]/40 bg-white transition-all duration-300 hover:-translate-y-1 hover:shadow-xl"
                  >

                    <Link
                      href={`/products/${product.slug}`}
                      className="block"
                    >

                      {/* PRODUCT IMAGE */}

                      <div className="relative aspect-square overflow-hidden bg-[#F1EDE3]">

                        {primaryImage ? (
                          <Image
                            src={primaryImage.image_url}
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

                        {product.availableQuantity <= 0 && (
                          <div className="absolute left-4 top-4 rounded-full bg-[#3D3D3D]/85 px-3 py-1.5 text-xs font-medium text-white">
                            Out of Stock
                          </div>
                        )}

                      </div>

                      {/* PRODUCT DETAILS */}

                      <div className="p-5">

                        <p className="mb-2 text-xs font-medium uppercase tracking-[0.12em] text-[#4A5D23]/70">
                          {subcategoryData.name}
                        </p>

                        <h2 className="font-serif text-xl font-semibold text-[#3D3D3D] transition-colors group-hover:text-[#4A5D23]">
                          {product.name}
                        </h2>

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
                                    {product.compare_at_price}
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
            /* EMPTY STATE */

            <div className="rounded-[2rem] border border-[#D2B48C]/40 bg-white px-6 py-20 text-center">

              <p className="text-sm font-medium uppercase tracking-[0.15em] text-[#4A5D23]">
                Coming Soon
              </p>

              <h2 className="mt-3 font-serif text-3xl font-semibold text-[#4A5D23]">
                More products are on the way.
              </h2>

              <p className="mx-auto mt-4 max-w-xl text-[#3D3D3D]/65">
                We are preparing more products for this
                collection. Explore the parent category
                while you wait.
              </p>

              <Link
                href={`/shop/${categoryData.slug}`}
                className="mt-7 inline-flex rounded-full bg-[#4A5D23] px-7 py-3 text-sm font-semibold text-white transition hover:-translate-y-0.5 hover:shadow-lg"
              >
                Explore {categoryData.name}
              </Link>

            </div>
          )}

        </div>
      </section>

      {/* ================================================= */}
      {/* BOTTOM CTA */}
      {/* ================================================= */}

      <section className="px-6 pb-16 md:px-10 lg:px-16">
        <div className="mx-auto max-w-7xl">

          <div className="rounded-[2rem] border border-[#D2B48C]/40 bg-[#E8E1D2] px-6 py-14 text-center md:px-12">

            <p className="text-sm font-medium uppercase tracking-[0.2em] text-[#4A5D23]">
              Prakrati Maitri
            </p>

            <h2 className="mx-auto mt-3 max-w-3xl font-serif text-3xl font-semibold text-[#4A5D23] md:text-4xl">
              Thoughtfully made for everyday moments.
            </h2>

            <Link
              href={`/shop/${categoryData.slug}`}
              className="mt-7 inline-flex rounded-full bg-[#8B4513] px-7 py-3 text-sm font-semibold text-white transition hover:-translate-y-0.5 hover:shadow-lg"
            >
              Back to {categoryData.name}
            </Link>

          </div>

        </div>
      </section>

    </main>
  );
}