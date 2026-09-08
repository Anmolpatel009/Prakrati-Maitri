import csv
import json
import re
import time
from pathlib import Path
from urllib.parse import urljoin
from urllib.request import Request, urlopen
from urllib.error import HTTPError, URLError

BASE = "https://ecocarry.co"
OUT = Path(__file__).resolve().parent / "catalog"

OUT.mkdir(parents=True, exist_ok=True)

HEADERS = {
    "User-Agent": "Mozilla/5.0 (compatible; Prakrati-Maitri-Catalog-Import/1.0)"
}


def get_json(url):
    req = Request(url, headers=HEADERS)

    with urlopen(req, timeout=30) as response:
        return json.loads(response.read().decode("utf-8"))


def get_text(url):
    req = Request(url, headers=HEADERS)

    with urlopen(req, timeout=30) as response:
        return response.read().decode("utf-8", errors="replace")


def clean_html(value):
    if not value:
        return ""

    value = re.sub(r"<script.*?</script>", " ", value, flags=re.I | re.S)
    value = re.sub(r"<style.*?</style>", " ", value, flags=re.I | re.S)
    value = re.sub(r"<[^>]+>", " ", value)
    value = re.sub(r"\s+", " ", value)

    return value.strip()


def shopify_products():
    products = []
    page = 1

    while True:
        url = f"{BASE}/products.json?limit=250&page={page}"

        print(f"Fetching products page {page}...")

        try:
            data = get_json(url)
        except Exception as exc:
            print(f"Products endpoint failed: {exc}")
            break

        batch = data.get("products", [])

        if not batch:
            break

        products.extend(batch)

        print(f"  received {len(batch)} products")

        if len(batch) < 250:
            break

        page += 1
        time.sleep(0.5)

    return products


def collection_products(handle):
    url = f"{BASE}/collections/{handle}/products.json?limit=250"

    try:
        data = get_json(url)
        return data.get("products", [])
    except Exception as exc:
        print(f"  collection fetch failed: {exc}")
        return []


def discover_collections():
    """
    First try Shopify's public collections JSON endpoint.
    If unavailable, fall back to the known public navigation
    collections discovered from the site.
    """

    try:
        data = get_json(f"{BASE}/collections.json?limit=250")
        collections = data.get("collections", [])

        if collections:
            print(f"Found {len(collections)} collections via collections.json")
            return collections

    except Exception as exc:
        print(f"collections.json unavailable: {exc}")

    # Public collections visible in EcoCarry navigation.
    fallback = [
        ("Packaging Bags", "packaging-bags"),
        ("Drawstring Bags", "drawstring-bags"),
        ("Paper Bags", "paper-bags"),
        ("Jute Bags", "jute-bags"),
        ("Pouch Bags", "cotton-pouch-bags"),
        ("Saree Covers", "cotton-saree-cover"),

        ("Hand Bags", "carry-handbags"),
        ("Office Bags", "office-bags"),
        ("Lunch Bags", "lunch-bags"),
        ("Kids Bag", "kids-bag"),

        ("Tote bags", "tote-bags"),
        ("Everyday Tote Bags", "everyday-tote-bags"),
        ("Mini Tote Bags", "mini-tote-bags"),
        ("Medium Tote Bags", "medium-tote-bags"),
        ("Large Tote Bags", "large-tote-bags"),

        ("Hamper", "hamper-bags"),
        ("Hamper Bags", "hamper-bags"),
        ("Embroidery Hamper Bags", "embroidery-hamper-bags"),
        ("Eco Gift Set", "eco-gift-set"),
    ]

    return [
        {
            "title": title,
            "handle": handle,
            "source": "fallback-navigation"
        }
        for title, handle in fallback
    ]


def main():
    print("=" * 60)
    print("ECOCARRY LOCAL CATALOG EXTRACTION")
    print("=" * 60)
    print(f"Source: {BASE}")
    print(f"Output: {OUT}")
    print("Supabase writes: ZERO")
    print()

    # ---------------------------------------------------------
    # 1. Products
    # ---------------------------------------------------------

    products = shopify_products()

    print()
    print(f"Unique products discovered: {len(products)}")

    product_map = {}

    for product in products:
        product_map[product["id"]] = {
            "id": product.get("id"),
            "title": product.get("title"),
            "handle": product.get("handle"),
            "source_url": f"{BASE}/products/{product.get('handle')}",
            "description_html": product.get("body_html") or "",
            "description": clean_html(product.get("body_html")),
            "vendor": product.get("vendor"),
            "product_type": product.get("product_type"),
            "tags": product.get("tags", []),
            "created_at": product.get("created_at"),
            "updated_at": product.get("updated_at"),
            "published_at": product.get("published_at"),
            "variants": [],
            "images": [],
            "source_collections": [],
        }

        for variant in product.get("variants", []):
            product_map[product["id"]]["variants"].append({
                "id": variant.get("id"),
                "title": variant.get("title"),
                "sku": variant.get("sku"),
                "price": variant.get("price"),
                "compare_at_price": variant.get("compare_at_price"),
                "available": variant.get("available"),
                "option1": variant.get("option1"),
                "option2": variant.get("option2"),
                "option3": variant.get("option3"),
            })

        for image in product.get("images", []):
            src = image.get("src")

            if src:
                product_map[product["id"]]["images"].append({
                    "id": image.get("id"),
                    "src": src,
                    "alt": image.get("alt"),
                    "width": image.get("width"),
                    "height": image.get("height"),
                })

    # ---------------------------------------------------------
    # 2. Collections
    # ---------------------------------------------------------

    print()
    print("Discovering collections...")

    collections = discover_collections()
    collection_output = []

    for collection in collections:
        title = collection.get("title")
        handle = collection.get("handle")

        if not handle:
            continue

        print(f"Fetching collection: {title} ({handle})")

        collection_products_data = collection_products(handle)

        collection_record = {
            "id": collection.get("id"),
            "title": title,
            "handle": handle,
            "source_url": f"{BASE}/collections/{handle}",
            "product_count": len(collection_products_data),
        }

        collection_output.append(collection_record)

        for product in collection_products_data:
            pid = product.get("id")

            if pid in product_map:
                product_map[pid]["source_collections"].append({
                    "title": title,
                    "handle": handle,
                    "url": f"{BASE}/collections/{handle}",
                })

        time.sleep(0.25)

    # Remove duplicate collection memberships.
    for product in product_map.values():
        seen = set()
        unique = []

        for collection in product["source_collections"]:
            key = collection["handle"]

            if key not in seen:
                seen.add(key)
                unique.append(collection)

        product["source_collections"] = unique

    final_products = list(product_map.values())

    # ---------------------------------------------------------
    # 3. Save JSON
    # ---------------------------------------------------------

    products_file = OUT / "products.json"

    with products_file.open("w", encoding="utf-8") as f:
        json.dump(final_products, f, ensure_ascii=False, indent=2)

    collections_file = OUT / "collections.json"

    with collections_file.open("w", encoding="utf-8") as f:
        json.dump(collection_output, f, ensure_ascii=False, indent=2)

    # ---------------------------------------------------------
    # 4. Save CSV
    # ---------------------------------------------------------

    csv_file = OUT / "products.csv"

    with csv_file.open("w", newline="", encoding="utf-8-sig") as f:
        writer = csv.DictWriter(
            f,
            fieldnames=[
                "source_id",
                "name",
                "handle",
                "source_url",
                "price",
                "compare_at_price",
                "available",
                "sku",
                "product_type",
                "tags",
                "collections",
                "image_count",
                "image_urls",
                "description",
            ],
        )

        writer.writeheader()

        for product in final_products:
            variants = product.get("variants", [])

            first_variant = variants[0] if variants else {}

            writer.writerow({
                "source_id": product.get("id"),
                "name": product.get("title"),
                "handle": product.get("handle"),
                "source_url": product.get("source_url"),
                "price": first_variant.get("price"),
                "compare_at_price": first_variant.get("compare_at_price"),
                "available": first_variant.get("available"),
                "sku": first_variant.get("sku"),
                "product_type": product.get("product_type"),
                "tags": " | ".join(product.get("tags", [])),
                "collections": " | ".join(
                    c["title"]
                    for c in product.get("source_collections", [])
                ),
                "image_count": len(product.get("images", [])),
                "image_urls": " | ".join(
                    image["src"]
                    for image in product.get("images", [])
                ),
                "description": product.get("description"),
            })

    # ---------------------------------------------------------
    # 5. Source category structure
    # ---------------------------------------------------------

    category_map = {
        "source": "EcoCarry",
        "parent_categories": [
            {
                "name": "Packaging Bags",
                "subcategories": [
                    "Drawstring Bags",
                    "Paper Bags",
                    "Jute Bags",
                    "Pouch Bags",
                    "Saree Covers",
                ],
            },
            {
                "name": "Hand Bags",
                "subcategories": [
                    "Office Bags",
                    "Lunch Bags",
                    "Kids Bag",
                ],
            },
            {
                "name": "Tote bags",
                "subcategories": [
                    "Everyday Tote Bags",
                    "Mini Tote Bags",
                    "Medium Tote Bags",
                    "Large Tote Bags",
                ],
            },
            {
                "name": "Hamper",
                "subcategories": [
                    "Hamper Bags",
                    "Embroidery Hamper Bags",
                    "Eco Gift Set",
                ],
            },
        ],
    }

    with (OUT / "category-map.json").open("w", encoding="utf-8") as f:
        json.dump(category_map, f, ensure_ascii=False, indent=2)

    # ---------------------------------------------------------
    # 6. Summary
    # ---------------------------------------------------------

    summary = {
        "source": BASE,
        "products": len(final_products),
        "collections": len(collection_output),
        "products_with_images": sum(
            bool(p["images"]) for p in final_products
        ),
        "total_images": sum(
            len(p["images"]) for p in final_products
        ),
        "products_with_collections": sum(
            bool(p["source_collections"]) for p in final_products
        ),
        "supabase_written": False,
        "images_downloaded": False,
    }

    with (OUT / "extraction-summary.json").open(
        "w",
        encoding="utf-8"
    ) as f:
        json.dump(summary, f, ensure_ascii=False, indent=2)

    print()
    print("=" * 60)
    print("EXTRACTION COMPLETE")
    print("=" * 60)
    print(json.dumps(summary, indent=2))
    print()
    print("Files:")
    print(f"  {products_file}")
    print(f"  {csv_file}")
    print(f"  {collections_file}")
    print(f"  {OUT / 'category-map.json'}")
    print(f"  {OUT / 'extraction-summary.json'}")
    print()
    print("SUPABASE WRITES: ZERO")
    print("IMAGE DOWNLOADS: ZERO")
    print("=" * 60)


if __name__ == "__main__":
    main()
