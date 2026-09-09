import argparse
import json
import mimetypes
import os
import subprocess
import sys
import tempfile
import urllib.request
from pathlib import Path
from urllib.parse import urlparse

PREPARED = Path("scripts/ecocarry/prepared/prepared-products.json")
BUCKET = "product-images"
BATCH_SIZE = 50
def load_supabase_url():
    value = os.environ.get("NEXT_PUBLIC_SUPABASE_URL", "").strip()

    if value:
        return value.rstrip("/")

    env_file = Path(".env.local")

    if env_file.exists():
        for line in env_file.read_text().splitlines():
            line = line.strip()

            if not line or line.startswith("#"):
                continue

            if line.startswith("NEXT_PUBLIC_SUPABASE_URL="):
                return line.split("=", 1)[1].strip().strip('"').strip("'").rstrip("/")

    return ""


PROJECT_URL = load_supabase_url()


def fail(message):
    print(f"\nERROR: {message}")
    sys.exit(1)


def run(command):
    result = subprocess.run(
        command,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    if result.returncode != 0:
        print(result.stdout)
        fail(f"Command failed: {' '.join(command)}")
    return result.stdout


def load_products():
    if not PREPARED.exists():
        fail(f"Missing {PREPARED}")

    data = json.loads(PREPARED.read_text())

    if not isinstance(data, list):
        fail("prepared-products.json must contain a list")

    return data


def validate_batch(products, batch_number):
    start = (batch_number - 1) * BATCH_SIZE
    end = min(start + BATCH_SIZE, len(products))
    batch = products[start:end]

    if not batch:
        fail(f"No products found for batch {batch_number}")

    errors = []
    skus = set()

    for position, product in enumerate(batch, start=start + 1):
        sku = product.get("sku")

        if not sku:
            errors.append(f"#{position}: missing SKU")

        if sku in skus:
            errors.append(f"#{position}: duplicate SKU {sku}")

        skus.add(sku)

        images = product.get("images")

        if not isinstance(images, list) or not images:
            errors.append(f"{sku}: no valid images")
            continue

        for image_number, image in enumerate(images, start=1):
            src = image.get("src") if isinstance(image, dict) else None

            if not src:
                errors.append(f"{sku}: image #{image_number} has no src")
                continue

            parsed = urlparse(src)

            if parsed.scheme not in {"http", "https"}:
                errors.append(f"{sku}: image #{image_number} invalid URL")

    if errors:
        print("\n===== VALIDATION ERRORS =====")
        for error in errors:
            print(f"- {error}")
        fail("Batch validation failed")

    return batch, start + 1, end


def sql_escape(value):
    if value is None:
        return "NULL"
    return "'" + str(value).replace("'", "''") + "'"


def get_product_ids(batch):
    skus = [product["sku"] for product in batch]

    values = ",".join(sql_escape(sku) for sku in skus)

    sql = f"""
select sku, id
from public.products
where sku in ({values})
order by sku;
"""

    output = run(
        [
            "npx",
            "supabase",
            "db",
            "query",
            "--linked",
            sql,
        ]
    )

    mapping = {}

    for line in output.splitlines():
        line = line.strip()

        if not line or line.startswith("Initialising") or line.startswith("─"):
            continue

        if "│" not in line:
            continue

        parts = [p.strip() for p in line.split("│") if p.strip()]

        if len(parts) == 2 and parts[0] != "sku":
            mapping[parts[0]] = parts[1]

    missing = [sku for sku in skus if sku not in mapping]

    if missing:
        fail("Products missing from Supabase: " + ", ".join(missing))

    return mapping


def download_image(url, destination):
    request = urllib.request.Request(
        url,
        headers={
            "User-Agent": "Mozilla/5.0 EcoCarry-Catalog-Migration",
            "Accept": "image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8",
        },
    )

    with urllib.request.urlopen(request, timeout=60) as response:
        content_type = response.headers.get_content_type()

        if not content_type.startswith("image/"):
            fail(f"Source is not an image: {url} ({content_type})")

        data = response.read()

    if not data:
        fail(f"Downloaded empty image: {url}")

    destination.write_bytes(data)

    return content_type


def extension_for(url, content_type):
    extension = Path(urlparse(url).path).suffix.lower()

    if extension in {".jpg", ".jpeg", ".png", ".webp", ".gif"}:
        return extension

    guessed = mimetypes.guess_extension(content_type)

    if guessed in {".jpg", ".jpeg", ".png", ".webp", ".gif"}:
        return guessed

    return ".jpg"


def upload(local_file, destination, content_type):
    run(
        [
            "npx",
            "supabase",
            "storage",
            "cp",
            "--experimental",
            "--linked",
            "--content-type",
            content_type,
            "--cache-control",
            "max-age=31536000",
            str(local_file),
            f"ss:///{BUCKET}/{destination}",
        ]
    )


def build_insert_sql(rows):
    if not rows:
        raise RuntimeError("No image rows were generated")

    values = []

    for row in rows:
        values.append(
            "("
            + ", ".join(
                [
                    sql_escape(row["product_id"]),
                    sql_escape(row["image_url"]),
                    sql_escape(row["alt_text"]),
                    str(row["display_order"]),
                ]
            )
            + ")"
        )

    return (
        "begin;\n"
        "insert into public.product_images "
        "(product_id, image_url, alt_text, display_order)\n"
        "select v.product_id::uuid, v.image_url, v.alt_text, v.display_order\n"
        "from (values\n"
        + ",\n".join(values)
        + ") as v(product_id, image_url, alt_text, display_order)\n"
        "where not exists (\n"
        "  select 1 from public.product_images pi\n"
        "  where pi.product_id = v.product_id::uuid\n"
        "    and pi.image_url = v.image_url\n"
        ");\n"
        "commit;"
    )


def build_rows_from_catalog(batch, product_ids):
    rows = []

    for product in batch:
        product_id = product_ids[product["sku"]]

        for image_index, image in enumerate(product["images"]):
            source_url = image["src"]

            extension = Path(urlparse(source_url).path).suffix.lower()

            if extension not in {".jpg", ".jpeg", ".png", ".webp", ".gif"}:
                extension = ".jpg"

            filename = f"{image_index:03d}{extension}"

            storage_path = f"products/{product_id}/{filename}"

            public_url = (
                f"{PROJECT_URL}/storage/v1/object/public/"
                f"{BUCKET}/{storage_path}"
            )

            rows.append(
                {
                    "product_id": product_id,
                    "image_url": public_url,
                    "alt_text": image.get("alt") or product["name"],
                    "display_order": image_index,
                }
            )

    return rows

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--batch", type=int, default=1)
    parser.add_argument(
        "--execute",
        action="store_true",
        help="Execute image migration",
    )

    args = parser.parse_args()

    if args.batch < 1:
        fail("Batch number must be >= 1")

    if not PROJECT_URL:
        fail("NEXT_PUBLIC_SUPABASE_URL is missing from environment")

    products = load_products()
    batch, start, end = validate_batch(products, args.batch)

    image_total = sum(len(p.get("images", [])) for p in batch)

    print()
    print("===== ECOCARRY IMAGE MIGRATION =====")
    print(f"Batch:                   {args.batch}")
    print(f"Product range:           {start}-{end}")
    print(f"Products in batch:       {len(batch)}")
    print(f"Images to process:       {image_total}")

    if not args.execute:
        print()
        print("RESULT: PASS")
        print("MODE: DRY RUN")
        print("SUPABASE DATABASE WRITES: 0")
        print("STORAGE UPLOADS: 0")
        return

    print()
    print("===== RESOLVING PRODUCT IDS =====")

    product_ids = get_product_ids(batch)

    if len(product_ids) != len(batch):
        fail(
            f"Resolved {len(product_ids)} products, "
            f"expected {len(batch)}"
        )

    print(f"Resolved products:       {len(product_ids)}")

    print()
    print("===== BUILDING DATABASE ROWS FROM EXISTING STORAGE =====")

    rows = build_rows_from_catalog(batch, product_ids)

    expected_images = sum(len(p.get("images", [])) for p in batch)

    if len(rows) != expected_images:
        fail(
            f"Generated {len(rows)} rows but expected "
            f"{expected_images}"
        )

    print(f"Database rows prepared:  {len(rows)}")
    print("Storage uploads:         0")
    print("Downloads:               0")

    print()
    print("===== DATABASE INSERT =====")

    sql = build_insert_sql(rows)

    run(
        [
            "npx",
            "supabase",
            "db",
            "query",
            "--linked",
            sql,
        ]
    )

    print()
    print("===== MIGRATION COMPLETE =====")
    print(f"Products processed:      {len(batch)}")
    print(f"Images inserted:         {len(rows)}")
    print("Storage uploads:         0")
    print("Downloads:               0")
    print("Existing image rows:     preserved")
    print("RESULT: PASS")

    print()

if __name__ == "__main__":
    main()
