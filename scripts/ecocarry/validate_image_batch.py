import json
import sys
from pathlib import Path
from urllib.parse import urlparse

PREPARED = Path("scripts/ecocarry/prepared/prepared-products.json")
BATCH_SIZE = 50


def main():
    if not PREPARED.exists():
        print(f"ERROR: missing {PREPARED}")
        sys.exit(1)

    products = json.loads(PREPARED.read_text())

    if not isinstance(products, list):
        print("ERROR: prepared-products.json is not a list")
        sys.exit(1)

    batch = products[:BATCH_SIZE]

    errors = []
    image_refs = []
    product_skus = set()

    for index, product in enumerate(batch, start=1):
        sku = product.get("sku")
        name = product.get("name")

        if not sku:
            errors.append(f"Product #{index}: missing SKU")
            continue

        if sku in product_skus:
            errors.append(f"Product #{index}: duplicate SKU {sku}")
        product_skus.add(sku)

        images = product.get("images")

        if not isinstance(images, list):
            errors.append(f"{sku}: images is not a list")
            continue

        if not images:
            errors.append(f"{sku}: no images")

        seen_product_images = set()

        for image_index, image in enumerate(images, start=1):
            src = image.get("src") if isinstance(image, dict) else None

            if not src:
                errors.append(
                    f"{sku}: image #{image_index} has no src"
                )
                continue

            parsed = urlparse(src)

            if parsed.scheme not in {"http", "https"}:
                errors.append(
                    f"{sku}: image #{image_index} invalid URL"
                )
                continue

            if src in seen_product_images:
                errors.append(
                    f"{sku}: duplicate image URL #{image_index}"
                )

            seen_product_images.add(src)
            image_refs.append((sku, src))

    all_urls = [src for _, src in image_refs]
    duplicate_urls = len(all_urls) - len(set(all_urls))

    print("\n===== ECOCARRY IMAGE BATCH 1 DRY RUN =====")
    print(f"Prepared products:       {len(products)}")
    print(f"Batch size:              {len(batch)}")
    print(f"Products checked:        {len(product_skus)}")
    print(f"Images to migrate:       {len(image_refs)}")
    print(f"Unique image URLs:       {len(set(all_urls))}")
    print(f"Duplicate image URLs:    {duplicate_urls}")
    print(f"Validation errors:       {len(errors)}")

    print("\n===== PRODUCTS =====")
    for i, product in enumerate(batch, start=1):
        print(
            f"{i:02d}. {product.get('sku')} | "
            f"{product.get('name')} | "
            f"{len(product.get('images', []))} images"
        )

    if errors:
        print("\n===== ERRORS =====")
        for error in errors:
            print(f"- {error}")

        print("\nRESULT: FAIL")
        sys.exit(1)

    print("\n===== SAMPLE IMAGE URLS =====")
    for sku, src in image_refs[:10]:
        print(f"{sku} -> {src}")

    print("\nRESULT: PASS")
    print("NO SUPABASE WRITES")
    print("NO STORAGE UPLOADS")


if __name__ == "__main__":
    main()
