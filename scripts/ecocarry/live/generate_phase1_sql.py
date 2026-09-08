from pathlib import Path
import json

BASE = Path("scripts/ecocarry")
PREPARED = BASE / "prepared/prepared-products.json"
OUT = BASE / "live/phase1-products.sql"

products = json.loads(PREPARED.read_text())

if len(products) != 216:
    raise SystemExit(f"SAFETY STOP: expected 216 products, found {len(products)}")

skus = [str(p.get("sku", "")).strip() for p in products]

if any(not sku for sku in skus):
    raise SystemExit("SAFETY STOP: product without database SKU")

if len(set(skus)) != len(skus):
    raise SystemExit("SAFETY STOP: duplicate database SKU detected")

expected_categories = [
    "Packaging Bags",
    "Tote Bags",
    "Hand Bags",
    "Hamper Bags",
]

expected_subcategories = {
    "Packaging Bags": [
        "Cotton Packaging Bags",
        "Drawstring Bags",
        "Paper Bags",
        "Jute Bags",
        "Pouch Bags",
        "Saree Covers",
        "Paper Mailer Bags",
    ],
    "Tote Bags": [
        "Everyday Tote Bags",
        "Mini Tote Bags",
        "Medium Tote Bags",
        "Large Tote Bags",
        "Cotton Tote Bags",
        "Canvas Tote Bags",
        "Box Tote Bags",
    ],
    "Hand Bags": [
        "Office Bags",
        "Lunch Bags",
        "Kids Bags",
    ],
    "Hamper Bags": [
        "Hamper Bags",
        "Embroidery Hamper Bags",
        "Eco Gift Sets",
    ],
}

actual_categories = sorted({
    p.get("category")
    for p in products
    if p.get("category")
})

if set(actual_categories) != set(expected_categories):
    raise SystemExit(
        f"SAFETY STOP: category mismatch: {actual_categories}"
    )

# Validate that every product mapping belongs to the approved taxonomy.
# Some approved subcategories may legitimately have zero products.
allowed_mappings = {
    (category, subcategory)
    for category, subcategories in expected_subcategories.items()
    for subcategory in subcategories
}

actual_mappings = {
    (p.get("category"), p.get("subcategory"))
    for p in products
}

invalid_mappings = sorted(actual_mappings - allowed_mappings)

if invalid_mappings:
    raise SystemExit(
        f"SAFETY STOP: products contain invalid category/subcategory mappings: "
        f"{invalid_mappings}"
    )

def sql_text(value):
    if value is None:
        return "NULL"
    value = str(value)
    return "'" + value.replace("'", "''") + "'"

def sql_num(value):
    if value is None:
        return "NULL"
    return str(value)

lines = []

lines += [
    "-- ============================================================",
    "-- ECOCARRY -> PRAKRATI MAITRI",
    "-- PHASE 1: CATALOG / TAXONOMY / INVENTORY",
    "-- ============================================================",
    "--",
    "-- 216 products",
    "-- 4 categories",
    "-- 20 subcategories",
    "--",
    "-- NO product_images inserts",
    "-- NO Storage operations",
    "-- NO image downloads",
    "-- Existing products are ARCHIVED, not deleted.",
    "-- ============================================================",
    "",
    "BEGIN;",
    "",
    "-- Archive the existing development catalog.",
    "UPDATE public.products",
    "SET is_active = false, updated_at = now()",
    "WHERE is_active = true;",
    "",
    "UPDATE public.subcategories",
    "SET is_active = false, updated_at = now()",
    "WHERE is_active = true;",
    "",
    "UPDATE public.categories",
    "SET is_active = false, updated_at = now()",
    "WHERE is_active = true;",
    "",
]

# Categories
for category in expected_categories:
    slug = category.lower().replace(" ", "-")
    lines += [
        "INSERT INTO public.categories",
        "    (name, slug, description, is_active)",
        "VALUES",
        f"    ({sql_text(category)}, {sql_text(slug)}, NULL, true)",
        "ON CONFLICT (slug)",
        "DO UPDATE SET",
        "    name = EXCLUDED.name,",
        "    is_active = true,",
        "    updated_at = now();",
        "",
    ]

# Subcategories
for category in expected_categories:
    category_slug = category.lower().replace(" ", "-")

    for display_order, subcategory in enumerate(
        expected_subcategories[category], start=1
    ):
        sub_slug = (
            subcategory.lower()
            .replace(" ", "-")
            .replace("/", "-")
        )

        lines += [
            "INSERT INTO public.subcategories",
            "    (category_id, name, slug, description, display_order, is_active)",
            "VALUES",
            "    (",
            f"        (SELECT id FROM public.categories WHERE slug = {sql_text(category_slug)}),",
            f"        {sql_text(subcategory)},",
            f"        {sql_text(sub_slug)},",
            "        NULL,",
            f"        {display_order},",
            "        true",
            "    )",
            "ON CONFLICT (category_id, slug)",
            "DO UPDATE SET",
            "    name = EXCLUDED.name,",
            "    description = EXCLUDED.description,",
            "    display_order = EXCLUDED.display_order,",
            "    is_active = true,",
            "    updated_at = now();",
            "",
        ]

# Products
for product in products:
    category = product["category"]
    subcategory = product["subcategory"]

    category_slug = category.lower().replace(" ", "-")
    sub_slug = (
        subcategory.lower()
        .replace(" ", "-")
        .replace("/", "-")
    )

    name = product.get("name")
    slug = product.get("slug")
    description = product.get("description")
    price = product.get("price")
    sku = product["sku"]
    active = bool(product.get("is_active"))

    lines += [
        "INSERT INTO public.products",
        "    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)",
        "VALUES",
        "    (",
        f"        (SELECT id FROM public.categories WHERE slug = {sql_text(category_slug)}),",
        f"        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = {sql_text(category_slug)} AND s.slug = {sql_text(sub_slug)}),",
        f"        {sql_text(name)},",
        f"        {sql_text(slug)},",
        f"        {sql_text(description)},",
        f"        {sql_num(price)},",
        "        NULL,",
        f"        {sql_text(sku)},",
        f"        {'true' if active else 'false'}",
        "    )",
        "ON CONFLICT (slug)",
        "DO UPDATE SET",
        "    category_id = EXCLUDED.category_id,",
        "    subcategory_id = EXCLUDED.subcategory_id,",
        "    name = EXCLUDED.name,",
        "    description = EXCLUDED.description,",
        "    price = EXCLUDED.price,",
        "    sku = EXCLUDED.sku,",
        "    is_active = EXCLUDED.is_active,",
        "    updated_at = now();",
        "",
    ]

# Inventory for imported products only.
for sku in skus:
    lines += [
        "INSERT INTO public.inventory",
        "    (product_id, quantity, reserved_quantity, low_stock_threshold)",
        "SELECT id, 0, 0, 10",
        f"FROM public.products WHERE sku = {sql_text(sku)}",
        "ON CONFLICT (product_id)",
        "DO NOTHING;",
        "",
    ]

lines += [
    "COMMIT;",
    "",
]

sql = "\n".join(lines)
OUT.write_text(sql)

print("===== PHASE 1 SQL GENERATED =====")
print(f"Products: {len(products)}")
print(f"Categories: {len(expected_categories)}")
print(f"Subcategories: {sum(len(v) for v in expected_subcategories.values())}")
print(f"Unique SKUs: {len(set(skus))}")
print(f"SQL file: {OUT}")
print()
print("Product image inserts: 0")
print("Storage operations: 0")
print("Supabase writes: 0")
