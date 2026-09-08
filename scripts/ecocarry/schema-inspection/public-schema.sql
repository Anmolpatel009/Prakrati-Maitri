


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE SCHEMA IF NOT EXISTS "public";


ALTER SCHEMA "public" OWNER TO "pg_database_owner";


COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE OR REPLACE FUNCTION "public"."adjust_inventory"("p_product_id" "uuid", "p_quantity_change" integer, "p_reason" "text") RETURNS integer
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    current_quantity integer;
    new_quantity integer;
    admin_user_id uuid;
BEGIN

    -- Authorization
    IF NOT public.is_admin() THEN
        RAISE EXCEPTION 'Not authorized';
    END IF;

    -- Basic validation
    IF p_quantity_change = 0 THEN
        RAISE EXCEPTION 'Quantity change cannot be zero';
    END IF;

    IF p_reason IS NULL OR trim(p_reason) = '' THEN
        RAISE EXCEPTION 'Adjustment reason is required';
    END IF;

    admin_user_id := auth.uid();

    -- Lock the inventory row.
    SELECT quantity
    INTO current_quantity
    FROM public.inventory
    WHERE product_id = p_product_id
    FOR UPDATE;

    IF current_quantity IS NULL THEN
        RAISE EXCEPTION 'Inventory record not found';
    END IF;

    new_quantity := current_quantity + p_quantity_change;

    -- Never allow stock to become negative.
    IF new_quantity < 0 THEN
        RAISE EXCEPTION
            'Insufficient stock. Current quantity: %, requested change: %',
            current_quantity,
            p_quantity_change;
    END IF;

    -- Update inventory.
    UPDATE public.inventory
    SET
        quantity = new_quantity,
        updated_at = now()
    WHERE product_id = p_product_id;

    -- Record audit history.
    INSERT INTO public.inventory_adjustments (
        product_id,
        quantity_change,
        quantity_before,
        quantity_after,
        reason,
        created_by
    )
    VALUES (
        p_product_id,
        p_quantity_change,
        current_quantity,
        new_quantity,
        trim(p_reason),
        admin_user_id
    );

    RETURN new_quantity;

END;
$$;


ALTER FUNCTION "public"."adjust_inventory"("p_product_id" "uuid", "p_quantity_change" integer, "p_reason" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_order"("p_items" "jsonb", "p_shipping" "jsonb") RETURNS "uuid"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_order_id uuid;
  v_user_id uuid;
  v_subtotal numeric := 0;
  v_shipping_fee numeric := 0;
  v_total numeric := 0;

  v_item jsonb;
  v_product_id uuid;
  v_quantity integer;

  v_product_name text;
  v_product_sku text;
  v_price numeric;
  v_stock integer;
  v_line_total numeric;
begin
  -- Require authenticated user
  v_user_id := auth.uid();

  if v_user_id is null then
    raise exception 'You must be logged in.';
  end if;

  -- Basic validation
  if p_items is null or jsonb_array_length(p_items) = 0 then
    raise exception 'Cart is empty.';
  end if;

  -- Calculate subtotal from DATABASE prices
  for v_item in
    select * from jsonb_array_elements(p_items)
  loop

    v_product_id := (v_item->>'productId')::uuid;
    v_quantity := (v_item->>'quantity')::integer;

    if v_quantity <= 0 then
      raise exception 'Invalid quantity.';
    end if;

    -- Lock inventory row while checking stock
    select
      p.name,
      p.sku,
      p.price,
      i.quantity - i.reserved_quantity
    into
      v_product_name,
      v_product_sku,
      v_price,
      v_stock
    from products p
    join inventory i
      on i.product_id = p.id
    where p.id = v_product_id
      and p.is_active = true
    for update of i;

    if not found then
      raise exception 'Product is unavailable.';
    end if;

    if v_quantity > v_stock then
      raise exception
        'Not enough stock for %.',
        v_product_name;
    end if;

    v_line_total := v_price * v_quantity;
    v_subtotal := v_subtotal + v_line_total;

  end loop;

  -- MVP shipping = zero
  v_shipping_fee := 0;
  v_total := v_subtotal + v_shipping_fee;

  -- Create order
  insert into orders (
    user_id,
    status,
    subtotal,
    shipping_fee,
    total,
    shipping_first_name,
    shipping_last_name,
    shipping_phone,
    shipping_address,
    shipping_city,
    shipping_state,
    shipping_country,
    shipping_postal_code
  )
  values (
    v_user_id,
    'pending',
    v_subtotal,
    v_shipping_fee,
    v_total,
    p_shipping->>'firstName',
    p_shipping->>'lastName',
    p_shipping->>'phone',
    p_shipping->>'address',
    p_shipping->>'city',
    p_shipping->>'state',
    p_shipping->>'country',
    p_shipping->>'postalCode'
  )
  returning id into v_order_id;

  -- Create order items + reserve stock
  for v_item in
    select * from jsonb_array_elements(p_items)
  loop

    v_product_id := (v_item->>'productId')::uuid;
    v_quantity := (v_item->>'quantity')::integer;

    select
      p.name,
      p.sku,
      p.price
    into
      v_product_name,
      v_product_sku,
      v_price
    from products p
    where p.id = v_product_id
      and p.is_active = true;

    v_line_total := v_price * v_quantity;

    insert into order_items (
      order_id,
      product_id,
      product_name,
      product_sku,
      quantity,
      unit_price,
      line_total
    )
    values (
      v_order_id,
      v_product_id,
      v_product_name,
      v_product_sku,
      v_quantity,
      v_price,
      v_line_total
    );

    update inventory
    set reserved_quantity = reserved_quantity + v_quantity,
        updated_at = now()
    where product_id = v_product_id;

  end loop;

  return v_order_id;
end;
$$;


ALTER FUNCTION "public"."create_order"("p_items" "jsonb", "p_shipping" "jsonb") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_order_with_payment"("p_items" "jsonb", "p_shipping" "jsonb", "p_payment_method" "text") RETURNS "uuid"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
  v_order_id uuid;
  v_user_id uuid;

  v_subtotal numeric := 0;
  v_shipping_fee numeric := 0;
  v_total numeric := 0;

  v_item jsonb;
  v_product_id uuid;
  v_quantity integer;

  v_product_name text;
  v_product_sku text;
  v_price numeric;
  v_stock integer;
  v_line_total numeric;

  v_order_status text;
  v_payment_status text;
BEGIN

  -- =====================================================
  -- AUTHENTICATION
  -- =====================================================

  v_user_id := auth.uid();

  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'You must be logged in.';
  END IF;


  -- =====================================================
  -- PAYMENT METHOD VALIDATION
  -- =====================================================

  IF p_payment_method IS NULL
     OR p_payment_method NOT IN ('online', 'cod') THEN

    RAISE EXCEPTION
      'Invalid payment method. Use online or cod.';

  END IF;


  -- =====================================================
  -- CART VALIDATION
  -- =====================================================

  IF p_items IS NULL
     OR jsonb_array_length(p_items) = 0 THEN

    RAISE EXCEPTION 'Cart is empty.';

  END IF;


  -- =====================================================
  -- INITIAL ORDER / PAYMENT STATUS
  -- =====================================================

  IF p_payment_method = 'cod' THEN

    v_order_status := 'confirmed';
    v_payment_status := 'cod_pending';

  ELSE

    v_order_status := 'pending';
    v_payment_status := 'pending';

  END IF;


  -- =====================================================
  -- CALCULATE SUBTOTAL FROM DATABASE PRICES
  -- =====================================================

  FOR v_item IN
    SELECT *
    FROM jsonb_array_elements(p_items)
  LOOP

    v_product_id :=
      (v_item->>'productId')::uuid;

    v_quantity :=
      (v_item->>'quantity')::integer;


    IF v_quantity <= 0 THEN
      RAISE EXCEPTION 'Invalid quantity.';
    END IF;


    -- =================================================
    -- LOCK INVENTORY WHILE CHECKING STOCK
    -- =================================================

    SELECT
      p.name,
      p.sku,
      p.price,
      i.quantity - i.reserved_quantity

    INTO
      v_product_name,
      v_product_sku,
      v_price,
      v_stock

    FROM products p

    JOIN inventory i
      ON i.product_id = p.id

    WHERE p.id = v_product_id
      AND p.is_active = true

    FOR UPDATE OF i;


    IF NOT FOUND THEN
      RAISE EXCEPTION
        'Product is unavailable.';
    END IF;


    IF v_quantity > v_stock THEN
      RAISE EXCEPTION
        'Not enough stock for %.',
        v_product_name;
    END IF;


    -- Server-authoritative price
    v_line_total :=
      v_price * v_quantity;

    v_subtotal :=
      v_subtotal + v_line_total;

  END LOOP;


  -- =====================================================
  -- SHIPPING
  -- =====================================================

  v_shipping_fee := 0;

  v_total :=
    v_subtotal + v_shipping_fee;


  -- =====================================================
  -- CREATE ORDER
  -- =====================================================

  INSERT INTO orders (
    user_id,
    status,

    payment_method,
    payment_status,
    payment_id,

    subtotal,
    shipping_fee,
    total,

    shipping_first_name,
    shipping_last_name,
    shipping_phone,
    shipping_address,
    shipping_city,
    shipping_state,
    shipping_country,
    shipping_postal_code
  )

  VALUES (
    v_user_id,
    v_order_status,

    p_payment_method,
    v_payment_status,
    NULL,

    v_subtotal,
    v_shipping_fee,
    v_total,

    p_shipping->>'firstName',
    p_shipping->>'lastName',
    p_shipping->>'phone',
    p_shipping->>'address',
    p_shipping->>'city',
    p_shipping->>'state',
    p_shipping->>'country',
    p_shipping->>'postalCode'
  )

  RETURNING id
  INTO v_order_id;


  -- =====================================================
  -- CREATE ORDER ITEMS + RESERVE INVENTORY
  -- =====================================================

  FOR v_item IN
    SELECT *
    FROM jsonb_array_elements(p_items)
  LOOP

    v_product_id :=
      (v_item->>'productId')::uuid;

    v_quantity :=
      (v_item->>'quantity')::integer;


    -- Get authoritative product data again

    SELECT
      p.name,
      p.sku,
      p.price

    INTO
      v_product_name,
      v_product_sku,
      v_price

    FROM products p

    WHERE p.id = v_product_id
      AND p.is_active = true;


    IF NOT FOUND THEN
      RAISE EXCEPTION
        'Product is unavailable.';
    END IF;


    v_line_total :=
      v_price * v_quantity;


    INSERT INTO order_items (
      order_id,
      product_id,
      product_name,
      product_sku,
      quantity,
      unit_price,
      line_total
    )

    VALUES (
      v_order_id,
      v_product_id,
      v_product_name,
      v_product_sku,
      v_quantity,
      v_price,
      v_line_total
    );


    -- Reserve inventory

    UPDATE inventory

    SET
      reserved_quantity =
        reserved_quantity + v_quantity,

      updated_at = now()

    WHERE product_id = v_product_id;

  END LOOP;


  RETURN v_order_id;

END;
$$;


ALTER FUNCTION "public"."create_order_with_payment"("p_items" "jsonb", "p_shipping" "jsonb", "p_payment_method" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_product_with_inventory"("p_category_id" "uuid", "p_subcategory_id" "uuid", "p_name" "text", "p_slug" "text", "p_description" "text", "p_price" numeric, "p_compare_at_price" numeric, "p_sku" "text", "p_is_active" boolean, "p_quantity" integer) RETURNS "uuid"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
DECLARE
    new_product_id uuid;
BEGIN
    -- Authorization
    IF NOT public.is_admin() THEN
        RAISE EXCEPTION 'Not authorized';
    END IF;

    -- Product
    INSERT INTO public.products (
        category_id,
        subcategory_id,
        name,
        slug,
        description,
        price,
        compare_at_price,
        sku,
        is_active
    )
    VALUES (
        p_category_id,
        p_subcategory_id,
        p_name,
        p_slug,
        p_description,
        p_price,
        p_compare_at_price,
        NULLIF(p_sku, ''),
        p_is_active
    )
    RETURNING id INTO new_product_id;

    -- Inventory
    INSERT INTO public.inventory (
        product_id,
        quantity,
        reserved_quantity
    )
    VALUES (
        new_product_id,
        p_quantity,
        0
    );

    RETURN new_product_id;
END;
$$;


ALTER FUNCTION "public"."create_product_with_inventory"("p_category_id" "uuid", "p_subcategory_id" "uuid", "p_name" "text", "p_slug" "text", "p_description" "text", "p_price" numeric, "p_compare_at_price" numeric, "p_sku" "text", "p_is_active" boolean, "p_quantity" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_admin"() RETURNS boolean
    LANGUAGE "sql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.admin_users
    WHERE user_id = auth.uid()
  );
$$;


ALTER FUNCTION "public"."is_admin"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."set_bulk_order_enquiry_updated_at"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
begin
  new.updated_at = now();
  return new;
end;
$$;


ALTER FUNCTION "public"."set_bulk_order_enquiry_updated_at"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."update_storefront_cms_updated_at"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
begin
  new.updated_at = now();
  return new;
end;
$$;


ALTER FUNCTION "public"."update_storefront_cms_updated_at"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."admin_users" (
    "user_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."admin_users" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."bulk_order_enquiries" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "mobile" "text" NOT NULL,
    "email" "text",
    "business_name" "text",
    "category_id" "uuid",
    "product_id" "uuid",
    "quantity" integer NOT NULL,
    "purpose" "text" NOT NULL,
    "message" "text",
    "status" "text" DEFAULT 'new'::"text" NOT NULL,
    "admin_notes" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "bulk_order_enquiries_quantity_check" CHECK (("quantity" > 0)),
    CONSTRAINT "bulk_order_enquiries_status_check" CHECK (("status" = ANY (ARRAY['new'::"text", 'contacted'::"text", 'in_discussion'::"text", 'converted'::"text", 'closed'::"text"])))
);


ALTER TABLE "public"."bulk_order_enquiries" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."categories" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "slug" "text" NOT NULL,
    "description" "text",
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "image_url" "text"
);


ALTER TABLE "public"."categories" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."homepage_sections" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "section_key" "text" NOT NULL,
    "section_type" "text" NOT NULL,
    "eyebrow" "text",
    "title" "text",
    "description" "text",
    "cta_text" "text",
    "cta_url" "text",
    "media_id" "uuid",
    "display_order" integer DEFAULT 0 NOT NULL,
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."homepage_sections" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."inventory" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "product_id" "uuid" NOT NULL,
    "quantity" integer DEFAULT 0 NOT NULL,
    "reserved_quantity" integer DEFAULT 0 NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "low_stock_threshold" integer DEFAULT 10 NOT NULL,
    CONSTRAINT "inventory_low_stock_threshold_check" CHECK (("low_stock_threshold" >= 0)),
    CONSTRAINT "inventory_quantity_check" CHECK (("quantity" >= 0)),
    CONSTRAINT "inventory_reserved_quantity_check" CHECK (("reserved_quantity" >= 0)),
    CONSTRAINT "inventory_reserved_valid" CHECK (("reserved_quantity" <= "quantity"))
);


ALTER TABLE "public"."inventory" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."inventory_adjustments" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "product_id" "uuid" NOT NULL,
    "quantity_change" integer NOT NULL,
    "quantity_before" integer NOT NULL,
    "quantity_after" integer NOT NULL,
    "reason" "text" NOT NULL,
    "created_by" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "inventory_adjustments_after_nonnegative" CHECK (("quantity_after" >= 0))
);


ALTER TABLE "public"."inventory_adjustments" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."order_items" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "order_id" "uuid" NOT NULL,
    "product_id" "uuid" NOT NULL,
    "product_name" "text" NOT NULL,
    "product_sku" "text",
    "quantity" integer NOT NULL,
    "unit_price" numeric(12,2) NOT NULL,
    "line_total" numeric(12,2) NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "order_items_line_total_check" CHECK (("line_total" >= (0)::numeric)),
    CONSTRAINT "order_items_quantity_check" CHECK (("quantity" > 0)),
    CONSTRAINT "order_items_unit_price_check" CHECK (("unit_price" >= (0)::numeric))
);


ALTER TABLE "public"."order_items" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."orders" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "status" "text" DEFAULT 'pending'::"text" NOT NULL,
    "subtotal" numeric(12,2) NOT NULL,
    "shipping_fee" numeric(12,2) DEFAULT 0 NOT NULL,
    "total" numeric(12,2) NOT NULL,
    "shipping_first_name" "text" NOT NULL,
    "shipping_last_name" "text" NOT NULL,
    "shipping_phone" "text" NOT NULL,
    "shipping_address" "text" NOT NULL,
    "shipping_city" "text" NOT NULL,
    "shipping_state" "text" NOT NULL,
    "shipping_country" "text" NOT NULL,
    "shipping_postal_code" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "payment_method" "text",
    "payment_status" "text" DEFAULT 'pending'::"text",
    "payment_id" "text",
    CONSTRAINT "orders_shipping_fee_check" CHECK (("shipping_fee" >= (0)::numeric)),
    CONSTRAINT "orders_status_check" CHECK (("status" = ANY (ARRAY['pending'::"text", 'confirmed'::"text", 'processing'::"text", 'shipped'::"text", 'delivered'::"text", 'cancelled'::"text"]))),
    CONSTRAINT "orders_subtotal_check" CHECK (("subtotal" >= (0)::numeric)),
    CONSTRAINT "orders_total_check" CHECK (("total" >= (0)::numeric))
);


ALTER TABLE "public"."orders" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."product_images" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "product_id" "uuid" NOT NULL,
    "image_url" "text" NOT NULL,
    "alt_text" "text",
    "display_order" integer DEFAULT 0 NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "product_images_display_order_check" CHECK (("display_order" >= 0))
);


ALTER TABLE "public"."product_images" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."products" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "category_id" "uuid",
    "name" "text" NOT NULL,
    "slug" "text" NOT NULL,
    "description" "text",
    "price" numeric(12,2) NOT NULL,
    "compare_at_price" numeric(12,2),
    "sku" "text",
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "subcategory_id" "uuid",
    CONSTRAINT "products_compare_at_price_check" CHECK (("compare_at_price" >= (0)::numeric)),
    CONSTRAINT "products_price_check" CHECK (("price" >= (0)::numeric))
);


ALTER TABLE "public"."products" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."profiles" (
    "id" "uuid" NOT NULL,
    "first_name" "text",
    "last_name" "text",
    "phone" "text",
    "country" "text" DEFAULT 'India'::"text",
    "onboarding_complete" boolean DEFAULT false NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."profiles" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."storefront_media" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "media_type" "text" NOT NULL,
    "title" "text" NOT NULL,
    "file_url" "text" NOT NULL,
    "thumbnail_url" "text",
    "alt_text" "text",
    "mime_type" "text",
    "file_size" bigint,
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "storefront_media_media_type_check" CHECK (("media_type" = ANY (ARRAY['image'::"text", 'video'::"text"])))
);


ALTER TABLE "public"."storefront_media" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."storefront_nav_cards" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "card_type" "text" NOT NULL,
    "category_id" "uuid",
    "subcategory_id" "uuid",
    "product_id" "uuid",
    "title" "text" NOT NULL,
    "image_url" "text",
    "href" "text",
    "is_active" boolean DEFAULT true NOT NULL,
    "display_order" integer DEFAULT 0 NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "storefront_nav_cards_card_type_check" CHECK (("card_type" = ANY (ARRAY['category'::"text", 'subcategory'::"text", 'product'::"text", 'custom'::"text"]))),
    CONSTRAINT "storefront_nav_cards_source_check" CHECK (((("card_type" = 'category'::"text") AND ("category_id" IS NOT NULL) AND ("subcategory_id" IS NULL) AND ("product_id" IS NULL)) OR (("card_type" = 'subcategory'::"text") AND ("subcategory_id" IS NOT NULL) AND ("category_id" IS NULL) AND ("product_id" IS NULL)) OR (("card_type" = 'product'::"text") AND ("product_id" IS NOT NULL) AND ("category_id" IS NULL) AND ("subcategory_id" IS NULL)) OR (("card_type" = 'custom'::"text") AND ("category_id" IS NULL) AND ("subcategory_id" IS NULL) AND ("product_id" IS NULL))))
);


ALTER TABLE "public"."storefront_nav_cards" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."subcategories" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "category_id" "uuid" NOT NULL,
    "name" "text" NOT NULL,
    "slug" "text" NOT NULL,
    "description" "text",
    "display_order" integer DEFAULT 0 NOT NULL,
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."subcategories" OWNER TO "postgres";


ALTER TABLE ONLY "public"."admin_users"
    ADD CONSTRAINT "admin_users_pkey" PRIMARY KEY ("user_id");



ALTER TABLE ONLY "public"."bulk_order_enquiries"
    ADD CONSTRAINT "bulk_order_enquiries_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."categories"
    ADD CONSTRAINT "categories_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."categories"
    ADD CONSTRAINT "categories_slug_key" UNIQUE ("slug");



ALTER TABLE ONLY "public"."homepage_sections"
    ADD CONSTRAINT "homepage_sections_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."homepage_sections"
    ADD CONSTRAINT "homepage_sections_section_key_key" UNIQUE ("section_key");



ALTER TABLE ONLY "public"."inventory_adjustments"
    ADD CONSTRAINT "inventory_adjustments_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."inventory"
    ADD CONSTRAINT "inventory_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."inventory"
    ADD CONSTRAINT "inventory_product_id_key" UNIQUE ("product_id");



ALTER TABLE ONLY "public"."order_items"
    ADD CONSTRAINT "order_items_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."orders"
    ADD CONSTRAINT "orders_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."product_images"
    ADD CONSTRAINT "product_images_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_sku_key" UNIQUE ("sku");



ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_slug_key" UNIQUE ("slug");



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."storefront_media"
    ADD CONSTRAINT "storefront_media_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."storefront_nav_cards"
    ADD CONSTRAINT "storefront_nav_cards_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."subcategories"
    ADD CONSTRAINT "subcategories_category_slug_unique" UNIQUE ("category_id", "slug");



ALTER TABLE ONLY "public"."subcategories"
    ADD CONSTRAINT "subcategories_pkey" PRIMARY KEY ("id");



CREATE INDEX "bulk_order_enquiries_created_at_idx" ON "public"."bulk_order_enquiries" USING "btree" ("created_at" DESC);



CREATE INDEX "bulk_order_enquiries_status_idx" ON "public"."bulk_order_enquiries" USING "btree" ("status");



CREATE INDEX "homepage_sections_order_idx" ON "public"."homepage_sections" USING "btree" ("is_active", "display_order");



CREATE INDEX "idx_products_subcategory_id" ON "public"."products" USING "btree" ("subcategory_id");



CREATE INDEX "idx_subcategories_active" ON "public"."subcategories" USING "btree" ("is_active");



CREATE INDEX "idx_subcategories_category_id" ON "public"."subcategories" USING "btree" ("category_id");



CREATE INDEX "inventory_product_id_idx" ON "public"."inventory" USING "btree" ("product_id");



CREATE INDEX "order_items_order_id_idx" ON "public"."order_items" USING "btree" ("order_id");



CREATE INDEX "order_items_product_id_idx" ON "public"."order_items" USING "btree" ("product_id");



CREATE INDEX "orders_created_at_idx" ON "public"."orders" USING "btree" ("created_at" DESC);



CREATE INDEX "orders_status_idx" ON "public"."orders" USING "btree" ("status");



CREATE INDEX "orders_user_id_idx" ON "public"."orders" USING "btree" ("user_id");



CREATE INDEX "product_images_product_id_idx" ON "public"."product_images" USING "btree" ("product_id");



CREATE INDEX "products_active_idx" ON "public"."products" USING "btree" ("is_active");



CREATE INDEX "products_category_id_idx" ON "public"."products" USING "btree" ("category_id");



CREATE INDEX "products_created_at_idx" ON "public"."products" USING "btree" ("created_at" DESC);



CREATE INDEX "storefront_media_active_idx" ON "public"."storefront_media" USING "btree" ("is_active", "created_at" DESC);



CREATE INDEX "storefront_nav_cards_category_idx" ON "public"."storefront_nav_cards" USING "btree" ("category_id");



CREATE INDEX "storefront_nav_cards_order_idx" ON "public"."storefront_nav_cards" USING "btree" ("is_active", "display_order");



CREATE INDEX "storefront_nav_cards_product_idx" ON "public"."storefront_nav_cards" USING "btree" ("product_id");



CREATE INDEX "storefront_nav_cards_subcategory_idx" ON "public"."storefront_nav_cards" USING "btree" ("subcategory_id");



CREATE OR REPLACE TRIGGER "homepage_sections_updated_at" BEFORE UPDATE ON "public"."homepage_sections" FOR EACH ROW EXECUTE FUNCTION "public"."update_storefront_cms_updated_at"();



CREATE OR REPLACE TRIGGER "set_bulk_order_enquiry_updated_at" BEFORE UPDATE ON "public"."bulk_order_enquiries" FOR EACH ROW EXECUTE FUNCTION "public"."set_bulk_order_enquiry_updated_at"();



CREATE OR REPLACE TRIGGER "storefront_media_updated_at" BEFORE UPDATE ON "public"."storefront_media" FOR EACH ROW EXECUTE FUNCTION "public"."update_storefront_cms_updated_at"();



ALTER TABLE ONLY "public"."admin_users"
    ADD CONSTRAINT "admin_users_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."bulk_order_enquiries"
    ADD CONSTRAINT "bulk_order_enquiries_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "public"."categories"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."bulk_order_enquiries"
    ADD CONSTRAINT "bulk_order_enquiries_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."homepage_sections"
    ADD CONSTRAINT "homepage_sections_media_id_fkey" FOREIGN KEY ("media_id") REFERENCES "public"."storefront_media"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."inventory_adjustments"
    ADD CONSTRAINT "inventory_adjustments_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."inventory_adjustments"
    ADD CONSTRAINT "inventory_adjustments_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."inventory"
    ADD CONSTRAINT "inventory_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."order_items"
    ADD CONSTRAINT "order_items_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "public"."orders"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."order_items"
    ADD CONSTRAINT "order_items_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."orders"
    ADD CONSTRAINT "orders_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."profiles"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."product_images"
    ADD CONSTRAINT "product_images_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "public"."categories"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_subcategory_id_fkey" FOREIGN KEY ("subcategory_id") REFERENCES "public"."subcategories"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."storefront_nav_cards"
    ADD CONSTRAINT "storefront_nav_cards_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "public"."categories"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."storefront_nav_cards"
    ADD CONSTRAINT "storefront_nav_cards_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."storefront_nav_cards"
    ADD CONSTRAINT "storefront_nav_cards_subcategory_id_fkey" FOREIGN KEY ("subcategory_id") REFERENCES "public"."subcategories"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."subcategories"
    ADD CONSTRAINT "subcategories_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "public"."categories"("id") ON DELETE RESTRICT;



CREATE POLICY "Admins can delete categories" ON "public"."categories" FOR DELETE TO "authenticated" USING ("public"."is_admin"());



CREATE POLICY "Admins can delete homepage sections" ON "public"."homepage_sections" FOR DELETE TO "authenticated" USING ("public"."is_admin"());



CREATE POLICY "Admins can delete inventory" ON "public"."inventory" FOR DELETE TO "authenticated" USING ("public"."is_admin"());



CREATE POLICY "Admins can delete product images" ON "public"."product_images" FOR DELETE TO "authenticated" USING ("public"."is_admin"());



CREATE POLICY "Admins can delete products" ON "public"."products" FOR DELETE TO "authenticated" USING ("public"."is_admin"());



CREATE POLICY "Admins can delete storefront media" ON "public"."storefront_media" FOR DELETE TO "authenticated" USING ("public"."is_admin"());



CREATE POLICY "Admins can delete storefront nav cards" ON "public"."storefront_nav_cards" FOR DELETE TO "authenticated" USING ("public"."is_admin"());



CREATE POLICY "Admins can delete subcategories" ON "public"."subcategories" FOR DELETE TO "authenticated" USING ("public"."is_admin"());



CREATE POLICY "Admins can insert categories" ON "public"."categories" FOR INSERT TO "authenticated" WITH CHECK ("public"."is_admin"());



CREATE POLICY "Admins can insert homepage sections" ON "public"."homepage_sections" FOR INSERT TO "authenticated" WITH CHECK ("public"."is_admin"());



CREATE POLICY "Admins can insert inventory" ON "public"."inventory" FOR INSERT TO "authenticated" WITH CHECK ("public"."is_admin"());



CREATE POLICY "Admins can insert inventory adjustments" ON "public"."inventory_adjustments" FOR INSERT TO "authenticated" WITH CHECK ("public"."is_admin"());



CREATE POLICY "Admins can insert product images" ON "public"."product_images" FOR INSERT TO "authenticated" WITH CHECK ("public"."is_admin"());



CREATE POLICY "Admins can insert products" ON "public"."products" FOR INSERT TO "authenticated" WITH CHECK ("public"."is_admin"());



CREATE POLICY "Admins can insert storefront media" ON "public"."storefront_media" FOR INSERT TO "authenticated" WITH CHECK ("public"."is_admin"());



CREATE POLICY "Admins can insert storefront nav cards" ON "public"."storefront_nav_cards" FOR INSERT TO "authenticated" WITH CHECK ("public"."is_admin"());



CREATE POLICY "Admins can insert subcategories" ON "public"."subcategories" FOR INSERT TO "authenticated" WITH CHECK ("public"."is_admin"());



CREATE POLICY "Admins can update bulk order enquiries" ON "public"."bulk_order_enquiries" FOR UPDATE TO "authenticated" USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());



CREATE POLICY "Admins can update categories" ON "public"."categories" FOR UPDATE TO "authenticated" USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());



CREATE POLICY "Admins can update homepage sections" ON "public"."homepage_sections" FOR UPDATE TO "authenticated" USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());



CREATE POLICY "Admins can update inventory" ON "public"."inventory" FOR UPDATE TO "authenticated" USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());



CREATE POLICY "Admins can update product images" ON "public"."product_images" FOR UPDATE TO "authenticated" USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());



CREATE POLICY "Admins can update products" ON "public"."products" FOR UPDATE TO "authenticated" USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());



CREATE POLICY "Admins can update storefront media" ON "public"."storefront_media" FOR UPDATE TO "authenticated" USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());



CREATE POLICY "Admins can update storefront nav cards" ON "public"."storefront_nav_cards" FOR UPDATE TO "authenticated" USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());



CREATE POLICY "Admins can update subcategories" ON "public"."subcategories" FOR UPDATE TO "authenticated" USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());



CREATE POLICY "Admins can view all order items" ON "public"."order_items" FOR SELECT TO "authenticated" USING ("public"."is_admin"());



CREATE POLICY "Admins can view all orders" ON "public"."orders" FOR SELECT TO "authenticated" USING ("public"."is_admin"());



CREATE POLICY "Admins can view all profiles" ON "public"."profiles" FOR SELECT TO "authenticated" USING ("public"."is_admin"());



CREATE POLICY "Admins can view all subcategories" ON "public"."subcategories" FOR SELECT TO "authenticated" USING ("public"."is_admin"());



CREATE POLICY "Admins can view bulk order enquiries" ON "public"."bulk_order_enquiries" FOR SELECT TO "authenticated" USING ("public"."is_admin"());



CREATE POLICY "Admins can view inventory adjustments" ON "public"."inventory_adjustments" FOR SELECT TO "authenticated" USING ("public"."is_admin"());



CREATE POLICY "Public can submit bulk order enquiries" ON "public"."bulk_order_enquiries" FOR INSERT TO "authenticated", "anon" WITH CHECK (true);



CREATE POLICY "Public can view active categories" ON "public"."categories" FOR SELECT TO "authenticated", "anon" USING (("is_active" = true));



CREATE POLICY "Public can view active homepage sections" ON "public"."homepage_sections" FOR SELECT USING (("is_active" = true));



CREATE POLICY "Public can view active products" ON "public"."products" FOR SELECT TO "authenticated", "anon" USING (("is_active" = true));



CREATE POLICY "Public can view active storefront media" ON "public"."storefront_media" FOR SELECT USING (("is_active" = true));



CREATE POLICY "Public can view active storefront nav cards" ON "public"."storefront_nav_cards" FOR SELECT USING (("is_active" = true));



CREATE POLICY "Public can view active subcategories" ON "public"."subcategories" FOR SELECT TO "authenticated", "anon" USING (("is_active" = true));



CREATE POLICY "Public can view images of active products" ON "public"."product_images" FOR SELECT TO "authenticated", "anon" USING ((EXISTS ( SELECT 1
   FROM "public"."products" "p"
  WHERE (("p"."id" = "product_images"."product_id") AND ("p"."is_active" = true)))));



CREATE POLICY "Public can view inventory of active products" ON "public"."inventory" FOR SELECT TO "authenticated", "anon" USING ((EXISTS ( SELECT 1
   FROM "public"."products" "p"
  WHERE (("p"."id" = "inventory"."product_id") AND ("p"."is_active" = true)))));



CREATE POLICY "Users can insert their own profile" ON "public"."profiles" FOR INSERT TO "authenticated" WITH CHECK (("auth"."uid"() = "id"));



CREATE POLICY "Users can update their own profile" ON "public"."profiles" FOR UPDATE TO "authenticated" USING (("auth"."uid"() = "id")) WITH CHECK (("auth"."uid"() = "id"));



CREATE POLICY "Users can view their own order items" ON "public"."order_items" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."orders"
  WHERE (("orders"."id" = "order_items"."order_id") AND ("orders"."user_id" = "auth"."uid"())))));



CREATE POLICY "Users can view their own orders" ON "public"."orders" FOR SELECT TO "authenticated" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can view their own profile" ON "public"."profiles" FOR SELECT TO "authenticated" USING (("auth"."uid"() = "id"));



ALTER TABLE "public"."admin_users" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."bulk_order_enquiries" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."categories" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."homepage_sections" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."inventory" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."inventory_adjustments" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."order_items" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."orders" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."product_images" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."products" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."profiles" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."storefront_media" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."storefront_nav_cards" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."subcategories" ENABLE ROW LEVEL SECURITY;


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";



REVOKE ALL ON FUNCTION "public"."adjust_inventory"("p_product_id" "uuid", "p_quantity_change" integer, "p_reason" "text") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."adjust_inventory"("p_product_id" "uuid", "p_quantity_change" integer, "p_reason" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."adjust_inventory"("p_product_id" "uuid", "p_quantity_change" integer, "p_reason" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."adjust_inventory"("p_product_id" "uuid", "p_quantity_change" integer, "p_reason" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."create_order"("p_items" "jsonb", "p_shipping" "jsonb") TO "anon";
GRANT ALL ON FUNCTION "public"."create_order"("p_items" "jsonb", "p_shipping" "jsonb") TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_order"("p_items" "jsonb", "p_shipping" "jsonb") TO "service_role";



GRANT ALL ON FUNCTION "public"."create_order_with_payment"("p_items" "jsonb", "p_shipping" "jsonb", "p_payment_method" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."create_order_with_payment"("p_items" "jsonb", "p_shipping" "jsonb", "p_payment_method" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_order_with_payment"("p_items" "jsonb", "p_shipping" "jsonb", "p_payment_method" "text") TO "service_role";



REVOKE ALL ON FUNCTION "public"."create_product_with_inventory"("p_category_id" "uuid", "p_subcategory_id" "uuid", "p_name" "text", "p_slug" "text", "p_description" "text", "p_price" numeric, "p_compare_at_price" numeric, "p_sku" "text", "p_is_active" boolean, "p_quantity" integer) FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."create_product_with_inventory"("p_category_id" "uuid", "p_subcategory_id" "uuid", "p_name" "text", "p_slug" "text", "p_description" "text", "p_price" numeric, "p_compare_at_price" numeric, "p_sku" "text", "p_is_active" boolean, "p_quantity" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."create_product_with_inventory"("p_category_id" "uuid", "p_subcategory_id" "uuid", "p_name" "text", "p_slug" "text", "p_description" "text", "p_price" numeric, "p_compare_at_price" numeric, "p_sku" "text", "p_is_active" boolean, "p_quantity" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_product_with_inventory"("p_category_id" "uuid", "p_subcategory_id" "uuid", "p_name" "text", "p_slug" "text", "p_description" "text", "p_price" numeric, "p_compare_at_price" numeric, "p_sku" "text", "p_is_active" boolean, "p_quantity" integer) TO "service_role";



REVOKE ALL ON FUNCTION "public"."is_admin"() FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."is_admin"() TO "anon";
GRANT ALL ON FUNCTION "public"."is_admin"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_admin"() TO "service_role";



GRANT ALL ON FUNCTION "public"."set_bulk_order_enquiry_updated_at"() TO "anon";
GRANT ALL ON FUNCTION "public"."set_bulk_order_enquiry_updated_at"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_bulk_order_enquiry_updated_at"() TO "service_role";



GRANT ALL ON FUNCTION "public"."update_storefront_cms_updated_at"() TO "anon";
GRANT ALL ON FUNCTION "public"."update_storefront_cms_updated_at"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."update_storefront_cms_updated_at"() TO "service_role";



GRANT ALL ON TABLE "public"."admin_users" TO "anon";
GRANT ALL ON TABLE "public"."admin_users" TO "authenticated";
GRANT ALL ON TABLE "public"."admin_users" TO "service_role";



GRANT ALL ON TABLE "public"."bulk_order_enquiries" TO "anon";
GRANT ALL ON TABLE "public"."bulk_order_enquiries" TO "authenticated";
GRANT ALL ON TABLE "public"."bulk_order_enquiries" TO "service_role";



GRANT ALL ON TABLE "public"."categories" TO "anon";
GRANT ALL ON TABLE "public"."categories" TO "authenticated";
GRANT ALL ON TABLE "public"."categories" TO "service_role";



GRANT ALL ON TABLE "public"."homepage_sections" TO "anon";
GRANT ALL ON TABLE "public"."homepage_sections" TO "authenticated";
GRANT ALL ON TABLE "public"."homepage_sections" TO "service_role";



GRANT ALL ON TABLE "public"."inventory" TO "anon";
GRANT ALL ON TABLE "public"."inventory" TO "authenticated";
GRANT ALL ON TABLE "public"."inventory" TO "service_role";



GRANT ALL ON TABLE "public"."inventory_adjustments" TO "anon";
GRANT ALL ON TABLE "public"."inventory_adjustments" TO "authenticated";
GRANT ALL ON TABLE "public"."inventory_adjustments" TO "service_role";



GRANT ALL ON TABLE "public"."order_items" TO "anon";
GRANT ALL ON TABLE "public"."order_items" TO "authenticated";
GRANT ALL ON TABLE "public"."order_items" TO "service_role";



GRANT ALL ON TABLE "public"."orders" TO "anon";
GRANT ALL ON TABLE "public"."orders" TO "authenticated";
GRANT ALL ON TABLE "public"."orders" TO "service_role";



GRANT ALL ON TABLE "public"."product_images" TO "anon";
GRANT ALL ON TABLE "public"."product_images" TO "authenticated";
GRANT ALL ON TABLE "public"."product_images" TO "service_role";



GRANT ALL ON TABLE "public"."products" TO "anon";
GRANT ALL ON TABLE "public"."products" TO "authenticated";
GRANT ALL ON TABLE "public"."products" TO "service_role";



GRANT ALL ON TABLE "public"."profiles" TO "anon";
GRANT ALL ON TABLE "public"."profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."profiles" TO "service_role";



GRANT ALL ON TABLE "public"."storefront_media" TO "anon";
GRANT ALL ON TABLE "public"."storefront_media" TO "authenticated";
GRANT ALL ON TABLE "public"."storefront_media" TO "service_role";



GRANT ALL ON TABLE "public"."storefront_nav_cards" TO "anon";
GRANT ALL ON TABLE "public"."storefront_nav_cards" TO "authenticated";
GRANT ALL ON TABLE "public"."storefront_nav_cards" TO "service_role";



GRANT ALL ON TABLE "public"."subcategories" TO "anon";
GRANT ALL ON TABLE "public"."subcategories" TO "authenticated";
GRANT ALL ON TABLE "public"."subcategories" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";







