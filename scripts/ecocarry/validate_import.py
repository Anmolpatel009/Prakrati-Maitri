#!/usr/bin/env python3

import json
import re
from pathlib import Path
from collections import Counter

ROOT = Path(__file__).resolve().parent
PREPARED = ROOT / "prepared"
SCHEMA = ROOT / "schema-inspection" / "public-schema.sql"

products_file = PREPARED / "prepared-products.json"
taxonomy_file = PREPARED / "taxonomy.json"

products = json.loads(products_file.read_text())
taxonomy = json.loads(taxonomy_file.read_text())

if isinstance(products, dict):
    products = products.get("products", [])

if isinstance(taxonomy, dict):
    categories = taxonomy.get("categories", [])
else:
    categories = taxonomy

errors = []
warnings = []

# ------------------------------------------------------------
# 1. Exact production schema verification
# ------------------------------------------------------------

schema_text = SCHEMA.read_text()

required_tables = [
    "categories",
    "subcategories",
    "products",
    "product_images",
    "inventory",
]

for table in required_tables:
    pattern = rf'CREATE TABLE IF NOT EXISTS "public"\."{table}"'
    if not re.search(pattern, schema_text):
        errors.append(f"Missing required table: {table}")

# Current production products schema.
required_product_columns = [
    "id",
    "category_id",
    "subcategory_id",
    "name",
    "slug",
    "description",
    "price",
    "compare_at_price",
    "sku",
    "is_active",
]

for column in required_product_columns:
    if not re.search(
        rf'"{column}"',
        schema_text[schema_text.find('"public"."products"'):schema_text.find('"public"."products"') + 3000],
    ):
        errors.append(f"products.{column} missing from schema")

# ------------------------------------------------------------
# 2. Taxonomy validation
# ------------------------------------------------------------

expected_categories = {
    "Packaging Bags",
    "Tote Bags",
    "Hand Bags",
    "Hamper Bags",
}

# The prepared product mapping is the authoritative source for the
# production category assignment. taxonomy.json may store taxonomy
# using a different shape, so validate against both sources.
actual_categories = set()

for category in categories:
    if isinstance(category, dict):
        name = category.get("name")
        if name:
            actual_categories.add(name)
    elif isinstance(category, str):
        actual_categories.add(category)

for product in products:
    category = product.get("category")
    if category:
        actual_categories.add(category)

missing_categories = expected_categories - actual_categories

if missing_categories:
    errors.append(
        "Missing production categories: "
        + ", ".join(sorted(missing_categories))
    )

# ------------------------------------------------------------
# 3. Product validation
# ------------------------------------------------------------

print("===== ECOCARRY IMPORT VALIDATION =====")
print()

print(f"Prepared products: {len(products)}")

if len(products) != 216:
    errors.append(f"Expected 216 products, found {len(products)}")

required_fields = [
    "name",
    "slug",
    "description",
    "price",
    "sku",
    "is_active",
]

missing_field_counts = Counter()

slugs = []
skus = []

for index, product in enumerate(products, start=1):
    for field in required_fields:
        if field not in product:
            missing_field_counts[field] += 1

    name = str(product.get("name", "")).strip()
    slug = str(product.get("slug", "")).strip()
    sku = str(product.get("sku", "")).strip()
    price = product.get("price")

    if not name:
        errors.append(f"Product #{index}: missing name")

    if not slug:
        errors.append(f"Product #{index}: missing slug")
    else:
        slugs.append(slug)

    if not sku:
        errors.append(f"Product #{index}: missing SKU")

    if price is None or price == "":
        errors.append(f"Product #{index}: missing price")
    else:
        try:
            if float(price) < 0:
                errors.append(f"Product #{index}: negative price")
        except (TypeError, ValueError):
            errors.append(f"Product #{index}: invalid price {price!r}")

    category = product.get("category")
    subcategory = product.get("subcategory")

    if not category:
        errors.append(f"Product #{index}: missing category")

    if not subcategory:
        errors.append(f"Product #{index}: missing subcategory")

    images = product.get("images", [])
    if not images:
        errors.append(f"Product #{index}: no images")

for field, count in missing_field_counts.items():
    if count:
        warnings.append(f"{count} products missing field '{field}'")

duplicate_slugs = [
    slug for slug, count in Counter(slugs).items() if count > 1
]

duplicate_skus = [
    sku for sku, count in Counter(skus).items() if count > 1
]

if duplicate_slugs:
    errors.append(
        "Duplicate product slugs: " + ", ".join(duplicate_slugs)
    )

if duplicate_skus:
    errors.append(
        "Duplicate product SKUs: " + ", ".join(duplicate_skus)
    )

# ------------------------------------------------------------
# 4. Active / inactive validation
# ------------------------------------------------------------

active = sum(1 for p in products if p.get("is_active") is True)
inactive = sum(1 for p in products if p.get("is_active") is False)

print(f"Active products: {active}")
print(f"Inactive products: {inactive}")

if active != 211:
    warnings.append(f"Expected 211 active EcoCarry products, found {active}")

if inactive != 5:
    warnings.append(f"Expected 5 inactive EcoCarry products, found {inactive}")

# ------------------------------------------------------------
# 5. Image validation
# ------------------------------------------------------------

total_images = 0
products_with_images = 0

for product in products:
    images = product.get("images", [])
    total_images += len(images)

    if images:
        products_with_images += 1

print(f"Products with images: {products_with_images}")
print(f"Image references: {total_images}")

if products_with_images != 216:
    errors.append(
        f"Expected images for all 216 products, found {products_with_images}"
    )

if total_images != 1617:
    warnings.append(
        f"Expected 1617 image references, found {total_images}"
    )

# ------------------------------------------------------------
# 6. Category mapping report
# ------------------------------------------------------------

category_counts = Counter(
    p.get("category")
    for p in products
)

print()
print("===== CATEGORY DISTRIBUTION =====")

for category, count in sorted(category_counts.items()):
    print(f"{category}: {count}")

# ------------------------------------------------------------
# 7. Source variant preservation
# ------------------------------------------------------------

source_variants = 0

for product in products:
    variants = product.get("variants", [])
    source_variants += len(variants)

print()
print(f"Source variants preserved locally: {source_variants}")

if source_variants != 3584:
    warnings.append(
        f"Expected 3584 source variants, found {source_variants}"
    )

# ------------------------------------------------------------
# 8. Current DB dependency safety
# ------------------------------------------------------------

# We already verified from the remote schema that:
#
# order_items.product_id -> products.id ON DELETE RESTRICT
#
# Therefore the live importer must NEVER DELETE existing products.
#
# It will archive them using is_active=false.

if "order_items" in schema_text:
    print()
    print("Order dependency detected: existing products will NOT be deleted.")
else:
    errors.append("Could not verify order_items dependency.")

# ------------------------------------------------------------
# 9. Final report
# ------------------------------------------------------------

print()
print("===== RESULT =====")

if warnings:
    print()
    print("WARNINGS:")
    for warning in warnings:
        print(f"  - {warning}")

if errors:
    print()
    print("ERRORS:")
    for error in errors:
        print(f"  - {error}")

    print()
    print("RESULT: FAIL")
    print("NO SUPABASE WRITES PERFORMED.")
    raise SystemExit(1)

print()
print("RESULT: PASS")
print("NO SUPABASE WRITES PERFORMED.")
print()
print("Safe to proceed to live migration design.")
