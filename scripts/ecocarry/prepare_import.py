import csv
import json
import re
from collections import Counter
from pathlib import Path

BASE = Path(__file__).resolve().parent
CATALOG = BASE / "catalog"
OUTPUT = BASE / "prepared"

PRODUCTS_FILE = CATALOG / "products.json"
COLLECTIONS_FILE = CATALOG / "collections.json"
CATEGORY_MAP_FILE = CATALOG / "category-map.json"

OUTPUT.mkdir(parents=True, exist_ok=True)


def slugify(value: str) -> str:
    value = value.lower().strip()
    value = re.sub(r"[^a-z0-9]+", "-", value)
    return re.sub(r"^-+|-+$", "", value)


def load_json(path: Path):
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


products = load_json(PRODUCTS_FILE)
collections = load_json(COLLECTIONS_FILE)
category_map = load_json(CATEGORY_MAP_FILE)

# ------------------------------------------------------------
# Production taxonomy
#
# Source collections are NOT blindly converted into categories.
# Campaign/audience/system collections remain source metadata.
# ------------------------------------------------------------

taxonomy = {
    "Packaging Bags": {
        "slug": "packaging-bags",
        "description": "Sustainable packaging bags for businesses, gifting and everyday use.",
        "subcategories": [
            ("Cotton Packaging Bags", "cotton-packaging-bags"),
            ("Drawstring Bags", "drawstring-bags"),
            ("Paper Bags", "paper-bags"),
            ("Jute Bags", "jute-bags"),
            ("Pouch Bags", "pouch-bags"),
            ("Saree Covers", "saree-covers"),
            ("Paper Mailer Bags", "paper-mailer-bags"),
        ],
    },
    "Tote Bags": {
        "slug": "tote-bags",
        "description": "Reusable tote bags in cotton and canvas for everyday carrying.",
        "subcategories": [
            ("Everyday Tote Bags", "everyday-tote-bags"),
            ("Mini Tote Bags", "mini-tote-bags"),
            ("Medium Tote Bags", "medium-tote-bags"),
            ("Large Tote Bags", "large-tote-bags"),
            ("Cotton Tote Bags", "cotton-tote-bags"),
            ("Canvas Tote Bags", "canvas-tote-bags"),
            ("Box Tote Bags", "box-tote-bags"),
        ],
    },
    "Hand Bags": {
        "slug": "hand-bags",
        "description": "Functional reusable handbags for work, lunch and everyday use.",
        "subcategories": [
            ("Office Bags", "office-bags"),
            ("Lunch Bags", "lunch-bags"),
            ("Kids Bags", "kids-bags"),
        ],
    },
    "Hamper Bags": {
        "slug": "hamper-bags",
        "description": "Reusable bags and gift packaging for hampers and special occasions.",
        "subcategories": [
            ("Hamper Bags", "hamper-bags"),
            ("Embroidery Hamper Bags", "embroidery-hamper-bags"),
            ("Eco Gift Sets", "eco-gift-sets"),
        ],
    },
}

# Source collection -> production category/subcategory mapping.
# This is intentionally explicit so the import is auditable.
collection_mapping = {
    "cotton-bags": ("Packaging Bags", "Cotton Packaging Bags"),
    "drawstring-bags": ("Packaging Bags", "Drawstring Bags"),
    "paper-bags": ("Packaging Bags", "Paper Bags"),
    "jute-bags": ("Packaging Bags", "Jute Bags"),
    "cotton-pouch-bags": ("Packaging Bags", "Pouch Bags"),
    "saree-covers": ("Packaging Bags", "Saree Covers"),
    "cotton-saree-cover": ("Packaging Bags", "Saree Covers"),
    "paper-mailer-bags": ("Packaging Bags", "Paper Mailer Bags"),
    "everyday-tote-bags": ("Tote Bags", "Everyday Tote Bags"),
    "mini-tote-bags": ("Tote Bags", "Mini Tote Bags"),
    "medium-tote-bags": ("Tote Bags", "Medium Tote Bags"),
    "large-tote-bags": ("Tote Bags", "Large Tote Bags"),
    "all-tote-bags": ("Tote Bags", "Everyday Tote Bags"),
    "cotton-canvas-tote-bags": ("Tote Bags", "Cotton Tote Bags"),
    "cotton-tote-bags-220-gsm": ("Tote Bags", "Cotton Tote Bags"),
    "canvas-tote-bag-330-gsm": ("Tote Bags", "Canvas Tote Bags"),
    "canvas-shopping-bag-330-gsm": ("Tote Bags", "Canvas Tote Bags"),
    "large-canvas-tote-bag-330-gsm": ("Tote Bags", "Large Tote Bags"),
    "box-tote-bag": ("Tote Bags", "Box Tote Bags"),
    "office-bags": ("Hand Bags", "Office Bags"),
    "lunch-bags": ("Hand Bags", "Lunch Bags"),
    "kids-bag": ("Hand Bags", "Kids Bags"),
    "kids-tote-bag": ("Hand Bags", "Kids Bags"),
    "embroidery-kids-tote-bag": ("Hand Bags", "Kids Bags"),
    "hamper-bags": ("Hamper Bags", "Hamper Bags"),
    "embroidery-hamper-bags": ("Hamper Bags", "Embroidery Hamper Bags"),
    "eco-gift-set": ("Hamper Bags", "Eco Gift Sets"),
}

# ------------------------------------------------------------
# Build product mappings
# ------------------------------------------------------------

prepared_products = []
sku_seen = {}
warnings = []

for index, product in enumerate(products, start=1):
    source_collections = product.get("collections", product.get("source_collections", []))

    if isinstance(source_collections, list):
        handles = []
        for item in source_collections:
            if isinstance(item, str):
                handles.append(item)
            elif isinstance(item, dict):
                handle = item.get("handle")
                if handle:
                    handles.append(handle)
    else:
        handles = []

    mapped = []

    for handle in handles:
        if handle in collection_mapping:
            mapped.append(collection_mapping[handle])

    # Remove duplicates while preserving order.
    mapped = list(dict.fromkeys(mapped))

    if not mapped:
        warnings.append({
            "type": "unmapped_product",
            "product": product.get("title"),
            "handle": product.get("handle"),
            "source_collections": handles,
        })

    # Prefer the most specific production mapping.
    if mapped:
        category_name, subcategory_name = mapped[0]
    else:
        category_name = None
        subcategory_name = None

    variants = product.get("variants", [])
    images = product.get("images", [])

    prices = []
    for variant in variants:
        price = variant.get("price")
        if price not in (None, ""):
            try:
                prices.append(float(price))
            except (TypeError, ValueError):
                pass

    primary_price = min(prices) if prices else None

    sku_values = [
        str(v.get("sku")).strip()
        for v in variants
        if v.get("sku") not in (None, "")
    ]

    source_skus = sku_values.copy()

    base_sku = sku_values[0] if sku_values else f"PM-{index:04d}"
    sku_seen[base_sku] = sku_seen.get(base_sku, 0) + 1
    our_sku = (
        base_sku
        if sku_seen[base_sku] == 1
        else f"{base_sku}-{sku_seen[base_sku]}"
    )

    available = any(
        bool(v.get("available"))
        for v in variants
    )

    prepared_products.append({
        "source_id": product.get("id"),
        "source_handle": product.get("handle"),
        "name": product.get("title"),
        "slug": slugify(product.get("handle") or product.get("title") or f"product-{index}"),
        "description": product.get("description"),
        "vendor": product.get("vendor"),
        "source_product_type": product.get("product_type"),
        "category": category_name,
        "subcategory": subcategory_name,
        "price": primary_price,
        "sku": our_sku,
        "source_skus": source_skus,
        "is_active": available,
        "variants_count": len(variants),
        "images_count": len(images),
        "source_collections": handles,
        "images": images,
        "variants": variants,
    })


# ------------------------------------------------------------
# Reports
# ------------------------------------------------------------

category_counts = Counter(
    p["category"] for p in prepared_products if p["category"]
)

subcategory_counts = Counter(
    p["subcategory"] for p in prepared_products if p["subcategory"]
)

unmapped = [
    p for p in prepared_products
    if not p["category"] or not p["subcategory"]
]

missing_images = [
    p for p in prepared_products
    if not p["images"]
]

missing_prices = [
    p for p in prepared_products
    if p["price"] is None
]

inactive = [
    p for p in prepared_products
    if not p["is_active"]
]

report = {
    "source": "EcoCarry",
    "products": len(prepared_products),
    "production_categories": len(taxonomy),
    "production_subcategories": sum(
        len(v["subcategories"]) for v in taxonomy.values()
    ),
    "products_mapped": len(prepared_products) - len(unmapped),
    "products_unmapped": len(unmapped),
    "products_missing_images": len(missing_images),
    "products_missing_prices": len(missing_prices),
    "products_inactive": len(inactive),
    "total_variants": sum(p["variants_count"] for p in prepared_products),
    "total_images": sum(p["images_count"] for p in prepared_products),
    "category_counts": dict(category_counts),
    "subcategory_counts": dict(subcategory_counts),
    "warnings": warnings,
}

with (OUTPUT / "taxonomy.json").open("w", encoding="utf-8") as f:
    json.dump(taxonomy, f, indent=2, ensure_ascii=False)

with (OUTPUT / "prepared-products.json").open("w", encoding="utf-8") as f:
    json.dump(prepared_products, f, indent=2, ensure_ascii=False)

with (OUTPUT / "import-report.json").open("w", encoding="utf-8") as f:
    json.dump(report, f, indent=2, ensure_ascii=False)

with (OUTPUT / "unmapped-products.json").open("w", encoding="utf-8") as f:
    json.dump(unmapped, f, indent=2, ensure_ascii=False)

print("=" * 70)
print("ECOCARRY → PRAKRATI IMPORT PREPARATION")
print("=" * 70)
print()
print("DRY RUN ONLY")
print("SUPABASE WRITES: ZERO")
print("IMAGE DOWNLOADS: ZERO")
print()
print(f"Products                 : {len(prepared_products)}")
print(f"Variants                 : {report['total_variants']}")
print(f"Images                   : {report['total_images']}")
print()
print("PRODUCTION TAXONOMY")
for category, data in taxonomy.items():
    print(f"  {category}")
    for subcategory, _slug in data["subcategories"]:
        print(f"    └── {subcategory}")
print()
print("PRODUCT MAPPING")
for category, count in category_counts.most_common():
    print(f"  {category:25} {count:3}")
print()
print(f"Mapped products           : {report['products_mapped']}")
print(f"Unmapped products         : {report['products_unmapped']}")
print(f"Missing images            : {report['products_missing_images']}")
print(f"Missing prices            : {report['products_missing_prices']}")
print(f"Inactive products         : {report['products_inactive']}")
print()
print("OUTPUT")
print(f"  {OUTPUT / 'taxonomy.json'}")
print(f"  {OUTPUT / 'prepared-products.json'}")
print(f"  {OUTPUT / 'import-report.json'}")
print(f"  {OUTPUT / 'unmapped-products.json'}")
print()
print("DRY RUN COMPLETE")
print("NO SUPABASE WRITES")
print("NO IMAGE DOWNLOADS")
