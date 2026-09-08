SET session_replication_role = replica;

--
-- PostgreSQL database dump
--

-- \restrict m67rzfakca4HU4cNa39CSpagmUcaQu6gsXhNdzv16QxdZPkR8RmNiLWwvuiQXOj

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: admin_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."admin_users" ("user_id", "created_at") VALUES
	('b84826fb-71c0-40fe-9aca-22f8bc2f3350', '2026-08-23 07:14:04.231582+00');


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."categories" ("id", "name", "slug", "description", "is_active", "created_at", "updated_at", "image_url") VALUES
	('c419dde3-a169-432f-8b6d-613722ae0212', 'Side Bags', 'side-bags', 'Eco-friendly everyday side bags.', true, '2026-08-02 15:53:47.197048+00', '2026-08-02 15:53:47.197048+00', NULL),
	('e16e1460-32ce-4826-9cf9-06eea16232e0', 'Eco-Friendly Products', 'eco-friendly-products', 'Sustainable products designed for everyday use.', true, '2026-08-02 15:53:47.197048+00', '2026-08-02 15:53:47.197048+00', NULL),
	('693f2c8e-89bb-4aa3-bae3-305483af472e', 'Another Admin Bag', 'another-admin-test', 'Test-Admin', true, '2026-08-24 11:05:42.563971+00', '2026-09-05 19:34:33.39+00', NULL),
	('b3434c24-7337-4c4d-b25b-c26f5c7f6e04', 'Jute Bags LIVE TEST 123', 'jute-bags', 'Eco-friendly bags made from natural jute.', true, '2026-08-02 15:53:47.197048+00', '2026-09-05 19:38:41.156+00', NULL),
	('d87853a3-f8ca-44b7-80cd-64b8ad8457f4', 'Laptop Bags', 'laptopbags', 'test', true, '2026-09-07 19:08:30.242277+00', '2026-09-07 19:46:05.185+00', 'https://xxlmepoikuyelqxclaus.supabase.co/storage/v1/object/public/product-images/categories/d87853a3-f8ca-44b7-80cd-64b8ad8457f4/1788810363678.webp');


--
-- Data for Name: subcategories; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."subcategories" ("id", "category_id", "name", "slug", "description", "display_order", "is_active", "created_at", "updated_at") VALUES
	('3e5ab58c-9e9e-4d35-9f2d-53d7c8fc1ed7', 'c419dde3-a169-432f-8b6d-613722ae0212', 'Embroidered Side Bags', 'embroidered-side-bags', 'Our embroidered side bag collection.', 1, true, '2026-08-15 05:47:58.85427+00', '2026-08-15 05:47:58.85427+00'),
	('daeac6d6-3878-4c15-a111-b820f655d564', 'c419dde3-a169-432f-8b6d-613722ae0212', 'Cotton Side Bags', 'cotton-side-bags', 'Lightweight cotton side bags for everyday use.', 3, true, '2026-08-24 11:17:16.206022+00', '2026-09-05 18:30:38.421+00');


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."products" ("id", "category_id", "name", "slug", "description", "price", "compare_at_price", "sku", "is_active", "created_at", "updated_at", "subcategory_id") VALUES
	('388db25f-1b10-4a1b-8538-7c255a3fe6f6', 'c419dde3-a169-432f-8b6d-613722ae0212', 'Classic Jute Side Bag', 'classic-jute-side-bag', 'A reusable eco-friendly jute side bag designed for everyday use.', 699.00, 799.00, 'PM-JUTE-SIDE-001', true, '2026-08-02 15:54:08.464173+00', '2026-08-15 05:47:58.85427+00', '3e5ab58c-9e9e-4d35-9f2d-53d7c8fc1ed7'),
	('89a55b04-2e6a-4d44-a4bb-91f18498e246', 'b3434c24-7337-4c4d-b25b-c26f5c7f6e04', 'Classic Jute Side Bag - Admin Test Update', 'classic-jute-side-bag-admin-test', 'This is a temporary test product created through the Prakriti Maitri Admin Panel to verify product creation and inventory management.', 100.00, 200.00, 'PM-JUTE-ADMIN-TEST-001', true, '2026-08-23 15:45:26.164136+00', '2026-08-23 15:45:26.164136+00', NULL),
	('e4b42f06-84a6-4e97-bbc5-8ce0f4d77138', 'c419dde3-a169-432f-8b6d-613722ae0212', '8x10 Inch Cotton Drawstring Bag | 150 GSM', '8x10-inch-cotton-drawstring-bag-150-gsm', 'Designed to elevate your brand with sustainable packaging, this custom cotton drawstring bag combines everyday functionality with professional logo printing, helping businesses create a lasting impression.', 299.00, 399.00, 'PM-DST-001', true, '2026-09-02 12:03:09.044194+00', '2026-09-02 12:03:09.044194+00', '3e5ab58c-9e9e-4d35-9f2d-53d7c8fc1ed7'),
	('bda38139-8764-49d8-a179-83e2ec0c4b8d', 'c419dde3-a169-432f-8b6d-613722ae0212', 'Mulberry Classic Women Tote Bag', 'mulberry-classic-women-tote-bag', 'Mulberry Classic Women Tote Bag is a stylish and versatile medium-sized tote bag designed for daily use. Made with a modern two-tone design, it features a beige body with mulberry handles and base for a classy look. With a 16-inch width, 10-inch height, and 3-inch depth, it offers enough space to carry your essentials without being too bulky. The strong double handles provide a comfortable grip, while the neat stitching adds to its durability. Perfect for office, shopping, travel, or casual outings, this tote bag is both practical and fashionable.

Features:

Medium Size Tote - 16 inch wide, 10 inch high, 3 inch deep

Stylish Two-Tone Design - Beige body with mulberry base and handles

Durable Stitching - Strong finish for long-lasting use

Comfortable Handles - Easy to carry on shoulder or hand

Spacious Interior - Perfect for daily essentials

Multi-Purpose Use - Ideal for office, shopping, travel, and casual outings', 199.00, 399.00, 'PM-TOTE-01', true, '2026-09-04 11:08:07.848192+00', '2026-09-04 11:08:07.848192+00', '3e5ab58c-9e9e-4d35-9f2d-53d7c8fc1ed7');


--
-- Data for Name: bulk_order_enquiries; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."bulk_order_enquiries" ("id", "name", "mobile", "email", "business_name", "category_id", "product_id", "quantity", "purpose", "message", "status", "admin_notes", "created_at", "updated_at") VALUES
	('d8372500-092a-4509-a4fd-dc04ad714fa6', 'TEST - CUSTOMER', '1234567890', 'TEST@gmail.com', 'test pvt ltd', 'c419dde3-a169-432f-8b6d-613722ae0212', '388db25f-1b10-4a1b-8538-7c255a3fe6f6', 1000, 'Corporate gifting', 'test  desciption', 'new', NULL, '2026-09-07 21:48:58.226005+00', '2026-09-07 21:48:58.226005+00');


--
-- Data for Name: storefront_media; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."storefront_media" ("id", "media_type", "title", "file_url", "thumbnail_url", "alt_text", "mime_type", "file_size", "is_active", "created_at", "updated_at") VALUES
	('439e0f8a-4b4a-45dd-9c67-6a94e2094adb', 'video', 'test', 'https://xxlmepoikuyelqxclaus.supabase.co/storage/v1/object/public/storefront-media/homepage/video/1788647022080-Video-20427.mp4', NULL, 'test video', 'video/mp4', 3912625, true, '2026-09-05 22:24:15.309041+00', '2026-09-05 22:24:15.309041+00'),
	('daa0e090-3673-4ae7-a854-99a93701fdbe', 'image', 'Thoughtful products. Meaningful choices.', 'https://xxlmepoikuyelqxclaus.supabase.co/storage/v1/object/public/storefront-media/homepage/63aebf08-ab7e-498c-8a4c-cdf6cedfce01/1788649293597.webp', NULL, 'Thoughtful products. Meaningful choices.', 'image/webp', 47136, true, '2026-09-05 23:01:35.283186+00', '2026-09-05 23:01:35.283186+00'),
	('338c7bc9-31c8-4435-8078-3dde758af51d', 'image', 'Thoughtful products. Meaningful choices.', 'https://xxlmepoikuyelqxclaus.supabase.co/storage/v1/object/public/storefront-media/homepage/63aebf08-ab7e-498c-8a4c-cdf6cedfce01/1788649648378.png', NULL, 'Thoughtful products. Meaningful choices.', 'image/png', 2397867, true, '2026-09-05 23:07:48.97896+00', '2026-09-05 23:07:48.97896+00'),
	('3c8e1cde-7dba-45e7-9e1a-c8834225d021', 'image', 'Carry something that means more.', 'https://xxlmepoikuyelqxclaus.supabase.co/storage/v1/object/public/storefront-media/homepage/63b7438e-782f-42af-9edc-4c561024b4d5/1788649948234.png', NULL, 'Carry something that means more.', 'image/png', 2446939, true, '2026-09-05 23:12:45.265962+00', '2026-09-05 23:12:45.265962+00'),
	('f01d8471-6da7-4df9-a648-bda12c5304a6', 'image', 'Thoughtful products. Meaningful choices.', 'https://xxlmepoikuyelqxclaus.supabase.co/storage/v1/object/public/storefront-media/homepage/63aebf08-ab7e-498c-8a4c-cdf6cedfce01/1788650147716.png', NULL, 'Thoughtful products. Meaningful choices.', 'image/png', 2948963, true, '2026-09-05 23:16:09.294326+00', '2026-09-05 23:16:09.294326+00'),
	('a5f8830d-ec8b-448d-a288-74a465ecc523', 'image', 'Gifts that make moments memorable.', 'https://xxlmepoikuyelqxclaus.supabase.co/storage/v1/object/public/storefront-media/homepage/9c49dc3a-9bce-4cf6-aee7-af04f3de7d7b/1788650199602.png', NULL, 'Gifts that make moments memorable.', 'image/png', 2397867, true, '2026-09-05 23:16:55.521279+00', '2026-09-05 23:16:55.521279+00'),
	('8b78bcc5-3f33-46ae-9942-056f258d118d', 'image', 'story_banner', 'https://xxlmepoikuyelqxclaus.supabase.co/storage/v1/object/public/storefront-media/homepage/64a21c8a-d013-424b-9782-f0bd97a21be4/1788650226525.png', NULL, 'story_banner', 'image/png', 2446939, true, '2026-09-05 23:17:19.296994+00', '2026-09-05 23:17:19.296994+00'),
	('3e319e7b-bc9b-4b27-bb35-fb7a388b3ea9', 'image', 'Thoughtful products. Meaningful choices.', 'https://xxlmepoikuyelqxclaus.supabase.co/storage/v1/object/public/storefront-media/homepage/63aebf08-ab7e-498c-8a4c-cdf6cedfce01/1788854168246.jpeg', NULL, 'Thoughtful products. Meaningful choices.', 'image/jpeg', 182510, true, '2026-09-08 07:56:08.972653+00', '2026-09-08 07:56:08.972653+00'),
	('8acfdb5c-6566-4ba9-9304-a3765a9d90d1', 'image', 'Thoughtful products. Meaningful choices.', 'https://xxlmepoikuyelqxclaus.supabase.co/storage/v1/object/public/storefront-media/homepage/63aebf08-ab7e-498c-8a4c-cdf6cedfce01/1788854190761.jpg', NULL, 'Thoughtful products. Meaningful choices.', 'image/jpeg', 49528, true, '2026-09-08 07:56:30.149691+00', '2026-09-08 07:56:30.149691+00');


--
-- Data for Name: homepage_sections; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."homepage_sections" ("id", "section_key", "section_type", "eyebrow", "title", "description", "cta_text", "cta_url", "media_id", "display_order", "is_active", "created_at", "updated_at") VALUES
	('f70c3764-e8cd-4278-a0b0-47062a80e7b2', 'featured_collection', 'collection', 'OUR COLLECTION', 'Made for every occasion', 'Thoughtfully designed bags for everyday use, gifting, packaging and bulk orders.', 'View More', '/shop?category=new', NULL, 1, true, '2026-09-05 22:03:38.853756+00', '2026-09-05 22:03:38.853756+00'),
	('54e5e27d-b4a8-40a5-ab3a-13c24abe329e', 'master_categories', 'categories', 'EXPLORE', 'Shop by Category', 'Find the right bag for every purpose.', NULL, NULL, NULL, 3, true, '2026-09-05 22:03:38.853756+00', '2026-09-05 22:03:38.853756+00'),
	('07a28919-5da3-4466-9fc7-b47932cc9173', 'most_loved', 'product_collection', 'CUSTOMER FAVOURITES', 'Most Loved Products', 'Some of the products our customers keep coming back for.', NULL, NULL, NULL, 5, true, '2026-09-05 22:03:38.853756+00', '2026-09-05 22:03:38.853756+00'),
	('208a49de-8978-49f1-a772-e333f7e46f42', 'advertising_video', 'video', 'OUR STORY', 'See what Prakriti Maitri stands for.', NULL, NULL, NULL, NULL, 6, true, '2026-09-05 22:03:38.853756+00', '2026-09-05 22:03:38.853756+00'),
	('63b7438e-782f-42af-9edc-4c561024b4d5', 'purpose_banner', 'banner', 'MADE WITH PURPOSE', 'Carry something that means more.', 'Eco-friendly choices that bring beauty, usefulness and purpose together.', 'Shop Collection', '/shop', '3c8e1cde-7dba-45e7-9e1a-c8834225d021', 2, true, '2026-09-05 22:03:38.853756+00', '2026-09-05 23:17:15.728877+00'),
	('64a21c8a-d013-424b-9782-f0bd97a21be4', 'story_banner', 'story', 'Get Your On Move Designs ', 'test ', 'test', 'test ', NULL, '8b78bcc5-3f33-46ae-9942-056f258d118d', 7, true, '2026-09-05 22:03:38.853756+00', '2026-09-05 23:18:06.225183+00'),
	('9c49dc3a-9bce-4cf6-aee7-af04f3de7d7b', 'gifting_banner', 'banner', 'CELEBRATE SUSTAINABLY', 'TEST AD MIN ', 'Discover thoughtful bags for celebrations, gifting and special occasions.', 'Explore Collection', '/shop?event=raksha-bandhan', 'a5f8830d-ec8b-448d-a288-74a465ecc523', 4, true, '2026-09-05 22:03:38.853756+00', '2026-09-05 23:20:35.164556+00'),
	('63aebf08-ab7e-498c-8a4c-cdf6cedfce01', 'hero', 'hero', 'ECO-FRIENDLY COLLECTION', 'Thoughtful products. Meaningful choices.', 'Sustainable bags designed for everyday life, gifting, celebrations and businesses.', 'Explore Collection', '/shop?category=new', '8acfdb5c-6566-4ba9-9304-a3765a9d90d1', 0, true, '2026-09-05 22:03:38.853756+00', '2026-09-08 07:56:41.275188+00');


--
-- Data for Name: inventory; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."inventory" ("id", "product_id", "quantity", "reserved_quantity", "updated_at", "low_stock_threshold") VALUES
	('92f5d99d-d0dc-41d4-9a84-9de86c3fa99d', '89a55b04-2e6a-4d44-a4bb-91f18498e246', 50, 0, '2026-08-25 07:49:58.145+00', 10),
	('2398afdd-b720-4c06-a216-269ef8ca1d2b', '388db25f-1b10-4a1b-8538-7c255a3fe6f6', 100, 16, '2026-08-30 08:48:43.099607+00', 10),
	('fc6099bb-7e71-4248-9cf6-f5fd837de1e9', 'e4b42f06-84a6-4e97-bbc5-8ce0f4d77138', 36, 0, '2026-09-02 12:03:09.044194+00', 10),
	('93eea9ef-3527-4f18-bd8e-86291de8a485', 'bda38139-8764-49d8-a179-83e2ec0c4b8d', 7, 0, '2026-09-04 11:08:07.848192+00', 10);


--
-- Data for Name: inventory_adjustments; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."inventory_adjustments" ("id", "product_id", "quantity_change", "quantity_before", "quantity_after", "reason", "created_by", "created_at") VALUES
	('5729b78d-f5ca-4b1d-8e5a-23f0fd69c6e5', '89a55b04-2e6a-4d44-a4bb-91f18498e246', 20, 25, 45, 'NEW STOCK REVISED', 'b84826fb-71c0-40fe-9aca-22f8bc2f3350', '2026-08-23 16:17:21.604549+00'),
	('a877beb4-1ec3-40b5-a726-9852565f8b9c', '89a55b04-2e6a-4d44-a4bb-91f18498e246', -5, 45, 40, 'DAMAGE PRODUCT', 'b84826fb-71c0-40fe-9aca-22f8bc2f3350', '2026-08-23 16:20:20.743601+00');


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."profiles" ("id", "first_name", "last_name", "phone", "country", "onboarding_complete", "created_at", "updated_at") VALUES
	('d48da4df-684a-46c7-8ec8-7950c61f3278', 'anmol', 'patel', '+919301663289', 'India', true, '2026-08-01 21:16:13.318213+00', '2026-08-01 21:16:13.046+00'),
	('e8407d9a-18a9-4d3a-8a6a-ec072fe61aa9', 'sarvesh', 'patel', '+919301663289', 'India', true, '2026-08-16 07:30:19.239792+00', '2026-08-16 07:30:17.964+00'),
	('10a9fabb-b73b-4fb4-9fad-8de94d0e09db', 'test-4', 'test-4', '+919301663289', 'India', true, '2026-08-30 08:46:56.603452+00', '2026-08-30 08:46:55.8+00');


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."orders" ("id", "user_id", "status", "subtotal", "shipping_fee", "total", "shipping_first_name", "shipping_last_name", "shipping_phone", "shipping_address", "shipping_city", "shipping_state", "shipping_country", "shipping_postal_code", "created_at", "updated_at", "payment_method", "payment_status", "payment_id") VALUES
	('a5c05b8a-0493-4938-9ee4-e80f830a51bf', 'd48da4df-684a-46c7-8ec8-7950c61f3278', 'pending', 4893.00, 0.00, 4893.00, 'anmol', 'patel', '+919301663289', 'mau morod', 'indore', 'madhya pradesh', 'India', '482002', '2026-08-05 17:37:40.624572+00', '2026-08-05 17:37:40.624572+00', NULL, 'pending', NULL),
	('6c7b99d1-a1ed-4568-a2a3-26f31ba15edc', 'd48da4df-684a-46c7-8ec8-7950c61f3278', 'pending', 699.00, 0.00, 699.00, 'anmol', 'patel', '+919301663289', 'mau morod', 'indore', 'Madhya Pradesh', 'India', '482002', '2026-08-15 17:40:49.479158+00', '2026-08-15 17:40:49.479158+00', NULL, 'pending', NULL),
	('82f0d296-33b6-46b2-b643-c66410ba856d', 'e8407d9a-18a9-4d3a-8a6a-ec072fe61aa9', 'pending', 3495.00, 0.00, 3495.00, 'sarvesh  ', 'patel', '+919301663289', 'mau morod', 'indore', 'Madhya Pradesh', 'India', '482002', '2026-08-16 07:40:55.706036+00', '2026-08-16 07:40:55.706036+00', NULL, 'pending', NULL),
	('371b56e5-c824-43e8-bc75-a21c866ab55e', 'e8407d9a-18a9-4d3a-8a6a-ec072fe61aa9', 'confirmed', 699.00, 0.00, 699.00, 'MVP', 'COD Test', '+919999999999', 'MVP Test Address', 'Indore', 'Madhya Pradesh', 'India', '452001', '2026-08-16 08:14:49.663779+00', '2026-08-16 08:14:49.663779+00', 'cod', 'cod_pending', NULL),
	('fd2d0761-9401-4142-8df2-0dbfe3f92b9b', 'e8407d9a-18a9-4d3a-8a6a-ec072fe61aa9', 'confirmed', 699.00, 0.00, 699.00, 'anmol', 'patel', '+919301663289', 'mau morod', 'indore', 'Madhya Pradesh', 'India', '482002', '2026-08-16 08:26:42.011102+00', '2026-08-16 08:26:42.011102+00', 'cod', 'cod_pending', NULL),
	('fe36fe42-8b95-419a-a937-f416dd539ac1', '10a9fabb-b73b-4fb4-9fad-8de94d0e09db', 'confirmed', 699.00, 0.00, 699.00, 'anmol', 'patel', '+919301663289', 'mau morod', 'indore', 'Madhya Pradesh', 'India', '482002', '2026-08-30 08:48:43.099607+00', '2026-08-30 08:48:43.099607+00', 'cod', 'cod_pending', NULL);


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."order_items" ("id", "order_id", "product_id", "product_name", "product_sku", "quantity", "unit_price", "line_total", "created_at") VALUES
	('353612a8-5783-4517-b09f-7e302fbf8caa', 'a5c05b8a-0493-4938-9ee4-e80f830a51bf', '388db25f-1b10-4a1b-8538-7c255a3fe6f6', 'Classic Jute Side Bag', 'PM-JUTE-SIDE-001', 7, 699.00, 4893.00, '2026-08-05 17:37:40.624572+00'),
	('01a3ad9b-95cc-4ccf-8d49-916181e7554e', '6c7b99d1-a1ed-4568-a2a3-26f31ba15edc', '388db25f-1b10-4a1b-8538-7c255a3fe6f6', 'Classic Jute Side Bag', 'PM-JUTE-SIDE-001', 1, 699.00, 699.00, '2026-08-15 17:40:49.479158+00'),
	('dcb659c1-fb5b-4dcd-af85-416313685ebf', '82f0d296-33b6-46b2-b643-c66410ba856d', '388db25f-1b10-4a1b-8538-7c255a3fe6f6', 'Classic Jute Side Bag', 'PM-JUTE-SIDE-001', 5, 699.00, 3495.00, '2026-08-16 07:40:55.706036+00'),
	('9b2fc943-9604-47e7-b286-89d880265d47', '371b56e5-c824-43e8-bc75-a21c866ab55e', '388db25f-1b10-4a1b-8538-7c255a3fe6f6', 'Classic Jute Side Bag', 'PM-JUTE-SIDE-001', 1, 699.00, 699.00, '2026-08-16 08:14:49.663779+00'),
	('0cc4f984-0b30-4bf3-8884-2756fc1cba35', 'fd2d0761-9401-4142-8df2-0dbfe3f92b9b', '388db25f-1b10-4a1b-8538-7c255a3fe6f6', 'Classic Jute Side Bag', 'PM-JUTE-SIDE-001', 1, 699.00, 699.00, '2026-08-16 08:26:42.011102+00'),
	('85cb80f5-c5ca-4455-9709-118319b2afe2', 'fe36fe42-8b95-419a-a937-f416dd539ac1', '388db25f-1b10-4a1b-8538-7c255a3fe6f6', 'Classic Jute Side Bag', 'PM-JUTE-SIDE-001', 1, 699.00, 699.00, '2026-08-30 08:48:43.099607+00');


--
-- Data for Name: product_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."product_images" ("id", "product_id", "image_url", "alt_text", "display_order", "created_at") VALUES
	('6ac1b411-8305-48b3-b6c9-aa796be9b1a7', '388db25f-1b10-4a1b-8538-7c255a3fe6f6', 'https://xxlmepoikuyelqxclaus.supabase.co/storage/v1/object/public/product-images/products/test.webp', 'Classic Jute Side Bag', 0, '2026-08-02 16:10:45.401624+00'),
	('e3110f06-34ee-48b2-ba83-9c2e0fd1924b', 'e4b42f06-84a6-4e97-bbc5-8ce0f4d77138', 'https://xxlmepoikuyelqxclaus.supabase.co/storage/v1/object/public/product-images/products/e4b42f06-84a6-4e97-bbc5-8ce0f4d77138/12fbb097-963a-4791-8e57-974e97a00d74.png', '8x10 Inch Cotton Drawstring Bag | 150 GSM', 0, '2026-09-02 12:03:11.81142+00'),
	('6dab0b2f-1387-497f-b7db-83d9ddc6871e', 'e4b42f06-84a6-4e97-bbc5-8ce0f4d77138', 'https://xxlmepoikuyelqxclaus.supabase.co/storage/v1/object/public/product-images/products/e4b42f06-84a6-4e97-bbc5-8ce0f4d77138/fad730bf-664c-4218-9f77-70477c6ee2f3.png', '8x10 Inch Cotton Drawstring Bag | 150 GSM', 1, '2026-09-02 12:03:13.842191+00'),
	('747b3e9c-900e-4241-b73a-e3a493606abf', 'bda38139-8764-49d8-a179-83e2ec0c4b8d', 'https://xxlmepoikuyelqxclaus.supabase.co/storage/v1/object/public/product-images/products/bda38139-8764-49d8-a179-83e2ec0c4b8d/d7c81510-0f79-4384-9ba6-f70ddb9bb28d.webp', 'Mulberry Classic Women Tote Bag', 0, '2026-09-04 11:08:09.370957+00');


--
-- Data for Name: storefront_nav_cards; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."storefront_nav_cards" ("id", "card_type", "category_id", "subcategory_id", "product_id", "title", "image_url", "href", "is_active", "display_order", "created_at", "updated_at") VALUES
	('479188b2-121b-4e79-b0b0-5b674d0c5800', 'subcategory', NULL, '3e5ab58c-9e9e-4d35-9f2d-53d7c8fc1ed7', NULL, 'Embroidered Side Bags', NULL, '/shop/side-bags/embroidered-side-bags', true, 4, '2026-09-05 19:05:41.936447+00', '2026-09-05 19:52:39.493+00'),
	('82ceb17f-0ccb-4980-90e2-bf364a47911d', 'category', 'b3434c24-7337-4c4d-b25b-c26f5c7f6e04', NULL, NULL, 'Jute Bags', NULL, '/shop/jute-bags', true, 0, '2026-09-05 19:05:41.936447+00', '2026-09-05 19:52:39.492+00'),
	('4e092ba1-54e2-4c12-bb8e-849ee4382735', 'subcategory', NULL, 'daeac6d6-3878-4c15-a111-b820f655d564', NULL, 'Cotton Side Bags', NULL, '/shop/side-bags/cotton-side-bags', true, 5, '2026-09-05 19:05:41.936447+00', '2026-09-05 19:52:39.493+00'),
	('07a6cf3d-43cf-488c-bfe5-7dc59d093a2e', 'category', 'e16e1460-32ce-4826-9cf9-06eea16232e0', NULL, NULL, 'Eco-Friendly Products', NULL, '/shop/eco-friendly-products', true, 2, '2026-09-05 19:05:41.936447+00', '2026-09-05 19:52:39.493+00'),
	('92c93c50-56a1-4a5e-bdb9-19af2e751c6d', 'category', 'c419dde3-a169-432f-8b6d-613722ae0212', NULL, NULL, 'Side Bags', NULL, '/shop/side-bags', true, 3, '2026-09-05 19:05:41.936447+00', '2026-09-05 19:52:39.493+00'),
	('8b2f05f1-62f4-4cf6-ba90-f845860e6e53', 'category', '693f2c8e-89bb-4aa3-bae3-305483af472e', NULL, NULL, 'Another Admin', 'https://xxlmepoikuyelqxclaus.supabase.co/storage/v1/object/public/product-images/storefront/nav-cards/8b2f05f1-62f4-4cf6-ba90-f845860e6e53/1788638039255.webp', '/shop/another-admin-test', true, 1, '2026-09-05 19:05:41.936447+00', '2026-09-05 19:54:00.921+00');


--
-- PostgreSQL database dump complete
--

-- \unrestrict m67rzfakca4HU4cNa39CSpagmUcaQu6gsXhNdzv16QxdZPkR8RmNiLWwvuiQXOj

RESET ALL;
