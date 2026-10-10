import { createClient } from "@/lib/supabase/server";
import BulkOrderForm from "@/components/shop/BulkOrderForm";
import SharedProductCard, {
  type SharedProductCardProduct,
} from "@/components/shop/ProductCard";
import { getProductCardStyling } from "@/lib/shop/product-card-styling";

export const dynamic = "force-dynamic";

const BULK_TILES = [
  { name: "Canvas-Front Jute", note: "5 sizes", img: "/images/header/bulk-canvas-front-jute.webp" },
  { name: "Cotton Tote Bags", note: "150–350 GSM", img: "/images/header/menu-tote-thumb.webp" },
  { name: "Conference Bags", note: "Fits A4 files", img: "/images/header/bulk-conference-bags.webp" },
  { name: "Window Hampers", note: "4 sizes", img: "/images/header/menu-hamper-thumb.webp" },
  { name: "Drawstring Bags", note: "10 sizes", img: "/images/header/menu-packaging-thumb.webp" },
  { name: "Saree Covers", note: "Packs of 6 / 12 / 24", img: "/images/header/bulk-saree-covers.webp" },
  { name: "Jute Zipper Bags", note: "5 sizes", img: "/images/header/menu-hand-thumb.webp" },
  { name: "Natural Jute Hampers", note: "3 sizes", img: "/images/header/menu-hamper-thumb.webp" },
  { name: "Checks Hampers", note: "3 colours", img: "/images/header/bulk-checks-hampers.webp" },
  { name: "Small Pouches", note: "Jewellery & favours", img: "/images/header/menu-packaging-thumb.webp" },
] as const;

export default async function BulkOrderPage() {
  const supabase = await createClient();

  const [{ data: categories }, { data: formProducts }] = await Promise.all([
    supabase.from("categories").select("id, name")
      .eq("is_active", true).order("name", { ascending: true }),
    supabase.from("products").select("id, name, slug, category_id")
      .eq("is_active", true).order("name", { ascending: true }),
  ]);

  const bulkCategory = (categories ?? []).find(
    (category) => category.name.trim().toLowerCase() === "corporate & bulk",
  );

  let bulkProducts: SharedProductCardProduct[] = [];

  if (bulkCategory) {
    const { data, error } = await supabase.from("products").select(`
      id, name, slug, price,
      product_images (image_url, alt_text, display_order)
    `)
      .eq("category_id", bulkCategory.id)
      .eq("is_active", true)
      .order("display_order", { ascending: true, nullsFirst: false })
      .order("created_at", { ascending: false });

    if (error) {
      console.error("Corporate & Bulk products fetch error:", error);
    } else {
      bulkProducts = (data ?? []) as SharedProductCardProduct[];
    }
  }

  const productCardStyling = await getProductCardStyling();

  return (
    <main className="min-h-screen bg-[#F8F3E8] text-[#3D2B1F]">
      <section className="mx-auto max-w-[1700px] px-5 py-8 md:px-8 lg:px-12 lg:py-9">
        <div className="grid grid-cols-1 items-start gap-7 lg:grid-cols-[minmax(0,1fr)_445px] lg:gap-10">
          <div className="order-2 min-w-0 lg:order-1">
            <div className="mb-5 flex flex-wrap items-end justify-between gap-3">
              <h1 className="font-serif text-4xl font-semibold leading-tight text-[#4A2E1D] sm:text-5xl">
                Branded bags for your business
              </h1>
              <p className="pb-1 text-[10px] font-medium uppercase tracking-[0.22em] text-[#8B4513]">
                Bulk price on every product
              </p>
            </div>

            <div className="grid grid-cols-2 gap-3 sm:grid-cols-3 xl:grid-cols-5 xl:gap-4">
              {BULK_TILES.map((tile) => (
                <article key={tile.name} className="overflow-hidden rounded-xl border border-[#D2B48C]/60 bg-[#FFFCF6] shadow-sm">
                  <div
                    className="flex aspect-square items-center justify-center overflow-hidden bg-[#EEF0E2] p-2"
                    style={{
                      backgroundImage: "linear-gradient(rgba(139,69,19,.055) 1px, transparent 1px), linear-gradient(90deg, rgba(139,69,19,.055) 1px, transparent 1px)",
                      backgroundSize: "8px 8px",
                    }}
                  >
                    <img src={tile.img} alt={tile.name} width={220} height={220} loading="lazy" className="h-full w-full object-contain" />
                  </div>
                  <div className="min-h-[66px] px-3 py-2.5">
                    <h2 className="text-sm font-medium leading-snug text-[#29221D]">{tile.name}</h2>
                    <p className="mt-1 text-[11px] tracking-wide text-[#8B4513]">{tile.note}</p>
                  </div>
                </article>
              ))}
            </div>


            <section id="corporate-bulk-products-section" className="mt-8 border-t border-[#D2B48C]/40 px-0 pt-8">
                                <div className="mx-auto max-w-[1600px]">
                                  <p className="text-xs font-semibold uppercase tracking-[0.22em] text-[#8B4513]">
                                    The Corporate &amp; Bulk collection
                                  </p>
                                  <div className="mt-3 flex flex-wrap items-end justify-between gap-4">
                                    <div>
                                      <h2 className="font-serif text-3xl font-semibold text-[#4A2E1D] sm:text-4xl">
                                        Explore bulk-ready products
                                      </h2>
                                      <p className="mt-3 max-w-2xl text-sm leading-6 text-[#3D3D3D]/70">
                                        Browse our Corporate &amp; Bulk range and send us your quantity, branding and delivery requirements for a quote.
                                      </p>
                                    </div>
                                    <a href="#top" className="text-sm font-semibold text-[#8B4513] underline underline-offset-4 hover:text-[#4A2E1D]">
                                      Request a bulk quote
                                    </a>
                                  </div>

                                  {bulkProducts.length > 0 ? (
                                    <div className="product-grid product-grid-three storefront-product-grid mt-8">
                                      {bulkProducts.map((product) => (
                                        <SharedProductCard key={product.id} product={product} config={productCardStyling} isBulkEnquiry />
                                      ))}
                                    </div>
                                  ) : (
                                    <div className="mt-8 rounded-2xl border border-[#D2B48C]/50 bg-white px-6 py-12 text-center">
                                      <h3 className="font-serif text-2xl text-[#4A2E1D]">
                                        {bulkCategory ? "More products are on the way" : "Corporate & Bulk"}
                                      </h3>
                                      <p className="mt-2 text-sm text-[#3D3D3D]/65">
                                        {bulkCategory
                                          ? "There are currently no active products in this category."
                                          : "The Corporate & Bulk category could not be found. Please check the category in Admin."}
                                      </p>
                                    </div>
                                  )}
                                </div>
                              </section>
          </div>

          <div className="order-1 min-w-0 lg:order-2">
            <section className="bulk-order-reference-card" aria-labelledby="bulk-order-quote-title">
              <BulkOrderForm categories={categories ?? []} products={formProducts ?? []} />
            </section>
          </div>
        </div>
      </section>


    </main>
  );
}