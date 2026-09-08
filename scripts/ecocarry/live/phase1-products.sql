-- ============================================================
-- ECOCARRY -> PRAKRATI MAITRI
-- PHASE 1: CATALOG / TAXONOMY / INVENTORY
-- ============================================================
--
-- 216 products
-- 4 categories
-- 20 subcategories
--
-- NO product_images inserts
-- NO Storage operations
-- NO image downloads
-- Existing products are ARCHIVED, not deleted.
-- ============================================================

BEGIN;

-- Archive the existing development catalog.
UPDATE public.products
SET is_active = false, updated_at = now()
WHERE is_active = true;

UPDATE public.subcategories
SET is_active = false, updated_at = now()
WHERE is_active = true;

UPDATE public.categories
SET is_active = false, updated_at = now()
WHERE is_active = true;

INSERT INTO public.categories
    (name, slug, description, is_active)
VALUES
    ('Packaging Bags', 'packaging-bags', NULL, true)
ON CONFLICT (slug)
DO UPDATE SET
    name = EXCLUDED.name,
    is_active = true,
    updated_at = now();

INSERT INTO public.categories
    (name, slug, description, is_active)
VALUES
    ('Tote Bags', 'tote-bags', NULL, true)
ON CONFLICT (slug)
DO UPDATE SET
    name = EXCLUDED.name,
    is_active = true,
    updated_at = now();

INSERT INTO public.categories
    (name, slug, description, is_active)
VALUES
    ('Hand Bags', 'hand-bags', NULL, true)
ON CONFLICT (slug)
DO UPDATE SET
    name = EXCLUDED.name,
    is_active = true,
    updated_at = now();

INSERT INTO public.categories
    (name, slug, description, is_active)
VALUES
    ('Hamper Bags', 'hamper-bags', NULL, true)
ON CONFLICT (slug)
DO UPDATE SET
    name = EXCLUDED.name,
    is_active = true,
    updated_at = now();

INSERT INTO public.subcategories
    (category_id, name, slug, description, display_order, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        'Cotton Packaging Bags',
        'cotton-packaging-bags',
        NULL,
        1,
        true
    )
ON CONFLICT (category_id, slug)
DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    display_order = EXCLUDED.display_order,
    is_active = true,
    updated_at = now();

INSERT INTO public.subcategories
    (category_id, name, slug, description, display_order, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        'Drawstring Bags',
        'drawstring-bags',
        NULL,
        2,
        true
    )
ON CONFLICT (category_id, slug)
DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    display_order = EXCLUDED.display_order,
    is_active = true,
    updated_at = now();

INSERT INTO public.subcategories
    (category_id, name, slug, description, display_order, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        'Paper Bags',
        'paper-bags',
        NULL,
        3,
        true
    )
ON CONFLICT (category_id, slug)
DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    display_order = EXCLUDED.display_order,
    is_active = true,
    updated_at = now();

INSERT INTO public.subcategories
    (category_id, name, slug, description, display_order, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        'Jute Bags',
        'jute-bags',
        NULL,
        4,
        true
    )
ON CONFLICT (category_id, slug)
DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    display_order = EXCLUDED.display_order,
    is_active = true,
    updated_at = now();

INSERT INTO public.subcategories
    (category_id, name, slug, description, display_order, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        'Pouch Bags',
        'pouch-bags',
        NULL,
        5,
        true
    )
ON CONFLICT (category_id, slug)
DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    display_order = EXCLUDED.display_order,
    is_active = true,
    updated_at = now();

INSERT INTO public.subcategories
    (category_id, name, slug, description, display_order, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        'Saree Covers',
        'saree-covers',
        NULL,
        6,
        true
    )
ON CONFLICT (category_id, slug)
DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    display_order = EXCLUDED.display_order,
    is_active = true,
    updated_at = now();

INSERT INTO public.subcategories
    (category_id, name, slug, description, display_order, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        'Paper Mailer Bags',
        'paper-mailer-bags',
        NULL,
        7,
        true
    )
ON CONFLICT (category_id, slug)
DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    display_order = EXCLUDED.display_order,
    is_active = true,
    updated_at = now();

INSERT INTO public.subcategories
    (category_id, name, slug, description, display_order, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        'Everyday Tote Bags',
        'everyday-tote-bags',
        NULL,
        1,
        true
    )
ON CONFLICT (category_id, slug)
DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    display_order = EXCLUDED.display_order,
    is_active = true,
    updated_at = now();

INSERT INTO public.subcategories
    (category_id, name, slug, description, display_order, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        'Mini Tote Bags',
        'mini-tote-bags',
        NULL,
        2,
        true
    )
ON CONFLICT (category_id, slug)
DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    display_order = EXCLUDED.display_order,
    is_active = true,
    updated_at = now();

INSERT INTO public.subcategories
    (category_id, name, slug, description, display_order, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        'Medium Tote Bags',
        'medium-tote-bags',
        NULL,
        3,
        true
    )
ON CONFLICT (category_id, slug)
DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    display_order = EXCLUDED.display_order,
    is_active = true,
    updated_at = now();

INSERT INTO public.subcategories
    (category_id, name, slug, description, display_order, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        'Large Tote Bags',
        'large-tote-bags',
        NULL,
        4,
        true
    )
ON CONFLICT (category_id, slug)
DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    display_order = EXCLUDED.display_order,
    is_active = true,
    updated_at = now();

INSERT INTO public.subcategories
    (category_id, name, slug, description, display_order, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        'Cotton Tote Bags',
        'cotton-tote-bags',
        NULL,
        5,
        true
    )
ON CONFLICT (category_id, slug)
DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    display_order = EXCLUDED.display_order,
    is_active = true,
    updated_at = now();

INSERT INTO public.subcategories
    (category_id, name, slug, description, display_order, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        'Canvas Tote Bags',
        'canvas-tote-bags',
        NULL,
        6,
        true
    )
ON CONFLICT (category_id, slug)
DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    display_order = EXCLUDED.display_order,
    is_active = true,
    updated_at = now();

INSERT INTO public.subcategories
    (category_id, name, slug, description, display_order, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        'Box Tote Bags',
        'box-tote-bags',
        NULL,
        7,
        true
    )
ON CONFLICT (category_id, slug)
DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    display_order = EXCLUDED.display_order,
    is_active = true,
    updated_at = now();

INSERT INTO public.subcategories
    (category_id, name, slug, description, display_order, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        'Office Bags',
        'office-bags',
        NULL,
        1,
        true
    )
ON CONFLICT (category_id, slug)
DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    display_order = EXCLUDED.display_order,
    is_active = true,
    updated_at = now();

INSERT INTO public.subcategories
    (category_id, name, slug, description, display_order, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        'Lunch Bags',
        'lunch-bags',
        NULL,
        2,
        true
    )
ON CONFLICT (category_id, slug)
DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    display_order = EXCLUDED.display_order,
    is_active = true,
    updated_at = now();

INSERT INTO public.subcategories
    (category_id, name, slug, description, display_order, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        'Kids Bags',
        'kids-bags',
        NULL,
        3,
        true
    )
ON CONFLICT (category_id, slug)
DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    display_order = EXCLUDED.display_order,
    is_active = true,
    updated_at = now();

INSERT INTO public.subcategories
    (category_id, name, slug, description, display_order, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        'Hamper Bags',
        'hamper-bags',
        NULL,
        1,
        true
    )
ON CONFLICT (category_id, slug)
DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    display_order = EXCLUDED.display_order,
    is_active = true,
    updated_at = now();

INSERT INTO public.subcategories
    (category_id, name, slug, description, display_order, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        'Embroidery Hamper Bags',
        'embroidery-hamper-bags',
        NULL,
        2,
        true
    )
ON CONFLICT (category_id, slug)
DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    display_order = EXCLUDED.display_order,
    is_active = true,
    updated_at = now();

INSERT INTO public.subcategories
    (category_id, name, slug, description, display_order, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        'Eco Gift Sets',
        'eco-gift-sets',
        NULL,
        3,
        true
    )
ON CONFLICT (category_id, slug)
DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    display_order = EXCLUDED.display_order,
    is_active = true,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'canvas-tote-bags'),
        'Diamond Jacquard & Diamond Motif Tote Bag Sample Kit | 330 GSM',
        'diamond-jacquard-diamond-motif-tote-bag-sample-kit-330-gsm',
        'Explore EcoCarry''s premium 13×15 cotton canvas and jute tote bags before placing a bulk order. This sample kit lets you compare two distinctive woven jute base designs, fabric quality, stitching, finishing, and overall presentation in hand. Material 330 GSM Cotton Canvas Upper + Woven Jute Base Size 13 × 15 Inch (W × H) Quantity 2 Tote Bags (1 Piece of Each Design) What''s Included 13×15 Diamond Jacquard Cotton Canvas Jute Tote Bag | 330 GSM 13×15 Diamond Motif Cotton Canvas Jute Tote Bag | 330 GSM Key Features Includes 2 premium woven jute base designs for easy comparison. Made with durable 330 GSM cotton canvas upper fabric. 13×15 inch size with strong woven handles and reinforced stitching. Large plain front area suitable for custom branding. Reusable, premium and ideal for eco-friendly brand packaging. Ideal For Bulk Order Planning – Compare both designs before finalizing production. Brand Packaging Selection – Evaluate which woven pattern best suits your brand. Boutiques &amp; Retail – Check presentation, fabric and finishing before ordering in quantity. Corporate &amp; Wellness Gifting – Select a premium reusable packaging option. Quality Evaluation – Inspect fabric, jute texture, handles and stitching in hand.',
        399.0,
        NULL,
        'SK118',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'embroidery-hamper-bags'),
        'Twin Elephant Embroidered Hamper Bag',
        'twin-elephant-embroidered-hamper-bag',
        'Add a distinctive handcrafted touch to your gifting with the Twin Elephant Embroidered Hamper Bag . The front combines two colourful traditional elephants, floral elements and a central oval space suitable for personalised branding or names. Material Cotton &amp; juco fabric Design Twin Elephant &amp; Floral Embroidery Size 9 × 6.5 × 4 Inch (W × H × G) Product Features Premium Cotton &amp; Juco Fabric Construction Twin Elephant &amp; Floral Embroidery with Personalisation Space Strong &amp; Comfortable Woven Carry Handles Secure Zipper Closure for Better Protection Structured 4-Inch Side Gusset for Added Capacity Reusable Design for Premium Gifting &amp; Packaging Ideal For 🎁 Gift Hampers – Premium reusable packaging for curated gift sets. 🪔 Festive Gifting – Ideal for Diwali, Rakhi and family celebrations. 💍 Wedding Gifting – Elegant packaging for hampers and return gifts. 💼 Corporate Gifting – Distinctive presentation for premium business gifts. 💄 Beauty &amp; Wellness – Suitable for cosmetics, fragrances and self-care kits.',
        126.75,
        NULL,
        'EC277',
        false
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'embroidery-hamper-bags'),
        'Mosaic Bloom Embroidered Hamper Bag',
        'mosaic-bloom-embroidered-hamper-bag',
        'Add a distinctive handcrafted touch to your gifting with the Mosaic Bloom Embroidered Hamper Bag . Its full front panel features a colourful geometric floral mosaic, finished with vibrant mustard trim for a festive and premium look. Material Cotton &amp; juco fabric Design Geometric Floral Mosaic Embroidery Size 9 × 6.5 × 4 Inch (W × H × G) Product Features Premium Cotton &amp; Juco Fabric Construction Full-Panel Geometric Floral Mosaic Embroidery Strong &amp; Comfortable Woven Carry Handles Secure Zipper Closure for Better Protection Structured 4-Inch Side Gusset for Added Capacity Reusable Design for Premium Gifting &amp; Packaging Ideal For 🎁 Gift Hampers – Premium reusable packaging for curated gift sets. 🪔 Festive Gifting – Ideal for Diwali, Rakhi and family celebrations. 💍 Wedding Gifting – Elegant packaging for hampers and return gifts. 💼 Corporate Gifting – Distinctive presentation for premium business gifts. 💄 Beauty &amp; Wellness – Suitable for cosmetics, fragrances and self-care kits.',
        114.89,
        NULL,
        'EC276',
        false
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'embroidery-hamper-bags'),
        'Wildflower Bouquet Bloom Mini Hamper Bag',
        'wildflower-bouqet-bloom-embroidered-hamper-bag',
        'Add a distinctive handcrafted touch to your gifting with the Wildflower Bouquet Bloom Mini Hamper Bag . The front features an elegant bouquet of orange blossoms and lavender foliage, complemented by soft sage-green trim. Material Cotton &amp; juco fabric Design Wildflower Bouquet Embroidery Size 9 × 6.5 × 4 Inch (W × H × G) Product Features Premium Cotton &amp; Juco Fabric Construction Detailed Multicolour Wildflower Bouquet Embroidery Strong &amp; Comfortable Woven Carry Handles Secure Zipper Closure for Better Protection Structured 4-Inch Side Gusset for Added Capacity Reusable Design for Premium Gifting &amp; Packaging Ideal For 🎁 Gift Hampers – Premium reusable packaging for curated gift sets. 🪔 Festive Gifting – Ideal for Diwali, Rakhi and family celebrations. 💍 Wedding Gifting – Elegant packaging for hampers and return gifts. 💼 Corporate Gifting – Distinctive presentation for premium business gifts. 💄 Beauty &amp; Wellness – Suitable for cosmetics, fragrances and self-care kits.',
        114.89,
        NULL,
        'EC274',
        false
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'large-tote-bags'),
        'Sky Blue Basket Bag | 400 GSM',
        'custom-sky-blue-basket-bag-400-gsm',
        'EcoCarry''s Custom Sky Blue Basket Bag is crafted from premium 400 GSM cotton with strong sky blue webbing handles. Its structured design and spacious gusset make it ideal for custom branding, corporate gifting, retail packaging, hampers, and promotional use. Material 100% Pure Cotton Canvas Size 10 × 9 × 4 Inch (25.4 × 22.86 × 10.16 cm) Fabric Details 400 GSM Handle Sky Blue Webbing 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Digital Print For Digital Print Maximum size is 5x4 Inch Embroidery 4 Color threads can be use Key Features Premium Heavy-Duty 400 GSM Cotton Fabric Strong &amp; Comfortable Sky Blue Webbing Carry Handle Structured 4-Inch Gusset for Extra Storage Reusable, Durable &amp; Made for Everyday Use Compact Basket-Style Design with Spacious Interior Large Branding Area for Custom Business Logos Ideal For 🎁 Gift Hampers – Perfect for premium hampers and curated gift sets. 🛍️ Boutique &amp; Retail – Reusable branded packaging for products. 💼 Corporate Gifting – Ideal for custom corporate gift kits. 💍 Wedding Gifts – Perfect for branded favours and return gifts. 💄 Beauty Products – Great for cosmetics and skincare sets. 🏪 Brand Merchandise – Custom logo bag for promotions and events.',
        81.98,
        NULL,
        'PM-0005',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'large-tote-bags'),
        'Light Green Basket Bag | 400 GSM',
        'custom-light-green-basket-bag-400-gsm',
        'EcoCarry''s Custom Light Green Basket Bag is crafted from premium 400 GSM cotton with strong light green webbing handles. Its structured design and spacious gusset make it ideal for custom branding, corporate gifting, retail packaging, hampers, and promotional use. Material 100% Pure Cotton Canvas Size 10 × 9 × 4 Inch (25.4 × 22.86 × 10.16 cm) Fabric Details 400 GSM Handle Light Green Webbing 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Digital Print For Digital Print Maximum size is 5x4 Inch Embroidery 4 Color threads can be use Key Features Premium Heavy-Duty 400 GSM Cotton Fabric Strong &amp; Comfortable Light Green Webbing Carry Handle Structured 4-Inch Gusset for Extra Storage Reusable, Durable &amp; Made for Everyday Use Compact Basket-Style Design with Spacious Interior Large Branding Area for Custom Business Logos Ideal For 🎁 Gift Hampers – Perfect for premium hampers and curated gift sets. 🛍️ Boutique &amp; Retail – Reusable branded packaging for products. 💼 Corporate Gifting – Ideal for custom corporate gift kits. 💍 Wedding Gifts – Perfect for branded favours and return gifts. 💄 Beauty Products – Great for cosmetics and skincare sets. 🏪 Brand Merchandise – Custom logo bag for promotions and events.',
        81.98,
        NULL,
        'PM-0006',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'large-tote-bags'),
        'Red Basket Bag | 400 GSM',
        'custom-red-basket-bag-400-gsm',
        'EcoCarry''s Custom Red Basket Bag is crafted from premium 400 GSM cotton with strong red webbing handles. Its structured design and spacious gusset make it ideal for custom branding, corporate gifting, retail packaging, hampers, and promotional use. Material 100% Pure Cotton Canvas Size 10 × 9 × 4 Inch (25.4 × 22.86 × 10.16 cm) Fabric Details 400 GSM Handle Red Webbing 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Digital Print For Digital Print Maximum size is 5x4 Inch Embroidery 4 Color threads can be use Key Features Premium Heavy-Duty 400 GSM Cotton Fabric Strong &amp; Comfortable Red Webbing Carry Handle Structured 4-Inch Gusset for Extra Storage Reusable, Durable &amp; Made for Everyday Use Compact Basket-Style Design with Spacious Interior Large Branding Area for Custom Business Logos Ideal For 🎁 Gift Hampers – Perfect for premium hampers and curated gift sets. 🛍️ Boutique &amp; Retail – Reusable branded packaging for products. 💼 Corporate Gifting – Ideal for custom corporate gift kits. 💍 Wedding Gifts – Perfect for branded favours and return gifts. 💄 Beauty Products – Great for cosmetics and skincare sets. 🏪 Brand Merchandise – Custom logo bag for promotions and events.',
        81.98,
        NULL,
        'PM-0007',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'hamper-bags'),
        'Mini Embroidered Hamper Bag Sample Kit',
        'mini-embroidered-hamper-bag-sample-kit',
        'A curated 3-piece sample kit featuring three embroidered hamper bag designs in different sizes. Designed for customers who want to physically check the fabric, embroidery quality, size, structure, handles, zipper closure and gifting capacity before placing a bulk order. Material Cotton fabric with jute-textured panels Embroidery Detailed multicolour embroidery Handles Rounded woven handles Included Products Royal Elephant Embroidered Hamper Bag | 9 × 6.5 × 4 inches Bouquet Bloom Mini Hamper Bag | 9 × 6.5 × 5 inches Floral Meadow Mini Hamper Bag | 7.5 × 6 × 4 inches Key Features 📦 Includes 3 different Signature Designs of hamper bag. 🌿 Reinforced with 2 mm EVA Foam 📏 Compare sizes before placing bulk orders. 🎨 Perfect for product and packaging trials. ♻️ Reusable and eco-friendly sample kit. Ideal For 🎁 Mini Gift Hampers – Compact bags for curated premium gift sets. 💍 Wedding Return Favors – Elegant reusable packaging for wedding giveaways. 🪔 Festive Gifting – Ideal for Diwali, Rakhi and celebration hampers. 🧴 Beauty &amp; Skincare – Perfect for cosmetics, perfumes and self-care sets. 🍫 Sweets &amp; Dry Fruits – Suitable for chocolates, mithai and dry-fruit gifting.🏢 Corporate Gifting – Premium mini hampers for clients, employees and events.',
        299.0,
        NULL,
        'SK117',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'hamper-bags'),
        'Embroidered Hamper Bag Sample Kit – 4 Designs & Sizes',
        'embroidered-hamper-bag-sample-kit-4-designs-sizes',
        'Explore four signature hamper bags in one sample kit. Compare the fabric, embroidery, size, structure and finish first-hand before selecting the right bag for your bulk order. Included Products Mayura Embroidered Hamper Bag | 15 × 12 × 5 inches Twin Peacock Hamper Bag | 17 × 12 × 5 inches Warli Utsav Hamper Bag | 12 × 12 × 5 inches Tribal Beats Warli Hamper Bag - Green | 12 × 10 × 4 inches Key Features 📦 Includes 4 different Signature Designs of hamper bag. 🌿 Reinforced with 2 mm EVA Foam 📏 Compare sizes before placing bulk orders. 🎨 Perfect for product and packaging trials. ♻️ Reusable and eco-friendly sample kit. Ideal For 🪔 Festive Gifting – Ideal for Diwali, Rakhi and celebration hampers. 🏢 Corporate Gifting – Elegant packaging for clients, employees and events. 🎀 Return Gifts – Reusable bags for weddings, parties and special occasions. 🍫 Luxury Gift Hampers – Perfect for sweets, dry fruits and premium goodies. 🎉 Event Giveaways – Stylish packaging for celebrations, launches and special events.',
        499.0,
        NULL,
        'SK116',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'hamper-bags'),
        'Basket Bag Sample Kit – 3 Colors | 400 GSM',
        'basket-bag-sample-kit-3-colors-400-gsm',
        'Experience the quality before ordering in bulk. The EcoCarry Basket Bags Sample Kit includes 3 premium 400 GSM canvas bags in different colours, helping you check the fabric, structure, stitching, colours and overall finish before choosing your bulk packaging. Material 100% Pure Cotton Fabric Details 400 GSM Quality Standard Size 10 × 9 × 4 Inch (W × H × G) Quantity 3 Sample bags (Each of unique colours) Included Colours Yellow Purple Pink Key Features 📦 Includes 3 different color of mini hamper bag. 🌿 Made from 100% pure 330 GSM cotton. 📏 Compare sizes before placing bulk orders. 🎨 Perfect for product and packaging trials. ♻️ Reusable and eco-friendly sample kit. Ideal For 🎁 Gift Hampers – Compact packaging for curated mini gift sets. 💍 Wedding Return Favors – Premium reusable bags for wedding giveaways. 🏢 Corporate Gifting – Suitable for employee, client and event gifts. 🧴 Cosmetics &amp; Skincare – Package beauty products and mini skincare sets. 🍪 Bakery &amp; Treats – Ideal for cookies, chocolates and packaged treats. 🪔 Festive Packaging – Great for Diwali, wedding and celebration gifting.',
        299.0,
        NULL,
        'SK115',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'embroidery-hamper-bags'),
        'Floral Meadow Mini Hamper Bag',
        'floral-meadow-mini-hamper-bag',
        'A charming mini hamper bag featuring colourful floral embroidery, natural jute-textured panels, sturdy woven handles, a secure zipper closure and a transparent back window. Material Cotton &amp; juco fabric Design Embroidered Floral Bouquet Size 7.5 × 6 × 4 inches (W × H × G) Product Features Premium Natural Jute Fabric Construction Detailed Colourful floral Embroidery Strong &amp; Comfortable Woven Carry Handles Secure Zipper Closure for Better Protection Transparent back window Reusable Design for Premium Gifting &amp; Packaging Ideal For 🎁 Gift Hampers – Create beautifully presented and personalized gift hampers. 🪔 Festive Gifting – Ideal for Diwali, Rakhi and other festive celebrations. 💍 Wedding Gifting – Elegant packaging for wedding hampers, return gifts and special occasions. 💼 Corporate Gifting – Suitable for customized corporate gifts and premium gift kits. 💄 Beauty &amp; Wellness – Perfect for skincare, cosmetics, fragrances and self-care hampers. 🍫 Curated Hampers – Chocolates, dry fruits and small premium gifts.',
        114.89,
        NULL,
        'PM-0011',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'embroidery-hamper-bags'),
        'Bouquet Bloom Mini Hamper Bag',
        'bouquet-bloom-mini-hamper-bag',
        'A charming mini hamper bag featuring detailed floral bouquet embroidery, natural jute-textured accents, rounded woven handles and a secure zipper closure. Compact, structured and ideal for premium gifting. Material Cotton &amp; juco fabric Design Embroidered Floral Bouquet Size 9 × 6.5 × 5 Inch (W x H x G) Product Features Premium Natural Jute Fabric Construction Detailed bouquet artwork Embroidery Strong &amp; Comfortable Woven Carry Handles Secure Zipper Closure for Better Protection Structured 5-Inch Side Gusset for Added Capacity Reusable Design for Premium Gifting &amp; Packaging Ideal For 🎁 Gift Hampers – Create beautifully presented and personalized gift hampers. 🪔 Festive Gifting – Ideal for Diwali, Rakhi and other festive celebrations. 💍 Wedding Gifting – Elegant packaging for wedding hampers, return gifts and special occasions. 💼 Corporate Gifting – Suitable for customized corporate gifts and premium gift kits. 💄 Beauty &amp; Wellness – Perfect for skincare, cosmetics, fragrances and self-care hampers. 🍫 Curated Hampers – Chocolates, dry fruits and small premium gifts.',
        130.0,
        NULL,
        'PM-0012',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'embroidery-hamper-bags'),
        'Diamond Hamper Bag with Canvas Pocket',
        'diamond-hamper-bag-with-canvas-pocket',
        'A premium structured hamper bag featuring an elegant diamond-pattern woven body , a large canvas front pocket , sturdy round woven handles and a secure zipper closure. Its spacious gusseted construction makes it suitable for gifting, everyday carrying and premium packaging. Material Cotton &amp; juco fabric Design Diamond Size 12 x 10 x 5 (W x H x G) Pocket Front cotton canvas pocket Product Features Natural Beige diamond Textured Jute Fabric Large Cotton Front Pocket for Added Utility Strong &amp; Comfortable Round Woven Handles Secure Zipper Closure for Better Protection Structured Side Gusset for Added Capacity Reusable Design for Premium Gifting &amp; Packaging Ideal For 🎁 Gift Hampers – Perfect for creating elegant and thoughtfully curated gift hampers. 🪔 Festive Gifting – Premium presentation for Diwali, Rakhi and celebration hampers. 💍 Wedding Gifting – Elegant packaging for wedding hampers, trousseau gifts and return gifts. 💼 Corporate Gifting – Suitable for branded corporate gifts and premium gift kits. 💄 Beauty &amp; Wellness – Ideal for cosmetics, skincare, fragrances and self-care hampers. 🏪 Retail Packaging – Attractive reusable packaging for boutiques and premium products.',
        157.66,
        NULL,
        'EC211',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'embroidery-hamper-bags'),
        'Kaju Katli Hamper Bag with Double-Sided Pockets',
        'kaju-katli-hamper-bag-with-double-sided-pockets',
        'A premium structured hamper bag featuring a distinctive Kaju Katli-inspired textured weave with a large cotton front pocket. Designed with rounded handles, a secure zipper closure and a spacious gusset, it works beautifully for gifting, hampers and reusable everyday packaging. Material Cotton &amp; juco fabric Design Kaju Katli Size 12 x 10 x 5 (W x H x G) Pocket Front &amp; back cotton canvas pocket Product Features Natural Beige Kaju Katli Textured Jute Fabric Large Cotton Front &amp; Back Pocket for Added Utility Strong &amp; Comfortable Round Woven Handles Secure Zipper Closure for Better Protection Structured Side Gusset for Added Capacity Reusable Design for Premium Gifting &amp; Packaging Ideal For 🎁 Gift Hampers – Perfect for creating elegant and thoughtfully curated gift hampers. 🪔 Festive Gifting – Premium presentation for Diwali, Rakhi and celebration hampers. 💍 Wedding Gifting – Elegant packaging for wedding hampers, trousseau gifts and return gifts. 💼 Corporate Gifting – Suitable for branded corporate gifts and premium gift kits. 💄 Beauty &amp; Wellness – Ideal for cosmetics, skincare, fragrances and self-care hampers. 🏪 Retail Packaging – Attractive reusable packaging for boutiques and premium products.',
        139.75,
        NULL,
        'EC213',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'embroidery-hamper-bags'),
        'Kaju Katli Hamper Bag with Front Pocket',
        'kaju-katli-hamper-bag-with-front-pocket',
        'A premium structured hamper bag featuring a distinctive Kaju Katli-inspired textured weave with a large cotton front pocket. Designed with rounded handles, a secure zipper closure and a spacious gusset, it works beautifully for gifting, hampers and reusable everyday packaging. Material Cotton &amp; juco fabric Design Kaju Katli Size 12 x 10 x 5 (W x H x G) Pocket Front &amp; back cotton canvas pocket Product Features Natural Beige Kaju Katli Textured Jute Fabric Large Cotton Front Pocket for Added Utility Strong &amp; Comfortable Round Woven Handles Secure Zipper Closure for Better Protection Structured Side Gusset for Added Capacity Reusable Design for Premium Gifting &amp; Packaging Ideal For 🎁 Gift Hampers – Perfect for creating elegant and thoughtfully curated gift hampers. 🪔 Festive Gifting – Premium presentation for Diwali, Rakhi and celebration hampers. 💍 Wedding Gifting – Elegant packaging for wedding hampers, trousseau gifts and return gifts. 💼 Corporate Gifting – Suitable for branded corporate gifts and premium gift kits. 💄 Beauty &amp; Wellness – Ideal for cosmetics, skincare, fragrances and self-care hampers. 🏪 Retail Packaging – Attractive reusable packaging for boutiques and premium products.',
        131.63,
        NULL,
        'EC212',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'embroidery-hamper-bags'),
        'Oxford Jute Bag with Window',
        'oxford-jute-bag-with-window',
        'A compact and elegant jute bag designed for premium gifting and product presentation. The Oxford Jute Bag features a natural beige-and-white woven texture, transparent front window, sturdy round handles and a secure zipper closure, making it ideal for curated hampers, festive gifting and reusable packaging. Material Cotton &amp; juco fabric Design Oxford fabric Size 10 x 8.5 x 3 Inch (W x H x G) Front Transparent Display Window Product Features Natural Beige &amp; White Woven Jute Fabric Large Transparent Front Display Window Strong &amp; Comfortable Round Woven Handles Secure Zipper Closure for Better Protection Structured 3-Inch Side Gusset for Added Capacity Reusable Design for Premium Gifting &amp; Packaging Ideal For 🎁 Gift Hampers – Display curated products beautifully through transparent front window. 🪔 Festive Gifting – Premium presentation for Diwali, Rakhi and celebration hampers. 💍 Wedding Gifting – Elegant packaging for wedding hampers and return gifts. 💼 Corporate Gifting – Suitable for branded corporate gifts and premium gift kits. 💄 Beauty &amp; Wellness – Ideal for cosmetics, skincare, fragrances and self-care hampers. 🏪 Retail Packaging – Attractive reusable packaging for boutique and premium products.',
        98.48,
        NULL,
        'PM-0016',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'embroidery-hamper-bags'),
        'Mini Double Diamond Jute Bag with Window',
        'mini-double-diamond-jute-bag-with-window',
        'A compact jute bag featuring a subtle woven pattern, transparent front window and sturdy rope-style handles. The 4-inch gusset provides useful storage space despite its mini size, while the zipper closure keeps contents secure. Ideal for gifting, hampers, product packaging and small gift sets. Material Cotton &amp; juco fabric Design Double Diamond Size 8 × 5.5 × 4 inches (W x H x G) Front Transparent Display Window Product Features Premium Double Diamond Textured Jute Weave Large Transparent Front Display Window Strong &amp; Comfortable Round Woven Handles Secure Zipper Closure for Better Protection Structured Side Gusset for Added Capacity Reusable Design for Premium Gifting &amp; Packaging Ideal For 🎁 Gift Hampers – Display curated products beautifully through transparent window. 🪔 Festive Gifting – Premium presentation for Diwali and celebration hampers. Wedding Gifting – Elegant packaging for return gifts and wedding hampers. 💼 Corporate Gifting – Suitable for premium branded corporate gift kits. 💄 Beauty &amp; Wellness – Ideal for cosmetics, skincare and self-care hampers. 🏪 Retail Packaging – Attractive reusable packaging for premium products',
        90.27,
        NULL,
        'PM-0017',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'embroidery-hamper-bags'),
        'Kajukatli Jute Bag with Window',
        'kajukatli-jute-bag-with-window',
        'A compact premium jute hamper bag featuring an elegant Kajukatli-inspired diamond weave and a transparent front display window. Finished with round woven handles, a secure zipper closure and a structured gusset, it offers an attractive reusable packaging option for gifting, festive hampers and premium products. Material Cotton &amp; juco fabric Design Kajukatli Size 10 x 8 x 4 Inch (W x H x G) Front Transparent Display Window Product Features Premium Kajukatli Diamond Textured Jute Weave Large Transparent Front Display Window Strong &amp; Comfortable Round Woven Handles Secure Zipper Closure for Better Protection Structured 4-Inch Side Gusset for Added Capacity Reusable Design for Premium Gifting &amp; Packaging Ideal For 🎁 Gift Hampers – Display curated products beautifully through transparent front window. 🪔 Festive Gifting – Premium presentation for Diwali, Rakhi and celebration hampers. 💍 Wedding Gifting – Elegant packaging for wedding hampers and return gifts. 💼 Corporate Gifting – Suitable for branded corporate gifts and premium gift kits. 💄 Beauty &amp; Wellness – Ideal for cosmetics, skincare, fragrances and self-care hampers. 🏪 Retail Packaging – Attractive reusable packaging for boutique and premium products.',
        101.76,
        NULL,
        'EC240',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'embroidery-hamper-bags'),
        'Wave Jute Bag with Window',
        'wave-jute-bag-with-window',
        'A premium reusable jute bag featuring an elegant wave-textured weave and a large transparent front window . Designed with sturdy round handles, a secure zipper closure and a spacious gusset, it is ideal for creating attractive gift hampers, festive gifts, corporate kits and premium retail packaging. Material Cotton &amp; juco fabric Design Waves Size 11.5 × 9 × 4 Inch (W x H x G) Front Transparent Display Window Product Features Premium Wave Textured Jute Weave Large Transparent Front Display Window Strong &amp; Comfortable Round Woven Handles Secure Zipper Closure for Better Protection Structured 4-Inch Side Gusset for Added Capacity Reusable Design for Premium Gifting &amp; Packaging Ideal For 🎁 Gift Hampers – Display curated products beautifully through transparent front window. 🪔 Festive Gifting – Premium presentation for Diwali, Rakhi and celebration hampers. 💍 Wedding Gifting – Elegant packaging for wedding hampers and return gifts. 💼 Corporate Gifting – Suitable for branded corporate gifts and premium gift kits. 💄 Beauty &amp; Wellness – Ideal for cosmetics, skincare, fragrances and self-care hampers. 🏪 Retail Packaging – Attractive reusable packaging for boutique and premium products.',
        109.96,
        NULL,
        'EC239',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'embroidery-hamper-bags'),
        'Double Diamond Jute Bag with Window',
        'double-diamond-jute-bag-with-window',
        'A premium reusable jute bag featuring an elegant double-diamond woven texture , transparent front window, round woven handles and secure zipper closure. The structured design makes it especially suitable for gifting, hampers and premium product packaging. Material Cotton &amp; juco fabric Design Double Diamond Size 10 × 8 × 4 inches (W x H x G) Front Transparent Display Window Product Features Premium Double Diamond Textured Jute Weave Large Transparent Front Display Window Strong &amp; Comfortable Round Woven Handles Secure Zipper Closure for Better Protection Structured Side Gusset for Added Capacity Reusable Design for Premium Gifting &amp; Packaging Ideal For 🎁 Gift Hampers – Display curated products beautifully through transparent window. 🪔 Festive Gifting – Premium presentation for Diwali and celebration hampers. Wedding Gifting – Elegant packaging for return gifts and wedding hampers. 💼 Corporate Gifting – Suitable for premium branded corporate gift kits. 💄 Beauty &amp; Wellness – Ideal for cosmetics, skincare and self-care hampers. 🏪 Retail Packaging – Attractive reusable packaging for premium products',
        101.76,
        NULL,
        'EC241',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'embroidery-hamper-bags'),
        'Royal Elephant Embroidered Hamper Bag',
        'royal-elephant-embroidered-hamper-bag',
        'Add a distinctive traditional touch to your gifting with the Royal Elephant Embroidered Hamper Bag . The front features detailed multicolour embroidery with two royal elephants, floral elements and a dedicated circular space that can be used for personalization. Material Cotton &amp; juco fabric Design Royal Elephant &amp; Floral Embroidery Size 9 × 6.5 × 4 Inch (W x H x G) Product Features Premium Natural Jute Fabric Construction Detailed Royal Elephant &amp; Floral Embroidery Strong &amp; Comfortable Woven Carry Handles Secure Zipper Closure for Better Protection Structured 4-Inch Side Gusset for Added Capacity Reusable Design for Premium Gifting &amp; Packaging Ideal For 🎁 Gift Hampers – Create beautifully presented and personalized gift hampers. 🪔 Festive Gifting – Ideal for Diwali, Rakhi and other festive celebrations. 💍 Wedding Gifting – Elegant packaging for wedding hampers, return gifts and special occasions. 💼 Corporate Gifting – Suitable for customized corporate gifts and premium gift kits. 💄 Beauty &amp; Wellness – Perfect for skincare, cosmetics, fragrances and self-care hampers.',
        130.0,
        NULL,
        'PM-0021',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'embroidery-hamper-bags'),
        'Tribal Beats Warli Hamper Bag - Beige',
        'tribal-beats-warli-hamper-bag-beige',
        'Inspired by the rhythmic beats of Warli drums and the joy of tribal celebrations, the Tribal Beats Warli Hamper captures the spirit of togetherness, music, and movement . Each embroidered figure tells a story of community, culture, and timeless Indian heritage - making every gift feel meaningful and alive. Authentic Warli Embroidery: Inspired by tribal dance and festive rhythms, showcasing rich Indian folk art and cultural storytelling. Perfect Hamper Size: Compact yet spacious design measuring 12 × 10 × 4 inches , suitable for festive gifts, return gifts, and premium hampers. Premium &amp; Sturdy Build: Made with high-quality cotton &amp; juco fabric, reinforced with 2 mm EVA foam and inner lining for excellent shape and durability. Functional Design: Secure zipper closure with strong cotton handles for comfortable carrying and long-lasting use. Customizable for Branding: Add your logo, brand name, or custom text , making it ideal for corporate gifting, events, and festive hampers.',
        219.34,
        NULL,
        'PM-0022',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'embroidery-hamper-bags'),
        'Mayura Embroidered Hamper Bag',
        'custom-mayura-embroidered-hamper-bag',
        'Inspired by the timeless beauty of the peacock - India’s symbol of grace, prosperity, and celebration - the Mayura Embroidered Hamper Bag brings together traditional artistry and modern craftsmanship. Each embroidery detail reflects heritage motifs passed through generations, making this bag not just a carrier, but a keepsake meant to be cherished. Spacious &amp; Practical (15 × 12 × 5 inches) – Perfect for festive hampers, wedding gifts, corporate gifting, and premium packaging. Premium Build for Strength – Made with sturdy cotton fabric, reinforced with 2 mm EVA foam inside for excellent structure and long-lasting durability. Thoughtful Details – Features a smooth zipper closure , strong cotton handles for comfortable carrying, and a neat inner fabric lining for a refined finish. Customizable for Branding: Add your logo, brand name, or custom text , making it ideal for corporate gifting, events, and festive hampers. A beautiful blend of elegance, strength, and tradition - designed to elevate every gift you present.',
        235.43,
        NULL,
        'EC046',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'embroidery-hamper-bags'),
        'Tribal Beats Warli Hamper Bag - Green',
        'custom-tribal-beats-warli-hamper-bag-gree',
        'Inspired by the rhythmic beats of Warli drums and the joy of tribal celebrations, the Tribal Beats Warli Hamper captures the spirit of togetherness, music, and movement . Each embroidered figure tells a story of community, culture, and timeless Indian heritage - making every gift feel meaningful and alive. Authentic Warli Embroidery: Inspired by tribal dance and festive rhythms, showcasing rich Indian folk art and cultural storytelling. Perfect Hamper Size: Compact yet spacious design measuring 12 × 10 × 4 inches , suitable for festive gifts, return gifts, and premium hampers. Premium &amp; Sturdy Build: Made with high-quality cotton &amp; juco fabric, reinforced with 2 mm EVA foam and inner lining for excellent shape and durability. Functional Design: Secure zipper closure with strong cotton handles for comfortable carrying and long-lasting use. Customizable for Branding: Add your logo, brand name, or custom text , making it ideal for corporate gifting, events, and festive hampers.',
        219.34,
        NULL,
        'EC130',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'embroidery-hamper-bags'),
        'Twin Peacock Hamper Bag',
        'custom-twin-peacock-hamper-bag',
        'Symbolizing grace, prosperity, and timeless royalty, the Royal Twin Peacock Hamper draws inspiration from India’s regal heritage. The twin peacock embroidery represents harmony and abundance—often seen in palace art and traditional motifs. Designed to elevate gifting, this hamper bag reflects elegance that feels both festive and everlasting. Perfect Hamper Size (17 × 12 × 5 inches) – Ideal for luxury gifting, weddings, festive hampers, and premium corporate gifts. Strong &amp; Structured Build – Made from premium cotton fabric with 2 mm EVA foam padding inside to ensure excellent shape, sturdiness, and durability . Premium Finishing Touches – Features a smooth zipper closure , strong cotton handles for comfortable carrying, and a neat inner fabric lining for a refined look. Customizable for Branding: Add your logo, brand name, or custom text , making it ideal for corporate gifting, events, and festive hampers. Custom logo will be printed on back size as shown in image. A royal blend of craftsmanship, strength, and tradition - crafted to make every gift feel truly special.',
        280.93,
        NULL,
        'EC068',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'embroidery-hamper-bags'),
        'Mitti Ki Kahani Bag',
        'custom-mitti-ki-kahani-bag',
        'Rooted in the warmth of Indian soil, Mitti Ki Kahani Bag tells a story of simple living, skilled hands, and timeless traditions. Inspired by village life and handcrafted artistry, this bag celebrates the beauty of nature, culture, and conscious living - where every stitch carries a story from the earth. Perfectly Sized for Gifting (12 × 10 × 4 inches) – Ideal for return gifts, festive hampers, weddings, and thoughtful corporate gifting. Built for Strength &amp; Shape – Crafted from premium cotton fabric provide sturdiness and long-lasting structure. Premium Finishing – Equipped with a smooth zipper closure , strong cotton handles, and a clean inner fabric lining for a polished, durable finish Customizable for Branding: Add your logo, brand name, or custom text , making it ideal for corporate gifting, events, and festive hampers. A meaningful bag that blends tradition, strength, and sustainability —made to carry stories, not just gifts.',
        219.34,
        NULL,
        'EC057',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'embroidery-hamper-bags'),
        'Tribal Beats Warli Hamper Bag - Navy Blue',
        'custom-tribal-beats-warli-hamper-bag-navy-blue',
        'Inspired by the rhythmic beats of Warli drums and the joy of tribal celebrations, the Tribal Beats Warli Hamper captures the spirit of togetherness, music, and movement . Each embroidered figure tells a story of community, culture, and timeless Indian heritage - making every gift feel meaningful and alive. Authentic Warli Embroidery: Inspired by tribal dance and festive rhythms, showcasing rich Indian folk art and cultural storytelling. Perfect Hamper Size: Compact yet spacious design measuring 12 × 10 × 4 inches , suitable for festive gifts, return gifts, and premium hampers. Premium &amp; Sturdy Build: Made with high-quality cotton &amp; juco fabric, reinforced with 2 mm EVA foam and inner lining for excellent shape and durability. Functional Design: Secure zipper closure with strong cotton handles for comfortable carrying and long-lasting use. Customizable for Branding: Add your logo, brand name, or custom text , making it ideal for corporate gifting, events, and festive hampers.',
        219.34,
        NULL,
        'EC214',
        false
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'embroidery-hamper-bags'),
        'Warli Utsav Hamper Bag',
        'custom-warli-utsav-hamper-bag',
        'Celebrating joy, togetherness, and the rhythm of life, the Warli Utsav Hamper Bag is inspired by India’s timeless Warli folk art. The dancing figures symbolize festivals, community, and gratitude - reminding us that every celebration is richer when shared. Crafted with care, this bag carries not just gifts, but the spirit of tradition and celebration. Ideal Hamper Size (12 × 12 × 5 inches) – Perfect for festive hampers, return gifts, weddings, and thoughtful corporate gifting. Strong &amp; Structured Design – Made with premium cotton and juco fabric, reinforced with 2 mm EVA foam for excellent sturdiness and shape retention. Premium Finishing – Features a smooth zipper closure , strong cotton handles, and neat inner fabric lining for durability and a refined look. Customizable for Branding: Add your logo, brand name, or custom text , making it ideal for corporate gifting, events, and festive hampers. A beautiful blend of culture, craftsmanship, and celebration - designed to make every occasion feel special.',
        195.21,
        NULL,
        'EC057-2',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'large-tote-bags'),
        'Pink Basket Bag | 400 GSM',
        'custom-pink-basket-bag-400-gsm',
        'EcoCarry''s Custom Pink Basket Bag is crafted from premium 400 GSM cotton with strong Pink webbing handles. Its structured design and spacious gusset make it ideal for custom branding, corporate gifting, retail packaging, hampers, and promotional use. Material 100% Pure Cotton Canvas Size 10 × 9 × 4 Inch (25.4 × 22.86 × 10.16 cm) Fabric Details 400 GSM Handle Pink Webbing 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Digital Print For Digital Print Maximum size is 5x4 Inch Embroidery 4 Color threads can be use Key Feautres Premium Heavy-Duty 400 GSM Cotton Fabric Strong &amp; Comfortable Pink Webbing Carry Handle Structured 4-Inch Gusset for Extra Storage Reusable, Durable &amp; Made for Everyday Use Compact Basket-Style Design with Spacious Interior Large Branding Area for Custom Business Logos Ideal For 🎁 Gift Hampers – Perfect for premium hampers and curated gift sets. 🛍️ Boutique &amp; Retail – Reusable branded packaging for products. 💼 Corporate Gifting – Ideal for custom corporate gift kits. 💍 Wedding Gifts – Perfect for branded favours and return gifts. 💄 Beauty Products – Great for cosmetics and skincare sets. 🏪 Brand Merchandise – Custom logo bag for promotions and events.',
        81.98,
        NULL,
        'EC248',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'large-tote-bags'),
        'Purple Basket Bag | 400 GSM',
        'custom-purple-basket-bag-400-gsm',
        'EcoCarry''s Custom Purple Basket Bag is crafted from premium 400 GSM cotton with strong Purple webbing handles. Its structured design and spacious gusset make it ideal for custom branding, corporate gifting, retail packaging, hampers, and promotional use. Material 100% Pure Cotton Canvas Size 10 × 9 × 4 Inch (25.4 × 22.86 × 10.16 cm) Fabric Details 400 GSM Handle Purple Webbing 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Digital Print For Digital Print Maximum size is 5x4 Inch Embroidery 4 Color threads can be use Key Feautres Premium Heavy-Duty 400 GSM Cotton Fabric Strong &amp; Comfortable Purple Webbing Carry Handle Structured 4-Inch Gusset for Extra Storage Reusable, Durable &amp; Made for Everyday Use Compact Basket-Style Design with Spacious Interior Large Branding Area for Custom Business Logos Ideal For 🎁 Gift Hampers – Perfect for premium hampers and curated gift sets. 🛍️ Boutique &amp; Retail – Reusable branded packaging for products. 💼 Corporate Gifting – Ideal for custom corporate gift kits. 💍 Wedding Gifts – Perfect for branded favours and return gifts. 💄 Beauty Products – Great for cosmetics and skincare sets. 🏪 Brand Merchandise – Custom logo bag for promotions and events.',
        81.98,
        NULL,
        'EC246',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'large-tote-bags'),
        'Yellow Basket Bag | 400 GSM',
        'custom-yellow-basket-bag-400-gsm',
        'EcoCarry''s Custom Yellow Basket Bag is crafted from premium 400 GSM cotton with strong yellow webbing handles. Its structured design and spacious gusset make it ideal for custom branding, corporate gifting, retail packaging, hampers, and promotional use. Material 100% Pure Cotton Canvas Size 10 × 9 × 4 Inch (25.4 × 22.86 × 10.16 cm) Fabric Details 400 GSM Handle Yellow Webbing 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Digital Print For Digital Print Maximum size is 5x4 Inch Embroidery 4 Color threads can be use Key Feautres Premium Heavy-Duty 400 GSM Cotton Fabric Strong &amp; Comfortable Yellow Webbing Carry Handle Structured 4-Inch Gusset for Extra Storage Reusable, Durable &amp; Made for Everyday Use Compact Basket-Style Design with Spacious Interior Large Branding Area for Custom Business Logos Ideal For 🎁 Gift Hampers – Perfect for premium hampers and curated gift sets. 🛍️ Boutique &amp; Retail – Reusable branded packaging for products. 💼 Corporate Gifting – Ideal for custom corporate gift kits. 💍 Wedding Gifts – Perfect for branded favours and return gifts. 💄 Beauty Products – Great for cosmetics and skincare sets. 🏪 Brand Merchandise – Custom logo bag for promotions and events.',
        81.98,
        NULL,
        'EC247',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'large-tote-bags'),
        'Navy Blue Large Canvas Tote Bag | 19" x 15" x 6"',
        'custom-navy-blue-large-canvas-tote-bag-19-x-15-x-6',
        'Material 100% Pure Cotton Canvas Size 19" Length x 15" Height x 6" Width Fabric Details 330 GSM Quality | Navy Blue Color Handle Navy Blue Handle Handle Length 24 Inch Long Straps ( 10 Inch Height ) This Navy Blue Large Canvas Tote Bag is made for everyday use. It is strong, spacious, and easy to carry . The simple Navy Blue design looks good with any outfit and is perfect for work, college, shopping, travel, or daily use. Key Features Strong Canvas Material: Made from thick, durable canvas that lasts long. Large Space: Fits books, laptop, clothes, groceries, or daily items easily. Front Pocket: Extra pocket in the front for phone, keys, or small items. Secure Zipper Closure: Keeps all your items safe and prevents things from falling out. Comfortable Straps: Wide straps that sit well on your shoulder. Simple Navy Blue Look: Clean and stylish design for all occasions. Eco-Friendly: Reusable and washable, better for the environment.',
        314.47,
        NULL,
        'PM-0032',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'large-tote-bags'),
        'Black Large Canvas Tote Bag | 19" x 15" x 6"',
        'custom-black-large-canvas-tote-bag-19-x-15-x-6',
        'Material 100% Pure Cotton Canvas Size 19" Length x 15" Height x 6" Width Fabric Details 330 GSM Quality | Black Color Handle Black Handle Handle Length 24 Inch Long Straps ( 10 Inch Height ) This Black Large Canvas Tote Bag is made for everyday use. It is strong, spacious, and easy to carry . The simple black design looks good with any outfit and is perfect for work, college, shopping, travel, or daily use. Key Features Strong Canvas Material: Made from thick, durable canvas that lasts long. Large Space: Fits books, laptop, clothes, groceries, or daily items easily. Front Pocket: Extra pocket in the front for phone, keys, or small items. Secure Zipper Closure: Keeps all your items safe and prevents things from falling out. Comfortable Straps: Wide straps that sit well on your shoulder. Simple Black Look: Clean and stylish design for all occasions. Eco-Friendly: Reusable and washable, better for the environment.',
        314.47,
        NULL,
        'PM-0033',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'large-tote-bags'),
        'Black and Beige Large Canvas Tote Bag | 19" x 15" x 6"',
        'custom-black-and-beige-large-canvas-tote-bag-19-x-15-x-6',
        'Material 100% Pure Cotton Canvas Size 19" Length x 15" Height x 6" Width Fabric Details 330 GSM Quality | Black and Beige Color Handle Black Handle Handle Length 24 Inch Long Straps ( 10 Inch Height ) This Black and Beige Large Canvas Tote Bag is made for everyday use. It is strong, spacious, and easy to carry . The simple black and Beige design looks good with any outfit and is perfect for work, college, shopping, travel, or daily use. Key Features Strong Canvas Material: Made from thick, durable canvas that lasts long. Large Space: Fits books, laptop, clothes, groceries, or daily items easily. Front Pocket: Extra pocket in the front for phone, keys, or small items. Secure Zipper Closure: Keeps all your items safe and prevents things from falling out. Comfortable Straps: Wide straps that sit well on your shoulder. Simple Black and Beige Look: Clean and stylish design for all occasions. Eco-Friendly: Reusable and washable, better for the environment.',
        299.88,
        NULL,
        'PM-0034',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'large-tote-bags'),
        'Brown Large Canvas Tote Bag | 19" x 15" x 6"',
        'custom-brown-large-canvas-tote-bag-19-x-15-x-6',
        'Material 100% Pure Cotton Canvas Size 19" Length x 15" Height x 6" Width Fabric Details 330 GSM Quality | Brown Color Handle Brown Handle Handle Length 24 Inch Long Straps ( 10 Inch Height ) This Brown Large Canvas Tote Bag is made for everyday use. It is strong, spacious, and easy to carry . The simple Brown design looks good with any outfit and is perfect for work, college, shopping, travel, or daily use. Key Features Strong Canvas Material: Made from thick, durable canvas that lasts long. Large Space: Fits books, laptop, clothes, groceries, or daily items easily. Front Pocket: Extra pocket in the front for phone, keys, or small items. Secure Zipper Closure: Keeps all your items safe and prevents things from falling out. Comfortable Straps: Wide straps that sit well on your shoulder. Simple Brown Look: Clean and stylish design for all occasions. Eco-Friendly: Reusable and washable, better for the environment.',
        314.47,
        NULL,
        'PM-0035',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'large-tote-bags'),
        'Yellow and Beige Large Canvas Tote Bag | 19" x 15" x 6"',
        'custom-yellow-and-beige-large-canvas-tote-bag-19-x-15-x-6',
        'Material 100% Pure Cotton Canvas Size 19" Length x 15" Height x 6" Width Fabric Details 330 GSM Quality | Yellow and Beige Color Handle Yellow Handle Handle Length 24 Inch Long Straps ( 10 Inch Height ) This Yellow and Beige Large Canvas Tote Bag is made for everyday use. It is strong, spacious, and easy to carry . The simple Yellow and Beige design looks good with any outfit and is perfect for work, college, shopping, travel, or daily use. Key Features Strong Canvas Material: Made from thick, durable canvas that lasts long. Large Space: Fits books, laptop, clothes, groceries, or daily items easily. Front Pocket: Extra pocket in the front for phone, keys, or small items. Secure Zipper Closure: Keeps all your items safe and prevents things from falling out. Comfortable Straps: Wide straps that sit well on your shoulder. Simple Yellow and Beige Look: Clean and stylish design for all occasions. Eco-Friendly: Reusable and washable, better for the environment.',
        299.88,
        NULL,
        'PM-0036',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'large-tote-bags'),
        'Red and Beige Large Canvas Tote Bag | 19" x 15" x 6"',
        'custom-red-and-beige-large-canvas-tote-bag-19-x-15-x-6',
        'Material 100% Pure Cotton Canvas Size 19" Length x 15" Height x 6" Width Fabric Details 330 GSM Quality | Red and Beige Color Handle Red Handle Handle Length 24 Inch Long Straps ( 10 Inch Height ) This Red and Beige Large Canvas Tote Bag is made for everyday use. It is strong, spacious, and easy to carry . The simple Red and Beige design looks good with any outfit and is perfect for work, college, shopping, travel, or daily use. Key Features Strong Canvas Material: Made from thick, durable canvas that lasts long. Large Space: Fits books, laptop, clothes, groceries, or daily items easily. Front Pocket: Extra pocket in the front for phone, keys, or small items. Secure Zipper Closure: Keeps all your items safe and prevents things from falling out. Comfortable Straps: Wide straps that sit well on your shoulder. Simple Red and Beige Look: Clean and stylish design for all occasions. Eco-Friendly: Reusable and washable, better for the environment.',
        299.88,
        NULL,
        'PM-0037',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'large-tote-bags'),
        'Pink and Beige Large Canvas Tote Bag | 19" x 15" x 6"',
        'custom-pink-and-beige-large-canvas-tote-bag-19-x-15-x-6',
        'Material 100% Pure Cotton Canvas Size 19" Length x 15" Height x 6" Width Fabric Details 330 GSM Quality | Pink and Beige Color Handle Pink Handle Handle Length 24 Inch Long Straps ( 10 Inch Height ) This Pink and Beige Large Canvas Tote Bag is made for everyday use. It is strong, spacious, and easy to carry . The simple Pink and Beige design looks good with any outfit and is perfect for work, college, shopping, travel, or daily use. Key Features Strong Canvas Material: Made from thick, durable canvas that lasts long. Large Space: Fits books, laptop, clothes, groceries, or daily items easily. Front Pocket: Extra pocket in the front for phone, keys, or small items. Secure Zipper Closure: Keeps all your items safe and prevents things from falling out. Comfortable Straps: Wide straps that sit well on your shoulder. Simple Pink and Beige Look: Clean and stylish design for all occasions. Eco-Friendly: Reusable and washable, better for the environment.',
        299.88,
        NULL,
        'PM-0038',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'large-tote-bags'),
        'Purple and Beige Large Canvas Tote Bag | 19" x 15" x 6"',
        'custom-purple-and-beige-large-canvas-tote-bag-19-x-15-x-6',
        'Material 100% Pure Cotton Canvas Size 19" Length x 15" Height x 6" Width Fabric Details 330 GSM Quality | Purple and Beige Color Handle Purple Handle Handle Length 24 Inch Long Straps ( 10 Inch Height ) This Purple and Beige Large Canvas Tote Bag is made for everyday use. It is strong, spacious, and easy to carry . The simple Purple and Beige design looks good with any outfit and is perfect for work, college, shopping, travel, or daily use. Key Features Strong Canvas Material: Made from thick, durable canvas that lasts long. Large Space: Fits books, laptop, clothes, groceries, or daily items easily. Front Pocket: Extra pocket in the front for phone, keys, or small items. Secure Zipper Closure: Keeps all your items safe and prevents things from falling out. Comfortable Straps: Wide straps that sit well on your shoulder. Simple Purple and Beige Look: Clean and stylish design for all occasions. Eco-Friendly: Reusable and washable, better for the environment.',
        299.88,
        NULL,
        'PM-0039',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'large-tote-bags'),
        'Sky Blue and Beige Large Canvas Tote Bag | 19" x 15" x 6"',
        'custom-sky-blue-and-beige-large-canvas-tote-bag-19-x-15-x-6',
        'Material 100% Pure Cotton Canvas Size 19" Length x 15" Height x 6" Width Fabric Details 330 GSM Quality | Sky Blue and Beige Color Handle Sky Blue Handle Handle Length 24 Inch Long Straps ( 10 Inch Height ) This Sky Blue and Beige Large Canvas Tote Bag is made for everyday use. It is strong, spacious, and easy to carry . The simple Sky Blue and Beige design looks good with any outfit and is perfect for work, college, shopping, travel, or daily use. Key Features Strong Canvas Material: Made from thick, durable canvas that lasts long. Large Space: Fits books, laptop, clothes, groceries, or daily items easily. Front Pocket: Extra pocket in the front for phone, keys, or small items. Secure Zipper Closure: Keeps all your items safe and prevents things from falling out. Comfortable Straps: Wide straps that sit well on your shoulder. Simple Sky Blue and Beige Look: Clean and stylish design for all occasions. Eco-Friendly: Reusable and washable, better for the environment.',
        299.88,
        NULL,
        'PM-0040',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'large-tote-bags'),
        'Brown and Beige Large Canvas Tote Bag | 19" x 15" x 6"',
        'custom-brown-and-beige-large-canvas-tote-bag-19-x-15-x-6',
        'Material 100% Pure Cotton Canvas Size 19" Length x 15" Height x 6" Width Fabric Details 330 GSM Quality | Brown and Beige Color Handle Brown Handle Handle Length 24 Inch Long Straps ( 10 Inch Height ) This Brown and Beige Large Canvas Tote Bag is made for everyday use. It is strong, spacious, and easy to carry . The simple Brown and Beige design looks good with any outfit and is perfect for work, college, shopping, travel, or daily use. Key Features Strong Canvas Material: Made from thick, durable canvas that lasts long. Large Space: Fits books, laptop, clothes, groceries, or daily items easily. Front Pocket: Extra pocket in the front for phone, keys, or small items. Secure Zipper Closure: Keeps all your items safe and prevents things from falling out. Comfortable Straps: Wide straps that sit well on your shoulder. Simple Brown and Beige Look: Clean and stylish design for all occasions. Eco-Friendly: Reusable and washable, better for the environment.',
        299.88,
        NULL,
        'PM-0041',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'large-tote-bags'),
        'Navy Blue and Beige Large Canvas Tote Bag | 19" x 15" x 6"',
        'custom-navy-blue-and-beige-large-canvas-tote-bag-19-x-15-x-6',
        'Material 100% Pure Cotton Canvas Size 19" Length x 15" Height x 6" Width Fabric Details 330 GSM Quality | Navy Blue and Beige Color Handle Navy Blue Handle Handle Length 24 Inch Long Straps ( 10 Inch Height ) This Navy Blue and Beige Large Canvas Tote Bag is made for everyday use. It is strong, spacious, and easy to carry . The simple Navy Blue and Beige design looks good with any outfit and is perfect for work, college, shopping, travel, or daily use. Key Features Strong Canvas Material: Made from thick, durable canvas that lasts long. Large Space: Fits books, laptop, clothes, groceries, or daily items easily. Front Pocket: Extra pocket in the front for phone, keys, or small items. Secure Zipper Closure: Keeps all your items safe and prevents things from falling out. Comfortable Straps: Wide straps that sit well on your shoulder. Simple Navy Blue and Beige Look: Clean and stylish design for all occasions. Eco-Friendly: Reusable and washable, better for the environment.',
        299.88,
        NULL,
        'PM-0042',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'hamper-bags'),
        'Office Bag for Men and Women - Navy Blue',
        'office-bag-for-men-and-women-navy-blue',
        'Stylish office bag for men and women. Shop high-quality office bags for ladies, girls, and professionals. Perfect blend of style and practicality. 𝐅𝐚𝐛𝐫𝐢𝐜 - 𝐂𝐨𝐭𝐭𝐨𝐧 𝐂𝐨𝐥𝐨𝐫 - 𝐍𝐚𝐯𝐲 𝐁𝐥𝐮𝐞 𝐒𝐢𝐳𝐞 - 𝟏𝟏𝐱𝟏𝟑 𝐢𝐧𝐜𝐡 𝐖𝐞𝐢𝐠𝐡𝐭 - 𝟑𝟑𝟎 𝐆𝐒𝐌 𝐒𝐭𝐢𝐭𝐜𝐡𝐢𝐧𝐠 - 𝐇𝐚𝐧𝐝 𝐒𝐭𝐢𝐭𝐜𝐡𝐞𝐝 This is a handmade product, so the actual measurements may be slightly more than or equal to the specified size. 𝐂𝐚𝐫𝐞: The office bag are washable. Wash them with mild detergent and cold water. Iron after washing for a neat look.',
        545.02,
        NULL,
        'PM-0043',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'large-tote-bags'),
        'Large Canvas Tote Bag Sample Kit – 2 Bags | 330 GSM',
        'large-canvas-tote-bag-sample-kit-330-gsm',
        'Experience the size, strength, fabric and finish before ordering in bulk. The Large Canvas Tote Bag Sample Kit includes two spacious 330 GSM canvas tote bags , designed for everyday carrying, shopping, travel and branded business use. Material 100% Pure Cotton Fabric Details 33 0 GSM Quality Quantity 2 Sample Bags Bag Size 19 × 15 × 6 Inch Handle size 24 Inch Long Straps What''s Included Black Large Canvas Tote Bag | 19×15×6 Inch Navy Blue &amp; Beige Large Canvas Tote Bag | 19×15×6 Inch Key Features 🎨 Includes 2 stylish different color combinations. 💪 Made from premium 330 GSM cotton canvas. 🌈 Compare colors before placing bulk orders. ♻️ Reusable and eco-friendly sample kit. Ideal For 💼 Work &amp; Office – Spacious enough for everyday work essentials, notebooks and accessories. 🛍️ Shopping – Large reusable design for shopping and retail use. ✈️ Travel – Useful as an additional carry bag for travel essentials. 👝 Daily Carry – Large capacity with comfortable shoulder-length straps. 🎁 Corporate Gifting – Premium canvas construction suitable for branded gift kits. 🏪 Brand Merchandise – Add your custom DTF logo for retail merchandise or promotional campaigns.',
        599.0,
        NULL,
        'SK114',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'saree-covers'),
        'Cotton Saree Cover Sample Kit - 5 Covers | 150 GSM',
        'cotton-saree-cover-sample-kit-150-gsm',
        'Check the fabric, size, finish and customization possibilities before placing your bulk order. The EcoCarry Cotton Saree Cover Sample Kit includes 5 reusable 150 GSM cotton saree covers across two sizes, including plain, personalised and custom-logo-ready options. Material 100% Pure Cotton Fabric Details 150 GSM Quality Quantity 5 Sample Covers Included Products Light Brown – 16 × 14 Inch Pastel Pink – 16 × 14 Inch Pastel Yellow – 16 × 14 Inch Beige – 14 × 16 Inch Beige – 16 × 14 Inch Key Features 📦 Includes 5 different sample of Saree Cover. 🌿 Made from 100% pure 150 GSM cotton. 📏 Compare sizes before placing bulk orders. 🎨 Perfect for product and packaging trials. ♻️ Reusable and eco-friendly sample kit. Ideal For 👗 Saree Storage – Keeps folded sarees neatly organized in wardrobes. 💍 Wedding Trousseau – Elegant packaging for bridal saree collections. 🎁 Festive Gifting – Reusable presentation for festive and family gifting. 🏪 Boutique Packaging – Premium packaging for saree &amp; ethnic-wear businesses. 🧵 Saree Businesses – Add your branding for a more professional customer experience. 👰 Personalised Gifting – Add a recipient''s name for weddings and special occasions.',
        299.0,
        NULL,
        'SK113',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'hamper-bags'),
        'Mini Hamper Bag Sample Kit - 7 colors | 330 GSM',
        'mini-hamper-bag-sample-kit-7-colors-330-gsm',
        'Experience the quality before ordering in bulk. The EcoCarry Mini Hamper Bag Sample Kit includes 7 premium 330 GSM canvas bags in different colours, helping you check the fabric, structure, stitching, colours and overall finish before choosing your bulk packaging. Material 100% Pure Cotton Fabric Details 330 GSM Quality Quantity 7 Sample bags (Each of unique colours) Included Colours Brown Beige Light Pink Lavender Sage Green Black Navy Blue Key Features 📦 Includes 7 different color of mini hamper bag. 🌿 Made from 100% pure 330 GSM cotton. 📏 Compare sizes before placing bulk orders. 🎨 Perfect for product and packaging trials. ♻️ Reusable and eco-friendly sample kit. Ideal For 🎁 Gift Hampers – Compact packaging for curated mini gift sets. 💍 Wedding Return Favors – Premium reusable bags for wedding giveaways. 🏢 Corporate Gifting – Suitable for employee, client and event gifts. 🧴 Cosmetics &amp; Skincare – Package beauty products and mini skincare sets. 🍪 Bakery &amp; Treats – Ideal for cookies, chocolates and packaged treats. 🪔 Festive Packaging – Great for Diwali, wedding and celebration gifting.',
        399.0,
        NULL,
        'SK112',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'drawstring-bags'),
        'Embroidered Drawstring Pouch Sample Kit | 150 GSM',
        'embroidered-drawstring-pouch-sample-kit-150-gsm',
        'The EcoCarry Embroidered Drawstring Pouch Sample Kit is designed for businesses that want to check pouch sizes, fabric quality, embroidery designs, colours, and finishing before placing a bulk order. The kit includes 8 embroidered cotton-linen drawstring pouches across 2 popular sizes , making it easier to compare different styles and select the right option for gifting, jewellery packaging, return favors, retail packaging, and more. Material 100% Pure Cotton Fabric Details 150 GSM Quality Quantity 8 Sample Pouches Included Sizes Sunflower Embroidered Cotton Drawstring Pouch Bag | 4.5×6.5 Inch Floral Embroidered Cotton Drawstring Pouch | 4.5×6.5 Inch Pink Floral Embroidered Cotton Drawstring Pouch Bag | 4.5×6.5 Inch Butterfly Embroidered Cotton Drawstring Pouch Bag | 4.5×6.5 Inch Rainbow Embroidered Cotton Drawstring Pouch Bag | 4.5×6.5 Inch Floral Pink Embroidered Drawstring Bag | 8x9 inch Floral Yellow Embroidered Drawstring Bag | 8x9 inch Floral Brown Embroidered Drawstring Bag | 8x9 inch Key Features 📦 Includes 8 different drawstring bag sample. 🌿 Made from 100% pure 150 GSM cotton. 📏 Compare sizes before placing bulk orders. 🎨 Perfect for product and packaging trials. ♻️ Reusable and eco-friendly sample kit. Ideal For 💎 Jewellery Packaging – Rings, earrings, bracelets and small accessories. 💍 Wedding Return Favors – Elegant reusable packaging for wedding giveaways. 🎁 Gift Packaging – Premium presentation for small gifts and hampers. 🌸 Potpourri &amp; Dry Flowers – Decorative storage and gifting. ✈️ Travel Essentials – Organize smaller personal and travel items. 🪔 Festive Gifting – Suitable for Diwali, weddings and festive hampers.',
        399.0,
        NULL,
        'SK101',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'canvas-tote-bags'),
        'Canvas Tote Bag Sample Kit - 8 Colors | 330 GSM',
        '1-color-cotton-canvas-tote-bag-sample-kit-8-colors-330-gsm',
        'Explore EcoCarry''s premium coloured canvas tote bags before bulk ordering. Compare colors, fabric quality, and craftsmanship to find the perfect match for your brand. Material 100% Pure Cotton Fabric Details 33 0 GSM Quality Quantity 8 Tote Bags (1 Piece of Each Bag) What''s Included 12"x14" Wine Tote Bag | 330 GSM 13"x15" Beige Tote Bag | 330 GSM 13"x15" Navy Blue Tote Bag | 330 GSM 14"x16" Red Tote Bag | 330 GSM 14"×16" Navy Blue Tote Bag | 330 GSM 13"x15" Pink Tote Bag | 330 GSM 13"x15" Plain Black and Yellow Tote Bag | 330 GSM 13"x15" Brown Tote Bag | 330 GSM Key Features 🎨 Includes 8 stylish different color combinations. 💪 Made from premium 330 GSM cotton canvas. 🌈 Compare colors before placing bulk orders. ♻️ Reusable and eco-friendly sample kit. Ideal For 🛍️ Bulk Order Planning – Compare colors before placing bulk orders. 🏷️ Brand Selection – Find the best color for your business. 🎁 Corporate Gifting – Choose bags for events and promotions. 👕 Retail &amp; Fashion Brands – Match colors with your brand identity. 🌿 Quality Evaluation – Check fabric, stitching, and overall finish.',
        799.0,
        NULL,
        'SK102',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'pouch-bags'),
        '5x5x3 Canvas Zipper Pouch',
        'custom-5x5x3-canvas-zipper-pouch',
        'EcoCarry''s Custom Canvas Zipper Pouch is made from durable 390 GSM cotton canvas with a spacious box gusset and smooth zipper closure. Ideal for travel, office essentials, cosmetics, and stationery. Material 100% Cotton Canvas Fabric Quality 390 GSM Size 5 × 5 × 3 Inch (12.7 × 12.7 × 7.6 cm) Closure Smooth Zipper Digital Print For Digital Print Maximum size is 3x2.5 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use Key Features Premium 390 GSM Cotton Canvas Spacious 4-Inch Box Gusset Heavy-Duty Smooth Zipper Reinforced Stitching Convenient Side Loop Handle Reusable &amp; Washable Large Printable Area for Branding Ideal For 🏢 Corporate Gifting – Premium branded gifts for employees and clients. 🎁 Employee Welcome Kits – Ideal for onboarding essentials. 🎪 Promotional Giveaways – Perfect for exhibitions and marketing events. 🛍️ Retail Packaging – Stylish branded packaging for premium products. ✈️ Travel Kits – Organize travel essentials with custom branding. 🌿 Brand Merchandise – Reusable promotional pouch for businesses.',
        76.8,
        NULL,
        'PM-0049',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'pouch-bags'),
        '7x6x4 Canvas Zipper Pouch',
        'custom-7x6x4-canvas-zipper-pouch',
        'EcoCarry''s Custom Canvas Zipper Pouch is made from durable 390 GSM cotton canvas with a spacious box gusset and smooth zipper closure. Ideal for travel, office essentials, cosmetics, and stationery. Material 100% Cotton Canvas Fabric Quality 390 GSM Size 7 × 6 × 4 Inch (17.8 × 15.2 × 10.2 cm) Closure Smooth Zipper Digital Print For Digital Print Maximum size is 4x3 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use Key Features Premium 390 GSM Cotton Canvas Spacious 4-Inch Box Gusset Heavy-Duty Smooth Zipper Reinforced Stitching Convenient Side Loop Handle Reusable &amp; Washable Large Printable Area for Branding Ideal For 🏢 Corporate Gifting – Premium branded gifts for employees and clients. 🎁 Employee Welcome Kits – Ideal for onboarding essentials. 🎪 Promotional Giveaways – Perfect for exhibitions and marketing events. 🛍️ Retail Packaging – Stylish branded packaging for premium products. ✈️ Travel Kits – Organize travel essentials with custom branding. 🌿 Brand Merchandise – Reusable promotional pouch for businesses.',
        99.4,
        NULL,
        'PM-0050',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'pouch-bags'),
        '10×7×4 Canvas Zipper Pouch',
        'custom-10x7x4-canvas-zipper-pouch',
        'EcoCarry''s Custom Canvas Zipper Pouch is made from durable 390 GSM cotton canvas with a spacious box gusset and smooth zipper closure. Ideal for travel, office essentials, cosmetics, and stationery. Material 100% Cotton Canvas Fabric Quality 390 GSM Size 10 × 7 × 4 Inch (25.4 × 17.8 × 10.2 cm) Closure Smooth Zipper Digital Print For Digital Print Maximum size is 5x3.5 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use Key Features Premium 390 GSM Cotton Canvas Spacious 4-Inch Box Gusset Heavy-Duty Smooth Zipper Reinforced Stitching Convenient Side Loop Handle Reusable &amp; Washable Large Printable Area for Branding Ideal For 🏢 Corporate Gifting – Premium branded gifts for employees and clients. 🎁 Employee Welcome Kits – Ideal for onboarding essentials. 🎪 Promotional Giveaways – Perfect for exhibitions and marketing events. 🛍️ Retail Packaging – Stylish branded packaging for premium products. ✈️ Travel Kits – Organize travel essentials with custom branding. 🌿 Brand Merchandise – Reusable promotional pouch for businesses.',
        121.9,
        NULL,
        'PM-0051',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'pouch-bags'),
        '7x5x2 Utility Cotton Zipper Pouch',
        'custom-7x5x2-utility-cotton-zipper-pouch',
        'EcoCarry''s Custom Canvas Utility Pouch is made from durable 390 GSM cotton canvas with a spacious box gusset and smooth zipper closure. Ideal for travel, office essentials, cosmetics, and stationery. Material 100% Cotton Canvas Fabric Quality 390 GSM Size 7 × 5 × 2 Inch (17.78 × 12.7 × 5.08 cm) Closure Smooth Zipper Digital Print For Digital Print Maximum size is 3x2.5 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use Key Features Premium 390 GSM Cotton Canvas Smooth Premium Zipper Closure Spacious Box Gusset Base Reinforced Stitching Wide Opening for Easy Access Reusable &amp; Washable Large Printable Area for Branding Ideal For 🏢 Corporate Gifting – Premium branded gifts for employees and clients. 🎁 Employee Welcome Kits – Ideal for onboarding essentials. 🎪 Promotional Giveaways – Perfect for exhibitions and marketing events. 🛍️ Retail Packaging – Stylish branded packaging for premium products. ✈️ Travel Kits – Organize travel essentials with custom branding. 🌿 Brand Merchandise – Reusable promotional pouch for businesses.',
        34.3,
        NULL,
        'PM-0052',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'pouch-bags'),
        '8x6x2 Utility Cotton Zipper Pouch',
        'custom-8x6x2-utility-cotton-zipper-pouch',
        'EcoCarry''s Custom Canvas Utility Pouch is made from durable 390 GSM cotton canvas with a spacious box gusset and smooth zipper closure. Ideal for travel, office essentials, cosmetics, and stationery. Material 100% Cotton Canvas Fabric Quality 390 GSM Size 8 × 6 × 2 Inch (20.32 × 15.24 × 5.08 cm) Closure Smooth Zipper Digital Print For Digital Print Maximum size is 4 x3 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use Key Features Premium 390 GSM Cotton Canvas Smooth Premium Zipper Closure Spacious Box Gusset Base Reinforced Stitching Wide Opening for Easy Access Reusable &amp; Washable Large Printable Area for Branding Ideal For 🏢 Corporate Gifting – Premium branded gifts for employees and clients. 🎁 Employee Welcome Kits – Ideal for onboarding essentials. 🎪 Promotional Giveaways – Perfect for exhibitions and marketing events. 🛍️ Retail Packaging – Stylish branded packaging for premium products. ✈️ Travel Kits – Organize travel essentials with custom branding. 🌿 Brand Merchandise – Reusable promotional pouch for businesses.',
        41.9,
        NULL,
        'PM-0053',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'pouch-bags'),
        '10×7.5×2.5 Utility Cotton Zipper Pouch',
        'custom-10x7-5x2-5-utility-cotton-zipper-pouch',
        'EcoCarry''s Custom Canvas Utility Pouch is made from durable 390 GSM cotton canvas with a spacious box gusset and smooth zipper closure. Ideal for travel, office essentials, cosmetics, and stationery. Material 100% Cotton Canvas Fabric Quality 390 GSM Size 10 × 7.5 × 2.5 Inch (25.4 × 19.05 × 6.35 cm) Closure Smooth Zipper Digital Print For Digital Print Maximum size is 5 x3.5 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use Key Features Premium 390 GSM Cotton Canvas Smooth Premium Zipper Closure Spacious Box Gusset Base Reinforced Stitching Wide Opening for Easy Access Reusable &amp; Washable Large Printable Area for Branding Ideal For 🏢 Corporate Gifting – Premium branded gifts for employees and clients. 🎁 Employee Welcome Kits – Ideal for onboarding essentials. 🎪 Promotional Giveaways – Perfect for exhibitions and marketing events. 🛍️ Retail Packaging – Stylish branded packaging for premium products. ✈️ Travel Kits – Organize travel essentials with custom branding. 🌿 Brand Merchandise – Reusable promotional pouch for businesses.',
        57.3,
        NULL,
        'PM-0054',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '14×16 Navy Blue Tote Bag | 330 GSM',
        'custom-14x16-navy-blue-tote-bag-330-gsm',
        'EcoCarry''s Custom 14×16 Navy Blue Tote Bag is crafted from premium 330 GSM cotton canvas and designed for custom branding. Its elegant navy blue finish makes it ideal for corporate gifting, retail packaging, promotional events, and professional business branding. Material 100% Cotton Canvas Fabric Quality 330 GSM Size 14 × 16 Inch (35.56 × 40.64 cm) Handle Type 24 Inch Long Strong Shoulder Handles Digital Print For Digital Print Maximum size is 7 x4.5 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use Key Features Premium 330 GSM Cotton Canvas Elegant Navy Blue Finish Strong 26-Inch Cotton Handles Spacious Main Compartment Reinforced Stitching Reusable &amp; Eco-Friendly Large Printable Area for Branding Ideal For 🏢 Corporate Gifting – Perfect for employee and client gifts. 🛍️ Retail Packaging – Premium branded shopping bags. 🎪 Promotional Events – Great for exhibitions and giveaways. 🏬 Business Branding – Showcase your logo professionally. 🎁 Gift Hampers – Elegant packaging for special occasions. 🌿 Eco-Friendly Promotions – Reusable branded bags for businesses.',
        84.3,
        NULL,
        'EC290',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '14x16 Red Tote Bag | 330 GSM',
        'custom-14x16-red-tote-bag-330-gsm',
        'EcoCarry''s Custom 14×16 Red Tote Bag is crafted from premium 330 GSM cotton canvas and designed for custom branding. Its vibrant red finish makes it ideal for corporate gifting, retail packaging, promotional events, and business branding. Material 100% Cotton Canvas Fabric Quality 330 GSM Size 14 × 16 Inch (35.56 × 40.64 cm) Handle Type 24 Inch Long Strong Shoulder Handles Digital Print For Digital Print Maximum size is 7 x4.5 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use Key Features Premium 330 GSM Cotton Canvas Vibrant Red Color Strong 26-Inch Cotton Handles Spacious Main Compartment Reinforced Stitching Reusable &amp; Eco-Friendly Large Printable Area for Branding Ideal For 🏢 Corporate Gifting – Perfect for employee and client gifts. 🛍️ Retail Packaging – Premium branded shopping bags. 🎪 Promotional Events – Great for exhibitions and giveaways. 🏬 Business Branding – Showcase your logo professionally. 🎁 Gift Hampers – Elegant packaging for special occasions. 🌿 Eco-Friendly Promotions – Reusable branded bags for businesses.',
        84.3,
        NULL,
        'EC291',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '12"x14" Wine Tote Bag | 330 GSM',
        'custom-12x14-wine-tote-bag-330-gsm',
        'EcoCarry''s Custom 12×14 Wine Tote Bag is crafted from premium 330 GSM cotton canvas and designed for custom branding. Its elegant wine-purple finish makes it ideal for corporate gifting, retail packaging, promotional events, and business branding. Material 100% Cotton Canvas Fabric Quality 330 GSM Size 12 × 14 Inch (30.48 × 35.56 cm) Handle Type 24 Inch Long Strong Shoulder Handles Digital Print For Digital Print Maximum size is 6x5 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use Key Features Premium 330 GSM Cotton Canvas Elegant Wine Purple Finish Strong 26-Inch Cotton Handles Spacious Main Compartment Reinforced Stitching Reusable &amp; Eco-Friendly Large Printable Area for Branding Ideal For 🏢 Corporate Gifting – Perfect for employee and client gifts. 🛍️ Retail Packaging – Premium branded shopping bags. 🎪 Promotional Events – Great for exhibitions and giveaways. 🏬 Business Branding – Showcase your logo professionally. 🎁 Gift Hampers – Elegant packaging for special occasions. 🌿 Eco-Friendly Promotions – Reusable branded bags for businesses.',
        88.1,
        NULL,
        'PM-0057',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '14"x16" Wine Tote Bag | 330 GSM',
        'custom-14x16-wine-tote-bag-330-gsm',
        'EcoCarry''s Custom 14×16 Wine Tote Bag is crafted from premium 330 GSM cotton canvas and designed for custom branding. Its elegant wine-purple finish makes it ideal for corporate gifting, retail packaging, promotional events, and business branding. Material 100% Cotton Canvas Fabric Quality 330 GSM Size 14 × 16 Inch (35.56 × 40.64 cm) Handle Type 24 Inch Long Strong Shoulder Handles Digital Print For Digital Print Maximum size is 7 x4.5 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use Key Features Premium 330 GSM Cotton Canvas Elegant Wine Purple Finish Strong 26-Inch Cotton Handles Spacious Main Compartment Reinforced Stitching Reusable &amp; Eco-Friendly Large Printable Area for Branding Ideal For 🏢 Corporate Gifting – Perfect for employee and client gifts. 🛍️ Retail Packaging – Premium branded shopping bags. 🎪 Promotional Events – Great for exhibitions and giveaways. 🏬 Business Branding – Showcase your logo professionally. 🎁 Gift Hampers – Elegant packaging for special occasions. 🌿 Eco-Friendly Promotions – Reusable branded bags for businesses.',
        106.9,
        NULL,
        'PM-0058',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        'Sunflower Bliss Embroidered Tote',
        'sunflower-bliss-embroidered-tote',
        'Add a touch of elegance to your everyday style with this beautifully embroidered tote bag. Designed with delicate Blue Sunflower Bliss embroidery on a soft pastel blue canvas, this bag is perfect for carrying your essentials in style. Features: ✔️ Premium Embroidery – Intricate floral embroidery for a charming and handcrafted touch. ✔️ Lightweight – Large enough to fit your books, laptop, or daily essentials. ✔️ Durable Cotton Canvas – Made from high-quality fabric for long-lasting use. ✔️ Secure Closure – Features a zipper/drawstring to keep your belongings safe. ✔️ Eco-Friendly &amp; Reusable – A sustainable alternative to plastic bags. Whether you''re heading to work, college, shopping, or a casual day out, this floral tote bag adds a fresh, stylish, and practical touch to your outfit. 🌿✨ 📏 Size: [14 x 16 Inch] 👜 Material: 100% Cotton Canvas 🎨 Color: Pastel Blue with Yellow Sunflower Bliss Embroidery',
        399.0,
        NULL,
        'CT01',
        false
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '12x14 Inch Black Cotton Tote Bag | 220 GSM',
        'custom-12x14-inch-black-cotton-tote-bag-220-gsm',
        'Material 100% Pure Cotton Size 12x14 Inch Fabric Details 220 GSM Quality 1 &amp; 2 Color Hand Screen Print - No size Limit Digital Print Heat Transfer DTF - Maximum size 6x5 Inch Embroidery Machine Embroidery - Maximum size 6x6 Inch - 4 Color Max . Key Features: ✅100% Natural Cotton – Eco-friendly, reusable, and biodegradable, making it the perfect alternative to plastic bags. ✅Strong &amp; Durable – Premium stitching and sturdy canvas fabric hold groceries, fruits, vegetables, books, and more with ease. ✅DIY &amp; Customizable – Ideal for screen printing, embroidery, fabric painting, tie-dye, and heat transfer vinyl – perfect for businesses, events, and personal use. ✅Multipurpose Tote – Use as a shopping bag, grocery bag, gift bag, craft project, corporate branding bag, or everyday carry-all. ✅Lightweight &amp; Convenient – Easy to fold, store, and c',
        61.5,
        NULL,
        'EC264',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '14x18 Inch Black Cotton Tote Bag | 220 GSM',
        'custom-14x18-inch-black-cotton-tote-bag-220-gsm',
        'Material 100% Pure Cotton Size 14x18 Inch Fabric Details 220 GSM Quality 1 &amp; 2 Color Hand Screen Print - No size Limit Digital Print Heat Transfer DTF - Maximum size 8x5 Inch Embroidery Machine Embroidery - Maximum size 8x8 Inch - 4 Color Max . Key Features: ✅100% Natural Cotton – Eco-friendly, reusable, and biodegradable, making it the perfect alternative to plastic bags. ✅Strong &amp; Durable – Premium stitching and sturdy canvas fabric hold groceries, fruits, vegetables, books, and more with ease. ✅DIY &amp; Customizable – Ideal for screen printing, embroidery, fabric painting, tie-dye, and heat transfer vinyl – perfect for businesses, events, and personal use. ✅Multipurpose Tote – Use as a shopping bag, grocery bag, gift bag, craft project, corporate branding bag, or everyday carry-all. ✅Lightweight &amp; Convenient – Easy to fold, store, and c',
        75.8,
        NULL,
        'EC266',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '14x16 Inch Black Cotton Tote Bag | 220 GSM',
        'custom-14x16-inch-black-cotton-tote-bag-220-gsm',
        'Material 100% Pure Cotton Size 14x16 Inch Fabric Details 220 GSM Quality 1 &amp; 2 Color Hand Screen Print - No size Limit Digital Print Heat Transfer DTF - Maximum size 7x4.5 Inch Embroidery Machine Embroidery - Maximum size 7x6 Inch - 4 Color Max . Key Features: ✅100% Natural Cotton – Eco-friendly, reusable, and biodegradable, making it the perfect alternative to plastic bags. ✅Strong &amp; Durable – Premium stitching and sturdy canvas fabric hold groceries, fruits, vegetables, books, and more with ease. ✅DIY &amp; Customizable – Ideal for screen printing, embroidery, fabric painting, tie-dye, and heat transfer vinyl – perfect for businesses, events, and personal use. ✅Multipurpose Tote – Use as a shopping bag, grocery bag, gift bag, craft project, corporate branding bag, or everyday carry-all. ✅Lightweight &amp; Convenient – Easy to fold, store, and c',
        71.2,
        NULL,
        'EC265',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'canvas-tote-bags'),
        '9×11×4 Jute Tote Bags with Canvas Front Pocket | 350 GSM',
        'custom-9x11x4-jute-tote-bags-with-canvas-front-pocket-350-gsm',
        'EcoCarry''s Custom 9 × 11 × 4 Jute Tote Bag with Canvas Front Pocket combines premium 350 GSM natural jute, a compact design, and a spacious canvas front pocket for custom branding. Ideal for retail packaging, corporate gifting, promotional events, exhibitions, and eco-friendly business packaging. Material 100% Natural Jute Fabric Fabric Quality 350 GSM Size 9x11x4 Inch (22.86 × 27.94 × 10.16 cm) Handle Type 20 Inch Soft Padded Jute Handles Front Pocket Large Cotton Canvas Pocket Screen Printing 1 &amp; 2 Color Printing (No Print Size Limit) DTF Printing Multicolor Printing (Maximum Print Size: 4 × 3 Inch) Key Features 🌿 Premium 350 GSM Natural Jute Fabric 👜 Large Cotton Canvas Front Pocket for Custom Printing 💪 Reinforced Stitching for Long-Lasting Durability 🤍 Soft &amp; Comfortable 20-Inch Cotton Handles 📦 4-Inch Bottom &amp; Side Gusset for Extra Storage 🎨 Large Printable Area for Branding &amp; Customization ♻️ Reusable, Eco-Friendly &amp; Biodegradable Ideal Use Cases 🏢 Corporate Gift Bags – Premium branded bags for clients and employees. 🎁 Gift Hampers – Ideal for wedding favors, festive gifting, and luxury hampers. 🛍️ Retail Packaging – Sustainable packaging for boutiques and premium stores. 🎪 Trade Shows &amp; Exhibitions – Perfect for promotional giveaways and events. 🏬 Business Branding – Showcase your logo with high-quality custom printing. 🌱 Eco-Friendly Promotions – Reusable bags that enhance brand visibility while supporting sustainability.',
        93.3,
        NULL,
        'PM-0063',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'canvas-tote-bags'),
        '18x14x6 Jute Tote Bags with Canvas Front Pocket | 350 GSM',
        'custom-18x14x6-jute-tote-bags-with-canvas-front-pocket-350-gsm',
        'EcoCarry''s Custom 18 × 14 × 6 Jute Tote Bag with Canvas Front Pocket combines premium 350 GSM natural jute, a spacious design, and a large canvas front pocket for custom branding. Perfect for corporate gifting, retail packaging, exhibitions, promotional events, and eco-friendly business packaging. Material 100% Natural Jute Fabric Fabric Quality 350 GSM Size 18×14×6 Inch (45.72 × 35.56 × 15.24 cm) Handle Type 20 Inch Soft Padded Jute Handles Front Pocket Large Cotton Canvas Pocket Screen Printing 1 &amp; 2 Color Printing (No Print Size Limit) DTF Printing Multicolor Printing (Maximum Print Size: 7 × 5 Inch) Key Features 🌿 Premium 350 GSM Natural Jute Fabric 👜 Large Cotton Canvas Front Pocket for Custom Printing 💪 Reinforced Stitching for Long-Lasting Durability 🤍 Soft &amp; Comfortable 20-Inch Cotton Handles 📦 6-Inch Bottom &amp; Side Gusset for Extra Storage 🎨 Large Printable Area for Branding &amp; Customization ♻️ Reusable, Eco-Friendly &amp; Biodegradable Ideal Use Cases 🏢 Corporate Gift Bags – Premium branded bags for clients and employees. 🎁 Gift Hampers – Ideal for wedding favors, festive gifting, and luxury hampers. 🛍️ Retail Packaging – Sustainable packaging for boutiques and premium stores. 🎪 Trade Shows &amp; Exhibitions – Perfect for promotional giveaways and events. 🏬 Business Branding – Showcase your logo with high-quality custom printing. 🌱 Eco-Friendly Promotions – Reusable bags that enhance brand visibility while supporting sustainability.',
        169.7,
        NULL,
        'PM-0064',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'canvas-tote-bags'),
        '16x14x6 Jute Tote Bags with Canvas Front Pocket | 350 GSM',
        'custom-16x14x6-jute-tote-bags-with-canvas-front-pocket-350-gsm',
        'EcoCarry''s Custom 16 × 14 × 6 Jute Tote Bag with Canvas Front Pocket combines premium 350 GSM natural jute, a spacious design, and a large canvas front pocket for custom branding. Perfect for corporate gifting, retail packaging, exhibitions, promotional events, and eco-friendly business packaging. Material 100% Natural Jute Fabric Fabric Quality 350 GSM Size 16×14×6 Inch (40.64 × 35.56 × 15.24 cm) Handle Type 20 Inch Soft Padded Jute Handles Front Pocket Large Cotton Canvas Pocket Screen Printing 1 &amp; 2 Color Printing (No Print Size Limit) DTF Printing Multicolor Printing (Maximum Print Size: 7 × 5 Inch) Key Features 🌿 Premium 350 GSM Natural Jute Fabric 👜 Large Cotton Canvas Front Pocket for Custom Printing 💪 Reinforced Stitching for Long-Lasting Durability 🤍 Soft &amp; Comfortable 20-Inch Cotton Handles 📦 6-Inch Bottom &amp; Side Gusset for Extra Storage 🎨 Large Printable Area for Branding &amp; Customization ♻️ Reusable, Eco-Friendly &amp; Biodegradable Ideal Use Cases 🏢 Corporate Gift Bags – Premium branded bags for clients and employees. 🎁 Gift Hampers – Ideal for wedding favors, festive gifting, and luxury hampers. 🛍️ Retail Packaging – Sustainable packaging for boutiques and premium stores. 🎪 Trade Shows &amp; Exhibitions – Perfect for promotional giveaways and events. 🏬 Business Branding – Showcase your logo with high-quality custom printing. 🌱 Eco-Friendly Promotions – Reusable bags that enhance brand visibility while supporting sustainability.',
        159.6,
        NULL,
        'PM-0065',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'canvas-tote-bags'),
        '15x13x6 Jute Tote Bags with Canvas Front Pocket | 350 GSM',
        'custom-15x13x6-jute-tote-bags-with-canvas-front-pocket-350-gsm',
        'EcoCarry''s Custom 15 × 13 × 6 Jute Tote Bag with Canvas Front Pocket combines premium 350 GSM natural jute, a spacious design, and a large canvas front pocket for custom branding. Perfect for corporate gifting, retail packaging, exhibitions, promotional events, and eco-friendly business packaging. Material 100% Natural Jute Fabric Fabric Quality 350 GSM Size 15×13×6 Inch (38.10 × 33.02 × 15.24 cm) Handle Type 20 Inch Soft Padded Jute Handles Front Pocket Large Cotton Canvas Pocket Screen Printing 1 &amp; 2 Color Printing (No Print Size Limit) DTF Printing Multicolor Printing (Maximum Print Size: 6 × 4.5 Inch) Key Features 🌿 Premium 350 GSM Natural Jute Fabric 👜 Large Cotton Canvas Front Pocket for Custom Printing 💪 Reinforced Stitching for Long-Lasting Durability 🤍 Soft &amp; Comfortable 20-Inch Cotton Handles 📦 6-Inch Bottom &amp; Side Gusset for Extra Storage 🎨 Large Printable Area for Branding &amp; Customization ♻️ Reusable, Eco-Friendly &amp; Biodegradable Ideal Use Cases 🏢 Corporate Gift Bags – Premium branded bags for clients and employees. 🎁 Gift Hampers – Ideal for wedding favors, festive gifting, and luxury hampers. 🛍️ Retail Packaging – Sustainable packaging for boutiques and premium stores. 🎪 Trade Shows &amp; Exhibitions – Perfect for promotional giveaways and events. 🏬 Business Branding – Showcase your logo with high-quality custom printing. 🌱 Eco-Friendly Promotions – Reusable bags that enhance brand visibility while supporting sustainability.',
        144.4,
        NULL,
        'PM-0066',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'canvas-tote-bags'),
        '12×12×7.5 Jute Tote Bags with Canvas Front Pocket | 350 GSM',
        'custom-12x12x7-5-jute-tote-bags-with-canvas-front-pocket-350-gsm',
        'EcoCarry''s Custom 12 × 12 × 7.5 Jute Tote Bag with Canvas Front Pocket combines premium 350 GSM natural jute, a spacious design, and a large canvas front pocket for custom branding. Perfect for corporate gifting, retail packaging, exhibitions, promotional events, and eco-friendly business packaging. Material 100% Natural Jute Fabric Fabric Quality 350 GSM Size 12×12×7.5 Inch (30.48 × 30.48 × 19.05 cm) Handle Type 20 Inch Soft Padded Jute Handles Front Pocket Large Cotton Canvas Pocket Screen Printing 1 &amp; 2 Color Printing (No Print Size Limit) DTF Printing Multicolor Printing (Maximum Print Size: 5 × 4 Inch) Key Features 🌿 Premium 350 GSM Natural Jute Fabric 👜 Large Cotton Canvas Front Pocket for Custom Printing 💪 Reinforced Stitching for Long-Lasting Durability 🤍 Soft &amp; Comfortable 20-Inch Cotton Handles 📦 7.5-Inch Bottom &amp; Side Gusset for Extra Storage 🎨 Large Printable Area for Branding &amp; Customization ♻️ Reusable, Eco-Friendly &amp; Biodegradable Ideal Use Cases 🏢 Corporate Gift Bags – Premium branded bags for clients and employees. 🎁 Gift Hampers – Ideal for wedding favors, festive gifting, and luxury hampers. 🛍️ Retail Packaging – Sustainable packaging for boutiques and premium stores. 🎪 Trade Shows &amp; Exhibitions – Perfect for promotional giveaways and events. 🏬 Business Branding – Showcase your logo with high-quality custom printing. 🌱 Eco-Friendly Promotions – Reusable bags that enhance brand visibility while supporting sustainability.',
        126.0,
        NULL,
        'PM-0067',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'canvas-tote-bags'),
        '18×14×6 Natural Jute Tote Bag | 350 GSM',
        'custom-18x14x6-natural-jute-tote-bag-350-gsm',
        'Make your brand stand out with EcoCarry''s Custom 18 × 14 × 6 Natural Jute Tote Bag. Crafted from premium 350 GSM natural jute fabric, this extra-spacious reusable tote is perfect for custom logo printing, corporate gifting, retail packaging, exhibitions, promotional events, and bulk branding. Material 100% Natural Jute Fabric Fabric Quality 350 GSM Size 18 × 14 × 6 Inch (45.72 × 35.56 × 15.24 cm) Handle Type 20 Inch Soft Padded Jute Handles Screen Printing 1 &amp; 2 Color Printing (No Print Size Limit) DTF Printing Multicolor Printing (Maximum Print Size: 7 × 5 Inch) Key Features 🌿 Premium 350 GSM Natural Jute Fabric 💪 Reinforced Stitching for Long Life 👜 Comfortable 20-Inch Soft Jute Handles 📦 Spacious 6-Inch Gusset Design ♻️ Eco-Friendly, Reusable &amp; Biodegradable 🏢 Perfect for Business Branding &amp; Promotions Ideal Use Cases 🏢 Corporate Branding – Showcase your business logo professionally. 🎁 Corporate Gifts – Premium packaging for clients and employees. 🛍️ Retail Packaging – Sustainable branded shopping bags. 🎪 Trade Shows – Perfect for exhibitions and promotional events. 🎉 Event Giveaways – Ideal for conferences and brand campaigns. 🌿 Eco Promotions – Promote your brand sustainably.',
        149.5,
        NULL,
        'PM-0068',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'canvas-tote-bags'),
        '16×14×6 Natural Jute Tote Bag | 350 GSM',
        'custom-16x14x6-natural-jute-tote-bag-350-gsm',
        'Enhance your brand with EcoCarry''s Custom 16 × 14 × 6 Natural Jute Tote Bag. Made from premium 350 GSM natural jute fabric, this durable and reusable tote is ideal for custom logo printing, corporate gifting, retail packaging, exhibitions, and promotional events. Material 100% Natural Jute Fabric Fabric Quality 350 GSM Size 16 × 14 × 6 Inch (40.64 × 35.56 × 15.24 cm) Handle Type 20 Inch Soft Padded Jute Handles Screen Printing 1 &amp; 2 Color Printing (No Print Size Limit) DTF Printing Multicolor Printing (Maximum Print Size: 7 × 5 Inch) Key Features 🌿 Premium 350 GSM Natural Jute Fabric 💪 Reinforced Stitching for Long Life 👜 Comfortable 20-Inch Soft Jute Handles 📦 Spacious 6-Inch Gusset Design ♻️ Eco-Friendly, Reusable &amp; Biodegradable 🏢 Perfect for Business Branding &amp; Promotions Ideal Use Cases 🏢 Corporate Branding – Showcase your business logo professionally. 🎁 Corporate Gifts – Premium packaging for clients and employees. 🛍️ Retail Packaging – Sustainable branded shopping bags. 🎪 Trade Shows – Perfect for exhibitions and promotional events. 🎉 Event Giveaways – Ideal for conferences and brand campaigns. 🌿 Eco Promotions – Promote your brand sustainably.',
        142.8,
        NULL,
        'PM-0069',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'canvas-tote-bags'),
        '15×13×6 Natural Jute Tote Bag | 350 GSM',
        'custom-15x13x6-natural-jute-tote-bag-350-gsm',
        'Create premium branded packaging with EcoCarry''s Custom 15 × 13 × 6 Natural Jute Tote Bag. Made from durable 350 GSM natural jute fabric, this reusable tote is designed for custom logo printing, corporate gifting, retail packaging, exhibitions, and promotional events. Material 100% Natural Jute Fabric Fabric Quality 350 GSM Size 15 × 13 × 6 Inch (38.10 × 33.02 × 15.24 cm) Handle Type 20 Inch Soft Padded Jute Handles Screen Printing 1 &amp; 2 Color Printing (No Print Size Limit) DTF Printing Multicolor Printing (Maximum Print Size: 6 × 4.5 Inch) Key Features 🌿 Premium 350 GSM Natural Jute Fabric 💪 Reinforced Stitching for Long Life 👜 Comfortable 20-Inch Soft Jute Handles 📦 Spacious 6-Inch Gusset Design ♻️ Eco-Friendly, Reusable &amp; Biodegradable 🏢 Perfect for Business Branding &amp; Promotions Ideal Use Cases 🏢 Corporate Branding – Showcase your business logo professionally. 🎁 Corporate Gifts – Premium packaging for clients and employees. 🛍️ Retail Packaging – Sustainable branded shopping bags. 🎪 Trade Shows – Perfect for exhibitions and promotional events. 🎉 Event Giveaways – Ideal for conferences and brand campaigns. 🌿 Eco Promotions – Promote your brand sustainably.',
        129.3,
        NULL,
        'PM-0070',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'canvas-tote-bags'),
        '12×12×7.5 Natural Jute Tote Bag | 350 GSM',
        'custom-12x12x7-5-natural-jute-tote-bag-350-gsm',
        'Create premium branded packaging with EcoCarry''s Custom 12 × 12 × 7.5 Natural Jute Tote Bag. Made from durable 350 GSM natural jute fabric, this reusable tote is designed for custom logo printing, corporate gifting, retail packaging, exhibitions, and promotional events. Material 100% Natural Jute Fabric Fabric Quality 350 GSM Size 12 × 12 × 7.5 Inch (30.48 × 30.48 × 19.05 cm) Handle Type 20 Inch Soft Padded Jute Handles Screen Printing 1 &amp; 2 Color Printing (No Print Size Limit) DTF Printing Multicolor Printing (Maximum Print Size: 5 × 4 Inch) Key Features 🌿 Premium 350 GSM Natural Jute Fabric 💪 Reinforced Stitching for Long Life 👜 Comfortable 20-Inch Soft Jute Handles 📦 Spacious 7.5-Inch Gusset Design ♻️ Eco-Friendly, Reusable &amp; Biodegradable 🏢 Perfect for Business Branding &amp; Promotions Ideal Use Cases 🏢 Corporate Branding – Showcase your business logo professionally. 🎁 Corporate Gifts – Premium packaging for clients and employees. 🛍️ Retail Packaging – Sustainable branded shopping bags. 🎪 Trade Shows – Perfect for exhibitions and promotional events. 🎉 Event Giveaways – Ideal for conferences and brand campaigns. 🌿 Eco Promotions – Promote your brand sustainably.',
        117.1,
        NULL,
        'PM-0071',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'canvas-tote-bags'),
        '9×11×4 Natural Jute Tote Bag | 350 GSM',
        'custom-9x11x4-natural-jute-tote-bag-350-gsm',
        'Promote your brand sustainably with the 9 × 11 × 4 Custom Printed Natural Jute Tote Bag . Made from premium 350 GSM natural jute fabric , this durable tote features high-quality custom logo printing, making it ideal for businesses, events, retail stores, exhibitions, and eco-conscious packaging. Material 100% Natural Jute Fabric Fabric Quality 350 GSM Size 9x11x4 Inch (22.86 × 27.94 × 10.16 cm) Handle Type 20 Inch Soft Padded Jute Handles Screen Printing 1 &amp; 2 Color Printing (No Print Size Limit) DTF Printing Multicolor Printing (Maximum Print Size: 4 × 3 Inch) Key Features 🌿 Premium 350 GSM Natural Jute Fabric 🎨 High-Quality Custom Logo Printing 💪 Reinforced Stitching for Long Life 👜 Comfortable 20-Inch Soft Jute Handles 📦 Spacious 4-Inch Gusset Design ♻️ Eco-Friendly, Reusable &amp; Biodegradable 🏢 Perfect for Business Branding &amp; Promotions Ideal Use Cases 🏢 Corporate Branding – Showcase your business logo professionally. 🎁 Corporate Gifts – Premium packaging for clients and employees. 🛍️ Retail Packaging – Sustainable branded shopping bags. 🎪 Trade Shows – Perfect for exhibitions and promotional events. 🎉 Event Giveaways – Ideal for conferences and brand campaigns. 🌿 Eco Promotions – Promote your brand sustainably.',
        86.5,
        NULL,
        'PM-0072',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '18x22 Inch Cotton Tote Bag | 150 GSM',
        'custom-18x22-inch-cotton-tote-bag-150-gsm',
        'Material 100% Pure Cotton Size 18x22 Inch Fabric Details 150 GSM Quality 1 &amp; 2 Color Hand Screen Print - No size Limit Digital Print Heat Transfer DTF - Maximum size 8x5 Inch Key Features: ✅100% Natural Cotton – Eco-friendly, reusable, and biodegradable, making it the perfect alternative to plastic bags. ✅Strong &amp; Durable – Premium stitching and sturdy canvas fabric hold groceries, fruits, vegetables, books, and more with ease. ✅DIY &amp; Customizable – Ideal for screen printing, embroidery, fabric painting, tie-dye, and heat transfer vinyl – perfect for businesses, events, and personal use. ✅Multipurpose Tote – Use as a shopping bag, grocery bag, gift bag, craft project, corporate branding bag, or everyday carry-all. ✅Lightweight &amp; Convenient – Easy to fold, store, and carry anywhere – a must-have eco bag for daily shopping trips.',
        57.8,
        NULL,
        'PM-0073',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '13×15 Diamond Motif Cotton Canvas Jute Tote Bag | 330 GSM',
        'custom-13-15-diamond-motif-cotton-canvas-jute-tote-bag-330-gsm',
        'Elevate your brand with EcoCarry''s premium Diamond Motif Cotton Canvas Jute Tote Bag, crafted for stylish branding, everyday durability, and sustainable packaging. Material 100% Cotton Canvas with Diamond Motif Jute Base Fabric Quality 330 GSM Size 13 × 15 Inch Screen Print 1 &amp; 2 Color (No Size Limit) Embroidery Up to 4 Thread Colors Key Features ✨ Premium Diamond Motif woven jute base for a sophisticated look. 💪 Heavy-duty 330 GSM cotton canvas for long-lasting durability. 👜 Comfortable shoulder handles for daily use. 🎯 Fully Customizable by adding your logo, artwork, or branding 🌿 Reusable, washable, and eco-friendly alternative to plastic bags. 🧵 Reinforced stitching for carrying everyday essentials with confidence. Ideal For 🛍️ Retail Packaging – Premium branded bags for boutiques and stores. 🎁 Corporate Gifting – Perfect for events, conferences, and giveaways. 🏢 Business Branding – Customize with your company logo or artwork. 🛒 Shopping &amp; Everyday Use – Durable for daily essentials and groceries. 🌿 Promotional Campaigns – Eco-friendly bags for marketing and brand promotions.',
        103.1,
        NULL,
        'EC085',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '13×15 Diamond Jacquard Cotton Canvas Jute Tote Bag | 330 GSM',
        'custom-13x15-diamond-jacquard-cotton-canvas-jute-tote-bag-330-gsm',
        'Elevate your everyday carry with EcoCarry''s premium Diamond Jacquard Cotton Canvas Jute Tote Bag. Crafted from heavyweight 330 GSM cotton canvas with an elegant diamond jacquard jute base, this tote combines durability, sustainability, and timeless style. Perfect for businesses, gifting, shopping, travel, and premium branding. Material 100% Cotton Canvas with Diamond Jacquard Jute Base Fabric Quality 330 GSM Size 13 × 15 Inch Screen Print 1 &amp; 2 Color (No Size Limit) Embroidery Up to 4 Thread Colors Key Features ✨ Premium Diamond Jacquard woven jute base for a sophisticated look. 💪 Heavy-duty 330 GSM cotton canvas for long-lasting durability. 👜 Comfortable shoulder handles for daily use. 🎯 Fully Customizable by adding your logo, artwork, or branding 🌿 Reusable, washable, and eco-friendly alternative to plastic bags. 🧵 Reinforced stitching for carrying everyday essentials with confidence. Ideal For 🛍️ Retail Packaging – Premium branded bags for boutiques and stores. 🎁 Corporate Gifting – Perfect for events, conferences, and giveaways. 🏢 Business Branding – Customize with your company logo or artwork. 🛒 Shopping &amp; Everyday Use – Durable for daily essentials and groceries. 🌿 Promotional Campaigns – Eco-friendly bags for marketing and brand promotions.',
        103.1,
        NULL,
        'EC129',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'eco-gift-sets'),
        'Forest Eco Gift Set',
        'forest-eco-gift-set',
        'Designed for thoughtful gifting, the Forest Eco Gift Set blends earthy elegance with everyday functionality. Featuring premium reusable essentials in warm terracotta and olive green tones, it''s a sustainable gift made to leave a lasting impression. What''s Included Cotton Tote Bag, Diary &amp; Cotton Zipper Pouch Cotton Tote Bag 13 × 15 Inch Size Diary 6 × 8.5 Inch Size Cotton Zipper Pouch 7.8 × 4.8 Inch Key Features 🌿 Eco-friendly &amp; Reusable 🎨 Elegant Forest Design 💪 Durable Premium Cotton Fabric 🎁 Ready-to-Gift Premium Packaging ♻️ Sustainable Everyday Essentials Perfect For 🎁 Corporate Gifting – Employee appreciation, client gifts, and executive hampers. 💼 Employee Welcome Kits – Onboarding gifts for new team members. 🎄 Festive Gifting – Diwali, Christmas, New Year, and seasonal celebrations. 💍 Wedding &amp; Return Gifts – Elegant keepsakes for guests and special occasions. 🎉 Events, Conferences &amp; Exhibitions – Premium welcome kits and event giveaways. 🌱 Eco-Conscious Lifestyle – Perfect for those who value sustainable and reusable products.',
        799.0,
        NULL,
        'PM-0076',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'eco-gift-sets'),
        'Terra Eco Gift Set',
        'terra-eco-gift-set',
        'Thoughtfully designed for modern gifting, the Terra Eco Gift Set combines style, sustainability, and everyday practicality. Beautifully packed in a premium gift box, it''s a gift that''s made to be used and remembered. What''s Included Cotton Tote Bag, Diary &amp; Cotton Zipper Pouch Cotton Tote Bag 13 × 15 Inch Size Diary 6 × 8.5 Inch Size Cotton Zipper Pouch 7.8 × 4.8 Inch Key Features 🌿 Eco-friendly &amp; Reusable 🎨 Elegant Orange &amp; Cork Design 💪 Durable Premium Cotton Fabric 🎁 Ready-to-Gift Premium Packaging ♻️ Sustainable Everyday Essentials Perfect For 🎁 Corporate Gifts 💼 Employee Welcome Kits 🎄 Festive Gifting 💍 Wedding Gifts 🎉 Event Giveaways 🌱 Eco-Conscious Brands',
        799.0,
        NULL,
        'PM-0077',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '13"x15" Plain Black and Yellow Tote Bag | 330 GSM',
        'custom-13x15-plain-black-and-yellow-tote-bag-330-gsm',
        'Stand out with EcoCarry''s premium pink cotton canvas tote bag, designed for custom branding, everyday durability, and stylish reusable packaging. Material 100% Cotton Canvas Fabric Quality 330 GSM (Heavy Duty) Size 13x15 Inch Handle Type 24 Inch Long Strong Shoulder Handles Digital Print For Digital Print Maximum size is 6x4.5 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use - Maximum 6x6 Inch Key Features Premium Heavy Canvas Material Strong, durable, and long-lasting fabric for everyday use Comfortable Web Handles 24-inch handles designed to carry heavy weight comfortably Multi-Purpose Usage Ideal for shopping, office use, gifting, events, and branding Minimal &amp; Customizable Perfect blank canvas for printing logos, designs, or branding',
        75.0,
        NULL,
        'EC014',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '13"x15" Navy Blue Tote Bag | 330 GSM',
        'custom-13x15-navy-blue-tote-bag-330-gsm',
        'Stand out with EcoCarry''s premium pink cotton canvas tote bag, designed for custom branding, everyday durability, and stylish reusable packaging. Material 100% Cotton Canvas Fabric Quality 330 GSM (Heavy Duty) Size 13x15 Inch Handle Type 24 Inch Long Strong Shoulder Handles Digital Print For Digital Print Maximum size is 6x4.5 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use - Maximum 6x6 Inch Key Features Premium Heavy Canvas Material Strong, durable, and long-lasting fabric for everyday use Comfortable Web Handles 24-inch handles designed to carry heavy weight comfortably Multi-Purpose Usage Ideal for shopping, office use, gifting, events, and branding Minimal &amp; Customizable Perfect blank canvas for printing logos, designs, or branding',
        75.0,
        NULL,
        'EC006',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '13"x15" Brown Tote Bag | 330 GSM',
        'custom-13x15-brown-tote-bag-330-gsm',
        'Stand out with EcoCarry''s premium pink cotton canvas tote bag, designed for custom branding, everyday durability, and stylish reusable packaging. Material 100% Cotton Canvas Fabric Quality 330 GSM (Heavy Duty) Size 13x15 Inch Handle Type 24 Inch Long Strong Shoulder Handles Digital Print For Digital Print Maximum size is 6x4.5 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use - Maximum 6x6 Inch Key Features Premium Heavy Canvas Material Strong, durable, and long-lasting fabric for everyday use Comfortable Web Handles 24-inch handles designed to carry heavy weight comfortably Multi-Purpose Usage Ideal for shopping, office use, gifting, events, and branding Minimal &amp; Customizable Perfect blank canvas for printing logos, designs, or branding',
        75.0,
        NULL,
        'EC015',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '13"x15" Pink Tote Bag | 330 GSM',
        'custom-13x15-pink-tote-bag-330-gsm',
        'Stand out with EcoCarry''s premium pink cotton canvas tote bag, designed for custom branding, everyday durability, and stylish reusable packaging. Material 100% Cotton Canvas Fabric Quality 330 GSM (Heavy Duty) Size 13x15 Inch Handle Type 24 Inch Long Strong Shoulder Handles Digital Print For Digital Print Maximum size is 6x4.5 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use - Maximum 6x6 Inch Key Features Premium Heavy Canvas Material Strong, durable, and long-lasting fabric for everyday use Comfortable Web Handles 24-inch handles designed to carry heavy weight comfortably Multi-Purpose Usage Ideal for shopping, office use, gifting, events, and branding Minimal &amp; Customizable Perfect blank canvas for printing logos, designs, or branding',
        75.0,
        NULL,
        'EC012',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '13"x15" Black & Beige Tote Bag | 330 GSM',
        'custom-13x15-black-beige-tote-bag-330-gsm',
        'Make your brand stand out with EcoCarry''s premium two-tone canvas tote bag, designed for durable everyday use and high-quality custom branding. Material 100% Cotton Canvas Fabric Quality 330 GSM | Black &amp; Beige Size 13x15 Inch Handle Type 24 Inch Long Strong Shoulder Handles Digital Print For Digital Print Maximum size is 6x4.5 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use - Maximum 6x6 Inch Key Features 🎨 Supports screen printing, DTF printing, and embroidery. 💪 Premium 330 GSM cotton canvas for long-lasting use. 👜 Strong 24-inch shoulder handles for comfortable carrying. 🌈 Elegant sky blue &amp; beige two-tone design. ♻️ Reusable, washable, and eco-friendly. Ideal Use Cases 🛍️ Retail Packaging – Premium branded bags for boutiques and stores. 🎁 Corporate Gifting – Perfect for events, conferences, and giveaways. 🏢 Business Branding – Customize with your company logo or artwork. 🛒 Shopping &amp; Everyday Use – Durable for daily essentials and groceries. 🌿 Promotional Campaigns – Eco-friendly bags for marketing and brand promotions.',
        93.7,
        NULL,
        'EC011',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '13"x15" Light Pink & Beige Tote Bag | 330 GSM',
        'custom-13x15-light-pink-beige-tote-bag-330-gsm',
        'Make your brand stand out with EcoCarry''s premium two-tone canvas tote bag, designed for durable everyday use and high-quality custom branding. Material 100% Cotton Canvas Fabric Quality 330 GSM | Light Pink &amp; Beige Size 13x15 Inch Handle Type 24 Inch Long Strong Shoulder Handles Digital Print For Digital Print Maximum size is 6x4.5 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use - Maximum 6x6 Inch Key Features 🎨 Supports screen printing, DTF printing, and embroidery. 💪 Premium 330 GSM cotton canvas for long-lasting use. 👜 Strong 24-inch shoulder handles for comfortable carrying. 🌈 Elegant sky blue &amp; beige two-tone design. ♻️ Reusable, washable, and eco-friendly. Ideal Use Cases 🛍️ Retail Packaging – Premium branded bags for boutiques and stores. 🎁 Corporate Gifting – Perfect for events, conferences, and giveaways. 🏢 Business Branding – Customize with your company logo or artwork. 🛒 Shopping &amp; Everyday Use – Durable for daily essentials and groceries. 🌿 Promotional Campaigns – Eco-friendly bags for marketing and brand promotions.',
        93.7,
        NULL,
        'EC008',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '13"x15" Navy Blue & Beige Tote Bag | 330 GSM',
        'custom-13x15-navy-blue-beige-tote-bag-330-gsm',
        'Make your brand stand out with EcoCarry''s premium two-tone canvas tote bag, designed for durable everyday use and high-quality custom branding. Material 100% Cotton Canvas Fabric Quality 330 GSM | Navy Blue &amp; Beige Size 13x15 Inch Handle Type 24 Inch Long Strong Shoulder Handles Digital Print For Digital Print Maximum size is 6x4.5 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use - Maximum 6x6 Inch Key Features 🎨 Supports screen printing, DTF printing, and embroidery. 💪 Premium 330 GSM cotton canvas for long-lasting use. 👜 Strong 24-inch shoulder handles for comfortable carrying. 🌈 Elegant sky blue &amp; beige two-tone design. ♻️ Reusable, washable, and eco-friendly. Ideal Use Cases 🛍️ Retail Packaging – Premium branded bags for boutiques and stores. 🎁 Corporate Gifting – Perfect for events, conferences, and giveaways. 🏢 Business Branding – Customize with your company logo or artwork. 🛒 Shopping &amp; Everyday Use – Durable for daily essentials and groceries. 🌿 Promotional Campaigns – Eco-friendly bags for marketing and brand promotions.',
        93.7,
        NULL,
        'EC010',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '13"x15" Brown & Beige Tote Bag | 330 GSM',
        'custom-13x15-brown-beige-tote-bag-330-gsm',
        'Make your brand stand out with EcoCarry''s premium two-tone canvas tote bag, designed for durable everyday use and high-quality custom branding. Material 100% Cotton Canvas Fabric Quality 330 GSM | Brown &amp; Beige Size 13x15 Inch Handle Type 24 Inch Long Strong Shoulder Handles Digital Print For Digital Print Maximum size is 6x4.5 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use - Maximum 6x6 Inch Key Features 🎨 Supports screen printing, DTF printing, and embroidery. 💪 Premium 330 GSM cotton canvas for long-lasting use. 👜 Strong 24-inch shoulder handles for comfortable carrying. 🌈 Elegant sky blue &amp; beige two-tone design. ♻️ Reusable, washable, and eco-friendly. Ideal Use Cases 🛍️ Retail Packaging – Premium branded bags for boutiques and stores. 🎁 Corporate Gifting – Perfect for events, conferences, and giveaways. 🏢 Business Branding – Customize with your company logo or artwork. 🛒 Shopping &amp; Everyday Use – Durable for daily essentials and groceries. 🌿 Promotional Campaigns – Eco-friendly bags for marketing and brand promotions.',
        93.7,
        NULL,
        'EC060',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '13"x15" Sky Blue & Beige Tote Bag | 330 GSM',
        'custom-13x15-sky-blue-beige-tote-bag-330-gsm',
        'Make your brand stand out with EcoCarry''s premium two-tone canvas tote bag, designed for durable everyday use and high-quality custom branding. Material 100% Cotton Canvas Fabric Quality 330 GSM | Sky Blue &amp; Beige Size 13x15 Inch Handle Type 24 Inch Long Strong Shoulder Handles Digital Print For Digital Print Maximum size is 6x4.5 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use - Maximum 6x6 Inch Key Features 🎨 Supports screen printing, DTF printing, and embroidery. 💪 Premium 330 GSM cotton canvas for long-lasting use. 👜 Strong 24-inch shoulder handles for comfortable carrying. 🌈 Elegant sky blue &amp; beige two-tone design. ♻️ Reusable, washable, and eco-friendly. Ideal Use Cases 🛍️ Retail Packaging – Premium branded bags for boutiques and stores. 🎁 Corporate Gifting – Perfect for events, conferences, and giveaways. 🏢 Business Branding – Customize with your company logo or artwork. 🛒 Shopping &amp; Everyday Use – Durable for daily essentials and groceries. 🌿 Promotional Campaigns – Eco-friendly bags for marketing and brand promotions.',
        93.7,
        NULL,
        'EC059',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'paper-bags'),
        'Kraft Paper Mailer Bag Sample Kit – 7 Sizes',
        'kraft-paper-mailer-bag-sample-kit-7-sizes',
        'Compare EcoCarry''s kraft paper mailer bags in different sizes before bulk ordering. Find the perfect fit for your products with confidence. Material Premium Kraft Paper Paper Quality 110 GSM &amp; 120 GSM Kraft Paper Quantity 7 Paper Mailer Bags (1 Piece of Each Size) Closure Strong Self-Adhesive Peel &amp; Seal Strip What''s Included 6 × 7 Inch Kraft Paper Mailer Bag | 110 GSM 7 × 8 Inch Kraft Paper Mailer Bag | 110 GSM 9 × 10 Inch Kraft Paper Mailer Bag | 110 GSM 11 × 13 Inch Kraft Paper Mailer Bag | 110 GSM 13 × 15 Inch Kraft Paper Mailer Bag | 120 GSM 15 × 17 Inch Kraft Paper Mailer Bag | 120 GSM 16 × 19 Inch Kraft Paper Mailer Bag | 120 GSM Key Features 🛍️ Includes 7 popular paper bag sizes. 💪 Made from durable 110 GSM &amp; 120 GSM kraft paper. 🔒 Strong self-adhesive peel &amp; seal closure. 📏 Compare sizes before placing bulk orders. ♻️ Recyclable and eco-friendly packaging. Ideal For 📦 Bulk Order Planning – Compare all sizes before placing bulk orders. 🛍️ E-commerce Businesses – Find the right mailer for your products. 👕 Apparel Brands – Test sizes for clothing and accessories. 🏷️ Retail Packaging – Choose the ideal mailer for your business. 🌿 Quality Evaluation – Check paper quality and finishing before ordering.',
        199.0,
        NULL,
        'SK104',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'drawstring-bags'),
        'Floral Brown Embroidered Drawstring Bag',
        'floral-brown-embroidered-tote-bag',
        'Material 100% Pure Cotton Size 8x9 inch Fabric Details 150 GSM Quality Design Embroidered Floral Design Key Features: ✅ Premium Material – Made from 100% natural, unbleached cotton fabric. Safe, breathable, and eco-friendly. ✅ Perfect Size – 8x9 inch pouch suitable for jewelry, cosmetics, Candle, Handmade Soaps and small product packaging. ✅ Multi-Purpose Use – Ideal for spices, herbs, snacks, return gifts, wedding favors, corporate gifting, or sustainable product packaging. ✅ Reusable &amp; Washable – Strong stitching and drawstring closure make it long-lasting, easy to clean, and reusable. ✅ Eco-Friendly &amp; Compostable – Biodegradable cotton helps you reduce plastic usage and support a greener planet.',
        46.0,
        NULL,
        'EC062',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'drawstring-bags'),
        'Floral Yellow Embroidered Drawstring Bag',
        'floral-yellow-embroidered-tote-bag',
        'Material 100% Pure Cotton Size 8x9 inch Fabric Details 150 GSM Quality Design Embroidered Floral Design Key Features: ✅ Premium Material – Made from 100% natural, unbleached cotton fabric. Safe, breathable, and eco-friendly. ✅ Perfect Size – 8x9 inch pouch suitable for jewelry, cosmetics, Candle, Handmade Soaps and small product packaging. ✅ Multi-Purpose Use – Ideal for spices, herbs, snacks, return gifts, wedding favors, corporate gifting, or sustainable product packaging. ✅ Reusable &amp; Washable – Strong stitching and drawstring closure make it long-lasting, easy to clean, and reusable. ✅ Eco-Friendly &amp; Compostable – Biodegradable cotton helps you reduce plastic usage and support a greener planet.',
        46.0,
        NULL,
        'EC063',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'drawstring-bags'),
        'Floral Pink Embroidered Drawstring Bag',
        'floral-pink-embroidered-tote-bag',
        'Material 100% Pure Cotton Size 8x9 inch Fabric Details 150 GSM Quality Design Embroidered Floral Design Key Features: ✅ Premium Material – Made from 100% natural, unbleached cotton fabric. Safe, breathable, and eco-friendly. ✅ Perfect Size – 8x9 inch pouch suitable for jewelry, cosmetics, Candle, Handmade Soaps and small product packaging. ✅ Multi-Purpose Use – Ideal for spices, herbs, snacks, return gifts, wedding favors, corporate gifting, or sustainable product packaging. ✅ Reusable &amp; Washable – Strong stitching and drawstring closure make it long-lasting, easy to clean, and reusable. ✅ Eco-Friendly &amp; Compostable – Biodegradable cotton helps you reduce plastic usage and support a greener planet.',
        46.0,
        NULL,
        'EC064',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'drawstring-bags'),
        'Rainbow Embroidered Cotton Drawstring Pouch Bag',
        'rainbow-embroidered-cotton-drawstring-pouch-4-5x6-5-inch',
        'Add a splash of color to your everyday essentials with this rainbow embroidered cotton drawstring pouch. Made from 100% pure cotton, it''s a charming, reusable pouch for gifting, organizing, and carrying small treasures. Material 100% Pure Cotton Size 4.5 × 6.5 Inch (11.43 × 16.51 cm) Design Premium Rainbow Embroidery Fabric Details 150 GSM Cotton Fabric Key Features: 🌈 Colorful rainbow embroidery with a handcrafted finish. 🌿 Made from 100% pure, eco-friendly cotton. 🎀 Easy drawstring closure for secure storage. 🎁 Compact size for gifting and everyday essentials. ♻️ Reusable and sustainable for daily use. Ideal Use Cases: 💍 Jewellery Storage – Perfect for rings, earrings, bracelets, and small accessories. 🎁 Gift Packaging – Ideal for return gifts, birthdays, baby showers, and festive gifting. 🛍️ Boutique Packaging – Premium packaging for handmade products and small businesses. ✈️ Travel Organizer – Store cosmetics, coins, earphones, and other essentials neatly. 🧸 Kids'' Keepsakes – Great for storing tiny toys, hair accessories, and treasured keepsakes. 💄 Daily Storage – Organize makeup, keys, cards, and other small personal items.',
        23.5,
        NULL,
        'EC132',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'drawstring-bags'),
        'Sunflower Embroidered Cotton Drawstring Pouch Bag',
        'sunflower-embroidered-cotton-drawstring-pouch-4-5x6-5-inch',
        'Bring a touch of nature to your everyday essentials with this sunflower embroidered cotton drawstring pouch. Crafted from 100% pure cotton, it''s a beautiful and reusable pouch for gifting, organizing, and daily storage. Material 100% Pure Cotton Size 4.5 × 6.5 Inch (11.43 × 16.51 cm) Design Premium Embroidered Sunflower Fabric Details 150 GSM Cotton Fabric Key Features: 🌻 Beautiful sunflower embroidery with a handcrafted finish. 🌿 Made from 100% pure, eco-friendly cotton. 🎀 Easy drawstring closure for secure storage. 🎁 Compact size for gifting and everyday essentials. ♻️ Reusable and sustainable for daily use. Ideal Use Cases: 💍 Jewellery Storage – Perfect for rings, earrings, bracelets, and small accessories. 🎁 Gift Packaging – Ideal for return gifts, wedding favors, and festive gifting. 🛍️ Boutique Packaging – Elegant packaging for handmade products and premium brands. ✈️ Travel Organizer – Store coins, cosmetics, earphones, and other essentials. 🪔 Spiritual Essentials – Suitable for crystals, prayer beads, and sacred items. 💄 Daily Storage – Organize makeup, keys, cards, and small accessories.',
        23.5,
        NULL,
        'EC066',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'drawstring-bags'),
        'Pink Floral Embroidered Cotton Drawstring Pouch Bag',
        'pink-floral-embroidered-cotton-drawstring-pouch-4-5x6-5-inch',
        'Delicately embroidered with blooming pink flowers, this cotton drawstring pouch blends handcrafted beauty with everyday functionality. Made from 100% pure cotton, it''s perfect for gifting, organizing, and carrying small essentials in style. Material 100% Pure Cotton Size 4.5 × 6.5 Inch (11.43 × 16.51 cm) Design Premium Pink Floral Embroidery Fabric Details 150 GSM Cotton Fabric Key Features: 🌸 Elegant pink floral embroidery with a handcrafted finish. 🌿 Made from 100% pure, eco-friendly cotton. 🎀 Easy drawstring closure for secure storage. 🎁 Compact size for gifting and everyday essentials. ♻️ Reusable and sustainable for daily use. Ideal Use Cases: 💍 Jewellery Storage – Perfect for rings, earrings, bracelets, and small accessories. 🎁 Gift Packaging – Ideal for return gifts, wedding favors, and festive gifting. 🛍️ Boutique Packaging – Premium packaging for handmade products and small businesses. ✈️ Travel Organizer – Store cosmetics, coins, keys, and daily essentials neatly. 🪔 Spiritual Essentials – Suitable for crystals, prayer beads, and sacred keepsakes. 💄 Daily Storage – Organize makeup, accessories, and other small personal items.',
        23.5,
        NULL,
        'EC067',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'drawstring-bags'),
        'Floral Embroidered Cotton Drawstring Pouch',
        'floral-embroidered-cotton-drawstring-pouch-4-5x6-5-inch',
        'Inspired by blooming wildflowers, this handcrafted embroidered cotton drawstring pouch brings together timeless elegance and everyday practicality. A beautiful reusable pouch for gifting, organizing, and storing small essentials. Material 100% Pure Cotton Size 4.5 × 6.5 Inch (11.43 × 16.51 cm) Design Premium Embroidered Floral Stitch Fabric Details 150 GSM Quality Key Features: 🌸 Beautiful floral embroidery for a handcrafted premium look. 🌿 Made from 100% pure, eco-friendly cotton. 🎀 Easy drawstring closure for secure storage. 🎁 Compact 4.5×6.5 inch size for everyday essentials. ♻️ Reusable and sustainable for daily use. Ideal Use Cases: 💍 Jewellery Storage – Perfect for rings, earrings, bracelets, pendants, and small accessories. 🎁 Gift Packaging – Beautiful presentation for return gifts, wedding favors, and festive gifting. 🛍️ Boutique Packaging – Premium packaging for handmade products and small businesses. ✈️ Travel Organizer – Keep coins, earphones, cosmetics, and daily essentials neatly organized. 🪔 Spiritual Essentials – Ideal for crystals, rudraksha, prayer beads, and sacred items. 💄 Everyday Storage – Store makeup accessories, keys, cards, and other small personal items.',
        23.5,
        NULL,
        'EC065',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'drawstring-bags'),
        'Butterfly Embroidered Cotton Drawstring Pouch Bag',
        'butterfly-embroidered-cotton-drawstring-pouch-4-5x6-5-inch',
        'Inspired by the beauty of butterflies, this embroidered cotton drawstring pouch combines elegant craftsmanship with everyday functionality. Made from 100% pure cotton, it''s perfect for gifting, organizing, and storing your essentials in a sustainable way. Material 100% Pure Cotton Size 4.5 × 6.5 Inch (11.43 × 16.51 cm) Design Premium Embroidered Butterfly Fabric Details 150 GSM Cotton Fabric Key Features: 🦋 Elegant butterfly embroidery with a handcrafted finish. 🌿 Made from 100% pure, eco-friendly cotton. 🎀 Easy drawstring closure for secure storage. 🎁 Compact size for gifting and everyday essentials. ♻️ Reusable and sustainable for daily use. Ideal Use Cases: 💍 Jewellery Storage – Perfect for rings, earrings, bracelets, and small accessories. 🎁 Gift Packaging – Ideal for return gifts, wedding favors, and festive gifting. 🛍️ Boutique Packaging – Premium packaging for handmade products and small businesses. ✈️ Travel Organizer – Store cosmetics, coins, keys, and daily essentials neatly. 🪔 Spiritual Essentials – Suitable for crystals, prayer beads, and sacred keepsakes. 💄 Daily Storage – Organize makeup, accessories, and other small personal items.',
        23.5,
        NULL,
        'EC069',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'paper-bags'),
        '6x7 Kraft Paper Mailer Bag | 110 GSM',
        'custom-6x7-kraft-paper-mailer-bag-110-gsm',
        'Designed to strengthen your brand identity, this custom kraft paper mailer bag combines secure shipping with professional logo printing, helping businesses deliver memorable and sustainable packaging experiences. Material Premium Kraft Paper Size 6 × 7 Inch (15.24 × 17.78 cm) Paper Detail 110 GSM High-Quality Kraft Paper Closure Strong Self-Adhesive Peel &amp; Seal Strip Screen Printing 1 &amp; 2 Color Screen Printing Available ( No Size Limit ) Key Features 📦 Large 6 x 7 inch size – ideal for bulky products and apparel. 🎨 Custom logo printing with 1 &amp; 2 color screen printing. 🔒 Strong adhesive strip for secure and tamper-resistant sealing. 💧 Waterproof surface helps protect packages from moisture. ♻️ Recyclable and eco-friendly packaging for sustainable branding. Ideal Use Cases 💍 Jewellery Brand Packaging – Perfect for earrings, bracelets, pendants, and small accessories with your custom logo. 💄 Beauty Product Packaging – Ideal for lipsticks, skincare products, and cosmetic essentials. 📱 Mobile Accessories – Suitable for chargers, cables, earphones, and small electronic accessories. 🛍️ Retail &amp; Boutique Shipping – Premium branded packaging for boutiques, handmade products, and lifestyle brands. 📦 E-commerce Orders – Professional custom mailers for online store deliveries. 🎁 Corporate &amp; Promotional Packaging – Customize with your logo for giveaways, events, and branded merchandise.',
        5.1,
        NULL,
        'EC283',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'paper-bags'),
        '7x8 Kraft Paper Mailer Bag | 110 GSM',
        'custom-7x8-kraft-paper-mailer-bag-110-gsm',
        'Designed to strengthen your brand identity, this custom kraft paper mailer bag combines secure shipping with professional logo printing, helping businesses deliver memorable and sustainable packaging experiences. Material Premium Kraft Paper Size 7 × 8 Inch (17.78 × 20.32 cm) Paper Detail 110 GSM High-Quality Kraft Paper Closure Strong Self-Adhesive Peel &amp; Seal Strip Screen Printing 1 &amp; 2 Color Screen Printing Available ( No Size Limit ) Key Features 📦 Large 7 x 8 inch size – ideal for bulky products and apparel. 🎨 Custom logo printing with 1 &amp; 2 color screen printing. 🔒 Strong adhesive strip for secure and tamper-resistant sealing. 💧 Waterproof surface helps protect packages from moisture. ♻️ Recyclable and eco-friendly packaging for sustainable branding. Ideal Use Cases 💄 Beauty Product Packaging – Ideal for cosmetics, skincare items, and personal care products. 📱 Mobile Accessories – Suitable for phone cases, chargers, cables, and small electronic accessories. 🛍️ Retail &amp; Boutique Shipping – Premium branded packaging for boutiques, handmade products, and lifestyle brands. 📦 E-commerce Orders – Professional custom mailers for online store deliveries. 👕 Apparel Brand Packaging – Perfect for babywear, socks, scarves, and lightweight garments with your custom logo. 🎁 Corporate &amp; Promotional Packaging – Customize with your logo for giveaways, events, and branded merchandise.',
        5.5,
        NULL,
        'EC284',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'paper-bags'),
        '9x10 Kraft Paper Mailer Bag | 110 GSM',
        'custom-9x10-kraft-paper-mailer-bag-110-gsm',
        'Designed to strengthen your brand identity, this custom kraft paper mailer bag combines secure shipping with professional logo printing, helping businesses deliver memorable and sustainable packaging experiences. Material Premium Kraft Paper Size 9 × 10 Inch (22.86 × 25.40 cm) Paper Detail 110 GSM High-Quality Kraft Paper Closure Strong Self-Adhesive Peel &amp; Seal Strip Screen Printing 1 &amp; 2 Color Screen Printing Available ( No Size Limit ) Key Features 📦 Large 9 x 10 inch size – ideal for bulky products and apparel. 🎨 Custom logo printing with 1 &amp; 2 color screen printing. 🔒 Strong adhesive strip for secure and tamper-resistant sealing. 💧 Waterproof surface helps protect packages from moisture. ♻️ Recyclable and eco-friendly packaging for sustainable branding. Ideal Use Cases 📚 Books &amp; Document Shipping – Ideal for notebooks, brochures, catalogs, and important documents. 🛍️ Retail &amp; Boutique Shipping – Premium branded packaging for fashion, accessories, and lifestyle products. 📦 E-commerce Orders – Professional custom mailers for online store deliveries. 🎁 Corporate &amp; Promotional Packaging – Ideal for branded merchandise, gifts, and marketing campaigns. 👕 Apparel Brand Packaging – Perfect for T-shirts, babywear, and lightweight garments with your custom logo. 🌿 Eco-Friendly Brand Packaging – Showcase your commitment to sustainable packaging with custom-printed kraft mailers.',
        6.0,
        NULL,
        'EC285',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'paper-bags'),
        '11x13 Kraft Paper Mailer Bag | 110 GSM',
        'custom-11x13-kraft-paper-mailer-bag-110-gsm',
        'Designed to strengthen your brand identity, this custom kraft paper mailer bag combines secure shipping with professional logo printing, helping businesses deliver memorable and sustainable packaging experiences. Material Premium Kraft Paper Size 11 × 13 Inch (27.94 × 33.02 cm) Paper Detail 110 GSM High-Quality Kraft Paper Closure Strong Self-Adhesive Peel &amp; Seal Strip Screen Printing 1 &amp; 2 Color Screen Printing Available ( No Size Limit ) Key Features 📦 Large 11 x 13 inch size – ideal for bulky products and apparel. 🎨 Custom logo printing with 1 &amp; 2 color screen printing. 🔒 Strong adhesive strip for secure and tamper-resistant sealing. 💧 Waterproof surface helps protect packages from moisture. ♻️ Recyclable and eco-friendly packaging for sustainable branding. Ideal Use Cases 🛍️ Retail &amp; Boutique Shipping – Premium branded packaging for fashion, lifestyle, and retail businesses. 📦 E-commerce Orders – Professional custom mailers for online store deliveries. 🎁 Corporate &amp; Promotional Packaging – Ideal for branded merchandise, gifts, and marketing campaigns. 🏢 Business Dispatch – Suitable for warehouses, distributors, and courier operations with company branding. 👕 Apparel Brand Packaging – Perfect for T-shirts, shirts, tops, and lightweight garments with your custom logo. 🌿 Eco-Friendly Brand Packaging – Showcase your commitment to sustainable packaging with custom-printed kraft mailers.',
        8.5,
        NULL,
        'EC286',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'paper-bags'),
        '13x15 Kraft Paper Mailer Bag | 120 GSM',
        'custom-13x15-kraft-paper-mailer-bag-120-gsm',
        'Designed to strengthen your brand identity, this custom kraft paper mailer bag combines secure shipping with professional logo printing, helping businesses deliver memorable and sustainable packaging experiences. Material Premium Kraft Paper Size 13 × 15 Inch (33.02 × 38.10 cm) Paper Detail 120 GSMHigh-Quality Kraft Paper Closure Strong Self-Adhesive Peel &amp; Seal Strip Screen Printing 1 &amp; 2 Color Screen Printing Available ( No Size Limit ) Key Features 📦 Large 13 x 15 inch size – ideal for bulky products and apparel. 🎨 Custom logo printing with 1 &amp; 2 color screen printing. 🔒 Strong adhesive strip for secure and tamper-resistant sealing. 💧 Waterproof surface helps protect packages from moisture. ♻️ Recyclable and eco-friendly packaging for sustainable branding. Ideal Use Cases 🛍️ Retail &amp; Boutique Shipping – Premium branded packaging for fashion, lifestyle, and retail businesses. 📦 E-commerce Orders – Professional custom mailers for online store deliveries. 🎁 Corporate &amp; Promotional Packaging – Ideal for branded merchandise, gifts, and marketing campaigns. 🏢 Business Dispatch – Suitable for warehouses, distributors, and courier operations with company branding. 👕 Apparel Brand Packaging – Perfect for T-shirts, shirts, tops, and lightweight garments with your custom logo. 🌿 Eco-Friendly Brand Packaging – Showcase your commitment to sustainable packaging with custom-printed kraft mailers.',
        10.4,
        NULL,
        'EC287',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'paper-bags'),
        '15x17 Kraft Paper Mailer Bag | 120 GSM',
        'custom-15x17-kraft-paper-mailer-bag-120-gsm',
        'Designed to strengthen your brand identity, this custom kraft paper mailer bag combines secure shipping with professional logo printing, helping businesses deliver memorable and sustainable packaging experiences. Material Premium Kraft Paper Size 15 × 17 Inch (38.10 × 43.18 cm) Paper Detail 120 GSMHigh-Quality Kraft Paper Closure Strong Self-Adhesive Peel &amp; Seal Strip Screen Printing 1 &amp; 2 Color Screen Printing Available ( No Size Limit ) Key Features 📦 Large 15×17 inch size – ideal for bulky products and apparel. 🎨 Custom logo printing with 1 &amp; 2 color screen printing. 🔒 Strong adhesive strip for secure and tamper-resistant sealing. 💧 Waterproof surface helps protect packages from moisture. ♻️ Recyclable and eco-friendly packaging for sustainable branding. Ideal Use Cases 🛍️ Retail &amp; Boutique Shipping – Premium branded packaging for fashion, lifestyle, and retail businesses. 📦 E-commerce Orders – Professional custom mailers for online store deliveries. 🎁 Corporate &amp; Promotional Packaging – Ideal for branded merchandise, gifts, and marketing campaigns. 🏢 Business Dispatch – Suitable for warehouses, distributors, and bulk shipping with company branding. 👕 Apparel Brand Packaging – Perfect for shirts, T-shirts, kurtas, and garments with your custom logo. 🌿 Eco-Friendly Brand Packaging – Showcase your commitment to sustainable packaging with custom-printed kraft mailers.',
        12.7,
        NULL,
        'EC288',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'paper-bags'),
        '16x19 Kraft Paper Mailer Bag | 120 GSM',
        'custom-16x19-kraft-paper-mailer-bag-120-gsm',
        'Designed to strengthen your brand identity, this custom kraft paper mailer bag combines secure shipping with professional logo printing, helping businesses deliver memorable and sustainable packaging experiences. Material Premium Kraft Paper Size 16 × 19 Inch (40.64 × 48.26 cm) Paper Detail 120 GSMHigh-Quality Kraft Paper Closure Strong Self-Adhesive Peel &amp; Seal Strip Screen Printing 1 &amp; 2 Color Screen Printing Available ( No Size Limit ) Key Features 📦 Large 16×19 inch size – ideal for bulky products and apparel. 🎨 Custom logo printing with 1 &amp; 2 color screen printing. 🔒 Strong adhesive strip for secure and tamper-resistant sealing. 💧 Waterproof surface helps protect packages from moisture. ♻️ Recyclable and eco-friendly packaging for sustainable branding. Ideal Use Cases 📦 E-commerce Orders – Professional custom mailers for online store deliveries. 👕 Apparel Brand Packaging – Perfect for shipping hoodies, jackets, sarees, and garments with your custom logo. 🛍️ Retail &amp; Boutique Shipping – Premium branded packaging for fashion, lifestyle, and retail businesses. 🎁 Corporate &amp; Promotional Packaging – Ideal for branded merchandise, gifts, and marketing campaigns. 🏢 Business Dispatch – Suitable for warehouses, distributors, and bulk shipping with company branding. 🌿 Eco-Friendly Brand Packaging – Showcase your commitment to sustainable packaging with custom-printed kraft mailers.',
        14.5,
        NULL,
        'EC289',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'pouch-bags'),
        'Cotton Zipper Pouch Sample Kit - 9 Designs',
        'cotton-zipper-pouch-sample-kit-9-designs',
        'Explore EcoCarry''s cotton zipper pouch sample kit to compare sizes, colors, and craftsmanship before selecting the perfect pouch for your brand. Material 100% Pure Cotton Styles Mini, Everyday &amp; Travel Closure Premium Zipper Closure Quantity 9 Pouches (1 Piece of Each Design) What''s Included Beige) Plain Everyday Cotton Zipper Pouch (Brown) Plain Everyday Cotton Zipper Pouch (Light Pink) Plain Everyday Cotton Zipper Pouch (Sage Green) Plain Travel Cotton Zipper Pouch (Green) Plain Travel Cotton Zipper Pouch (Lavender) Plain Travel Cotton Zipper Pouch (Black) Plain Mini Cotton Zipper Pouch (Navy Blue) Plain Mini Cotton Zipper Pouch (Light Sky Blue) Plain Mini Cotton Zipper Pouch Key Features 🎨 Includes 9 pouch designs in assorted colors. 🌿 Made from durable, eco-friendly cotton. ✨ Premium zipper closure for secure storage. 📏 Compare styles before placing bulk orders. ♻️ Reusable and sustainable sample kit. Ideal For 🛍️ Bulk Order Planning – Compare styles before placing bulk orders. 🏷️ Brand Selection – Choose the right pouch for your products. 🎁 Gift Packaging – Find the perfect pouch for gifting. ✈️ Travel &amp; Everyday Use – Compare mini, everyday, and travel sizes. 🌿 Quality Evaluation – Check fabric, zipper, and overall finish.',
        499.0,
        NULL,
        'SK105',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'paper-bags'),
        'Kraft Paper Shopping Bag Sample Kit - 4 Sizes | 110 GSM',
        'kraft-paper-bag-sample-kit-4-sizes-110-gsm',
        'Explore EcoCarry''s kraft paper shopping bag sample kit to compare sizes, quality, and carrying capacity before placing your bulk order with confidence. Material Kraft Paper Paper Quality 110 GSM Kraft Paper Quantity 4 Paper Bags (1 Piece of Each Size) What''s Included 7.5 × 5 × 11 Inch Kraft Paper Bag 8.5 × 5 × 13 Inch Kraft Paper Bag 10 × 5 × 14 Inch Kraft Paper Bag 12 × 5 × 16 Inch Kraft Paper Bag Key Features 🛍️ Includes 4 popular paper bag sizes. 💪 Made from durable 110 GSM kraft paper. 📏 Compare sizes before placing bulk orders. 🌿 Strong, reusable, and eco-friendly design. ♻️ Ideal for retail, gifting, and packaging. Ideal For 🛍️ Bulk Order Planning – Compare sizes before placing bulk orders. 🏷️ Retail Packaging – Find the right bag for your products. 🎁 Gift Packaging – Choose the perfect size for gifting. 🍽️ Food &amp; Bakery – Test bags for takeaway and bakery items. 🌿 Quality Evaluation – Check paper quality and finishing.',
        199.0,
        NULL,
        'SK106',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        'Canvas Tote Bag Sample Kit - 7 Colors | 330 GSM',
        '2-color-cotton-canvas-tote-bag-sample-kit-7-colors-330-gsm',
        'Explore EcoCarry''s premium two-tone canvas tote bags before bulk ordering. Compare colors, fabric quality, and craftsmanship to find the perfect match for your brand. Material 100% Pure Cotton Fabric Details 33 0 GSM Quality Size 13 × 15 Inch (Standard Size) Quantity 7 Tote Bags (1 Piece of Each Color) What''s Included Yellow &amp; Beige Tote Bag | 330 GSM Red &amp; Beige Tote Bag | 330 GSM Navy Blue &amp; Beige Tote Bag | 330 GSM Light Pink &amp; Beige Tote Bag | 330 GSM Black &amp; Beige Tote Bag | 330 GSM Brown &amp; Beige Tote Bag | 330 GSM Sky Blue &amp; Beige Tote Bag | 330 GSM Key Features 🎨 Includes 7 stylish two-tone color combinations. 💪 Made from premium 330 GSM cotton canvas. 👜 Standard 13×15 inch size with sturdy handles. 🌈 Compare colors before placing bulk orders. ♻️ Reusable and eco-friendly sample kit. Ideal For 🛍️ Bulk Order Planning – Compare colors before placing bulk orders. 🏷️ Brand Selection – Find the best color for your business. 🎁 Corporate Gifting – Choose bags for events and promotions. 👕 Retail &amp; Fashion Brands – Match colors with your brand identity. 🌿 Quality Evaluation – Check fabric, stitching, and overall finish.',
        1299.0,
        NULL,
        'SK107',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        'Cotton Canvas Gusset Tote Bag Sample Kit - 7 Sizes | 330 GSM',
        'cotton-canvas-gusset-tote-bag-sample-kit-7-sizes-330-gsm',
        'Discover EcoCarry''s premium canvas gusset tote bags before bulk ordering. Compare sizes, capacity, and craftsmanship to choose the perfect bag for your brand. Material 100% Pure Cotton Fabric Details 33 0 GSM Quality Quantity 7 Tote Bags (1 Piece of Each Size) What''s Included 10 × 8 × 5 Inch Cotton Canvas Bag 10 × 12 × 5 Inch Cotton Canvas Bag 12 × 10 × 3 Inch Cotton Canvas Bag 12 × 12 × 7 Inch Cotton Canvas Bag 14 × 15 × 4 Inch Cotton Canvas Bag 15 × 12 × 4 Inch Cotton Canvas Bag 15 × 15 × 6 Inch Cotton Canvas Bag Key Features 👜 Includes 7 popular gusset tote bag sizes. 💪 Made from premium 330 GSM cotton canvas. 📦 Gusset design offers extra storage capacity. 📏 Compare sizes before placing bulk orders. ♻️ Reusable and eco-friendly sample kit. Ideal For 🛍️ Bulk Order Planning – Compare sizes before placing bulk orders. 🏷️ Brand Selection – Choose the right tote bag for your products. 🎁 Corporate Gifting – Find the ideal bag for events and hampers. 🛒 Retail Packaging – Test bags for shopping and merchandise. 🌿 Quality Evaluation – Check fabric, stitching, and overall finish.',
        699.0,
        NULL,
        'SK108',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        'Cotton Tote Bag Sample Kit - 6 Pcs | 220 GSM',
        'cotton-tote-bag-sample-kit-6-sizes-220-gsm',
        'Compare EcoCarry''s premium 220 GSM cotton tote bags before bulk ordering. Explore different sizes and colors to confidently choose the perfect bag for your brand. Material 100% Pure Cotton Fabric Details 220 GSM Quality Quantity 6 Bags (2 Bag of Each Size with different Colour) What''s Included 12 × 14 Inch Cotton Tote Bag | 220 GSM 14 × 16 Inch Cotton Tote Bag | 220 GSM 14 × 18 Inch Cotton Tote Bag | 220 GSM (Black) 12x14 Inch Cotton Tote Bag | 220 GSM (Black) 14x16 Inch Cotton Tote Bag | 220 GSM (Black) 14x18 Inch Cotton Tote Bag | 220 GSM Key Features 👜 Includes 6 popular tote bag samples. 🌿 Made from premium 220 GSM cotton. ⚫ Available in Natural and Black colors. 📏 Compare sizes before placing bulk orders. ♻️ Reusable and eco-friendly sample kit. Ideal For 🛍️ Bulk Order Planning – Compare sizes and colors before ordering. 🏷️ Brand Selection – Choose the right tote bag for your business. 👕 Retail &amp; Fashion Brands – Test bags for apparel and accessories. 🎁 Corporate Gifting – Find the ideal bag for events and promotions. 🌿 Quality Evaluation – Check fabric, stitching, and overall finish.',
        499.0,
        NULL,
        'SK109',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        'Cotton Tote Bag Sample Kit - 10 Sizes | 150 GSM',
        'cotton-tote-bag-sample-kit-10-sizes-150-gsm',
        'Explore EcoCarry''s cotton tote bag sample kit to compare sizes, fabric quality, and stitching before placing your bulk order with confidence. Material 100% Pure Cotton Fabric Details 150 GSM Quality Quantity 10 Bags (1 Bag of Each Size) What''s Included 1 Piece of Each Size 8 × 10 Inch Cotton Tote Bag 10 × 8 Inch Cotton Tote Bag 10 × 12 Inch Cotton Tote Bag 12 × 14 Inch Cotton Tote Bag 14 × 12 Inch Cotton Tote Bag 14 × 16 Inch Cotton Tote Bag 14 × 18 Inch Cotton Tote Bag 16 × 14 Inch Cotton Tote Bag 18 × 14 Inch Cotton Tote Bag 18 × 20 Inch Cotton Tote Bag Key Features 👜 Includes 10 popular cotton tote bag sizes. 🌿 Made from 100% pure 150 GSM cotton. 📏 Compare sizes before placing bulk orders. 🎨 Check fabric quality and stitching. ♻️ Reusable and eco-friendly sample kit. Ideal For 🛍️ Bulk Order Planning – Compare all sizes before ordering. 🏷️ Brand Selection – Find the right tote bag for your products. 👕 Retail &amp; Fashion Brands – Test sizes for apparel and accessories. 🎁 Corporate Gifting – Choose the perfect bag for events and giveaways. 🌿 Quality Evaluation – Check fabric, stitching, and overall finish.',
        499.0,
        NULL,
        'SK110',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'drawstring-bags'),
        'Cotton Drawstring Bag Sample Kit - 10 Sizes | 150 GSM',
        'cotton-drawstring-bag-sample-kit-10-sizes-150-gsm',
        'Explore all our popular cotton drawstring bag sizes with this convenient sample kit. The kit includes 10 different sizes (1 bag of each size), made from premium 150 GSM natural cotton. Perfect for checking size, fabric quality, stitching, and selecting the right bag before placing a bulk order. Material 100% Pure Cotton Fabric Details 150 GSM Quality Quantity 10 Bags (1 Bag of Each Size) Included Sizes 3×4 Inch Cotton Drawstring Bag | 150 GSM 4×5 Inch Cotton Drawstring Bag | 150 GSM 4×8 Inch Cotton Drawstring Bag | 150 GSM 5×7 Inch Cotton Drawstring Bag | 150 GSM 8×10 Inch Cotton Drawstring Bag | 150 GSM 10×12 Inch Cotton Drawstring Bag | 150 GSM 12×14 Inch Cotton Drawstring Bag | 150 GSM 14×16 Inch Cotton Drawstring Bag | 150 GSM 14×18 Inch Cotton Drawstring Bag | 150 GSM 18×20 Inch Cotton Drawstring Bag | 150 GSM Key Features 📦 Includes 10 popular drawstring bag sizes. 🌿 Made from 100% pure 150 GSM cotton. 📏 Compare sizes before placing bulk orders. 🎨 Perfect for product and packaging trials. ♻️ Reusable and eco-friendly sample kit. Ideal For 🛍️ Bulk Order Planning – Compare all sizes before placing bulk orders. 🎁 Packaging Selection – Find the right bag size for your products. 👕 Apparel &amp; Fashion Brands – Test packaging for clothing and accessories. 💍 Jewellery &amp; Lifestyle Brands – Choose the perfect size for premium products. 🏷️ Brand Sampling – Check fabric quality and stitching before customization. 🌿 Business Packaging – Select the ideal bag for your brand.',
        499.0,
        NULL,
        'SK111',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'paper-bags'),
        '8.5x13x5 Kraft Paper Bag | 110 GSM',
        'custom-8-5x13x5-kraft-paper-bag-110-gsm',
        'Material Premium Kraft Paper Size 8.5x5x13 ( W × G × H) Paper Detail 110 GSM High-Quality Kraft Paper Print Options Screen Printing. Key Features: 📏 Compact 8.5 × 5 × 13 Inch Size 🌿 Made from Recyclable &amp; Eco-Friendly Kraft Paper 💪 Strong &amp; Durable Construction 🛍️ Comfortable Twisted Paper Handles ♻️ Reusable, Biodegradable &amp; Sustainable ✨ Ideal for Custom Logo Printing &amp; Branding Ideal Use Cases: 🎁 Return Gifts – Perfect for weddings, birthdays, and special occasions. 🛍️ Retail Shopping – Ideal for boutiques, gift shops, and local stores. 🍪 Bakery &amp; Café Packaging – Great for pastries, cookies, snacks, and takeaway items. 💄 Cosmetics &amp; Beauty Products – Suitable for skincare, perfumes, and beauty essentials. 🎉 Corporate Events – Customize with your logo for exhibitions, conferences, and promotional giveaways. 🌿 Eco-Friendly Packaging – A sustainable alternative to plastic carry bags for everyday business use.',
        11.4,
        NULL,
        'EC281',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'paper-bags'),
        '7.5x11x5 Kraft Paper Bag | 110 GSM',
        'custom-7-5x11x5-kraft-paper-bag-110-gsm',
        'Material Premium Kraft Paper Size 7.5x5x11 ( W × G × H) Paper Detail 110 GSM High-Quality Kraft Paper Print Options Screen Printing. Key Features: 📏 Compact 7.5 x 5 x 11 Inch Size 🌿 Made from Recyclable &amp; Eco-Friendly Kraft Paper 💪 Strong &amp; Durable Construction 🛍️ Comfortable Twisted Paper Handles ♻️ Reusable, Biodegradable &amp; Sustainable ✨ Ideal for Custom Logo Printing &amp; Branding Ideal Use Cases: 🎁 Return Gifts – Perfect for weddings, birthdays, and special occasions. 🛍️ Retail Shopping – Ideal for boutiques, gift shops, and local stores. 🍪 Bakery &amp; Café Packaging – Great for pastries, cookies, snacks, and takeaway items. 💄 Cosmetics &amp; Beauty Products – Suitable for skincare, perfumes, and beauty essentials. 🎉 Corporate Events – Customize with your logo for exhibitions, conferences, and promotional giveaways. 🌿 Eco-Friendly Packaging – A sustainable alternative to plastic carry bags for everyday business use.',
        10.2,
        NULL,
        'EC282',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'paper-bags'),
        '10x14x5 Kraft Paper Bag | 110 GSM',
        'custom-10x14x5-kraft-paper-bag-110-gsm',
        'Material Premium Kraft Paper Size 10x5x14 ( W × G × H) Paper Detail 110 GSM High-Quality Kraft Paper Print Options Screen Printing. Key Features: 📏 Compact 10 × 5 × 14 Inch Size 🌿 Made from Recyclable &amp; Eco-Friendly Kraft Paper 💪 Strong &amp; Durable Construction 🛍️ Comfortable Twisted Paper Handles ♻️ Reusable, Biodegradable &amp; Sustainable ✨ Ideal for Custom Logo Printing &amp; Branding Ideal Use Cases: 🎁 Return Gifts - Perfect for weddings, birthdays, and special occasions. 🛍️ Retail Shopping - Ideal for boutiques, gift shops, and local stores. 🍪 Bakery &amp; Café Packaging - Great for pastries, cookies, snacks, and takeaway items. 💄 Cosmetics &amp; Beauty Products - Suitable for skincare, perfumes, and beauty essentials. 🎉 Corporate Events - Customize with your logo for exhibitions, conferences, and promotional giveaways. 🌿 Eco-Friendly Packaging - A sustainable alternative to plastic carry bags for everyday business use.',
        13.1,
        NULL,
        'EC280',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'paper-bags'),
        '12x16x5 Kraft Paper Bag | 110 GSM',
        'custom-12x16x5-kraft-paper-bag-110-gsm',
        'Material Premium Kraft Paper Size 12x5x16 ( W × G × H) Paper Detail 110 GSM High-Quality Kraft Paper Print Options Screen Printing Key Features: 📏 Compact 12x16x5 Inch Size 🌿 Made from Recyclable &amp; Eco-Friendly Kraft Paper 💪 Strong &amp; Durable Construction 🛍️ Comfortable Twisted Paper Handles ♻️ Reusable, Biodegradable &amp; Sustainable ✨ Ideal for Custom Logo Printing &amp; Branding Ideal Use Cases: 🎁 Return Gifts - Perfect for weddings, birthdays, and special occasions. 🛍️ Retail Shopping - Ideal for boutiques, gift shops, and local stores. 🍪 Bakery &amp; Café Packaging - Great for pastries, cookies, snacks, and takeaway items. 💄 Cosmetics &amp; Beauty Products - Suitable for skincare, perfumes, and beauty essentials. 🎉 Corporate Events - Customize with your logo for exhibitions, conferences, and promotional giveaways. 🌿 Eco-Friendly Packaging - A sustainable alternative to plastic carry bags for everyday business use.',
        14.3,
        NULL,
        'EC279',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '10x8 Inch Cotton Canvas Tote Bag',
        'custom-10x8-inch-cotton-canvas-tote-bag',
        'Material 100% Pure Cotton Size 10x8 Inch Fabric Details 150 GSM Quality 1 &amp; 2 Color Hand Screen Print - No size Limit Digital Print Heat Transfer DTF - Maximum size 2x2 Inch Key Features: ✅100% Natural Cotton – Eco-friendly, reusable, and biodegradable, making it the perfect alternative to plastic bags. ✅Strong &amp; Durable – Premium stitching and sturdy canvas fabric hold groceries, fruits, vegetables, books, and more with ease. ✅DIY &amp; Customizable – Ideal for screen printing, embroidery, fabric painting, tie-dye, and heat transfer vinyl – perfect for businesses, events, and personal use. ✅Multipurpose Tote – Use as a shopping bag, grocery bag, gift bag, craft project, corporate branding bag, or everyday carry-all. ✅Lightweight &amp; Convenient – Easy to fold, store, and carry anywhere – a must-have eco bag for daily shopping trips.',
        28.8,
        NULL,
        'EC196',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'canvas-tote-bags'),
        '12x10x3 Inch Cotton Canvas Bag | 330 GSM',
        'custom-12x10x3-inch-cotton-canvas-bag-330-gsm',
        'Material 100% Cotton Canvas Fabric Quality 330 GSM (Heavy Duty) Size 12x10x3 Inch ( Gasset Bag ) Handle Type 20 Inch Long Strong Shoulder Handles Digital Print For Digital Print Maximum size is 5x4 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use - Maximum 6x6 Inch Key Features Premium Heavy Canvas Material Strong, durable, and long-lasting fabric for everyday use Spacious Design with Gusset Full side &amp; bottom gusset (3") for extra capacity and better support Comfortable Web Handles 20-inch handles designed to carry heavy weight comfortably Multi-Purpose Usage Ideal for shopping, office use, gifting, events, and branding Minimal &amp; Customizable Perfect blank canvas for printing logos, designs, or branding',
        68.3,
        NULL,
        'EC262',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'canvas-tote-bags'),
        '10x12x5 Inch Cotton Canvas Bag | 330 GSM',
        'custom-10x12x5-inch-cotton-canvas-bag-330-gsm',
        'Material 100% Cotton Canvas Fabric Quality 330 GSM (Heavy Duty) Size 10x12x5 Inch ( Gasset Bag ) Handle Type 20 Inch Long Strong Shoulder Handles Digital Print For Digital Print Maximum size is 4x3 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use - Maximum 6x6 Inch Key Features Premium Heavy Canvas Material Strong, durable, and long-lasting fabric for everyday use Spacious Design with Gusset Full side &amp; bottom gusset (5") for extra capacity and better support Comfortable Web Handles 20-inch handles designed to carry heavy weight comfortably Multi-Purpose Usage Ideal for shopping, office use, gifting, events, and branding Minimal &amp; Customizable Perfect blank canvas for printing logos, designs, or branding',
        68.5,
        NULL,
        'EC261',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'canvas-tote-bags'),
        '12x12x7 Inch Cotton Canvas Bag | 330 GSM',
        'custom-12x12x7-inch-cotton-canvas-bag-330-gsm',
        'Material 100% Cotton Canvas Fabric Quality 330 GSM (Heavy Duty) Size 12x12x7 Inch ( Gasset Bag ) Handle Type 20 Inch Long Strong Shoulder Handles Digital Print For Digital Print Maximum size is 5x4 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use - Maximum 6x6 Inch Key Features Premium Heavy Canvas Material Strong, durable, and long-lasting fabric for everyday use Spacious Design with Gusset Full side &amp; bottom gusset (7") for extra capacity and better support Comfortable Web Handles 20-inch handles designed to carry heavy weight comfortably Multi-Purpose Usage Ideal for shopping, office use, gifting, events, and branding Minimal &amp; Customizable Perfect blank canvas for printing logos, designs, or branding',
        85.2,
        NULL,
        'EC259',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'canvas-tote-bags'),
        '15x15x6 Inch Cotton Canvas Bag | 330 GSM',
        'custom-15x15x6-inch-cotton-canvas-bag-330-gsm',
        'Material 100% Cotton Canvas Fabric Quality 330 GSM (Heavy Duty) Size 15x15x6 Inch ( Gasset Bag ) Handle Type 24 Inch Long Strong Shoulder Handles Digital Print For Digital Print Maximum size is 6x4.5 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use - Maximum 6x6 Inch Key Features Premium Heavy Canvas Material Strong, durable, and long-lasting fabric for everyday use Spacious Design with Gusset Full side &amp; bottom gusset (6") for extra capacity and better support Comfortable Web Handles 24-inch handles designed to carry heavy weight comfortably Multi-Purpose Usage Ideal for shopping, office use, gifting, events, and branding Minimal &amp; Customizable Perfect blank canvas for printing logos, designs, or branding',
        102.2,
        NULL,
        'EC260',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'saree-covers'),
        'Pastel Pink Cotton Saree Cover',
        'pink-cotton-saree-cover',
        'Perfect Size – 16 x 14 Inches: Spacious design to comfortably store and protect your precious sarees. 100% Pure Cotton Fabric: Breathable material prevents moisture buildup and helps maintain fabric quality. Protects &amp; Preserves: Keeps sarees safe from dust, humidity, and fabric deterioration, ensuring long-lasting vibrancy. Washable &amp; Reusable: Easy to clean and maintain for fresh, hygienic storage every time. Elegant Pastel Yellow Finish: Combines practical protection with a soft, premium look for your wardrobe.',
        449.0,
        NULL,
        'EC043',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'drawstring-bags'),
        '3x4 Inch Cotton Drawstring Bag | 150 GSM',
        'custom-3x4-inch-cotton-drawstring-bag-150-gsm',
        'Showcase your brand with custom-printed 3×4 inch cotton drawstring bags made from 100% pure cotton. A compact, reusable, and eco-friendly packaging solution for small products, gifting, and promotional branding. Material 100% Pure Cotton Size 3 × 4 Inch (7.62 × 10.16 cm) Fabric Details 150 GSM Cotton Fabric Screen Printing 1 &amp; 2 Color Hand Screen Printing (No Print Size Limit) Digital Printing Heat Transfer DTF - Maximum size 1.5x1.5 Inch Key Features: 📏 Compact 3x4 inch size – perfect for small items 🌿 Made from natural, eco-friendly cotton 🎯 Drawstring closure for easy opening &amp; secure storage ✨ Clean look – ideal for branding &amp; customization ♻️ Reusable &amp; sustainable packaging solution Ideal Use Cases: 💍 Jewelry Packaging – Perfect for rings, earrings, and small accessories 🪙 Coins &amp; Collectibles – Safe storage for coins and tiny valuables 🎁 Return Gifts – Great for weddings, pooja, and festive giveaways 🌱 Seed Packaging – Ideal for eco-friendly and sustainable brands 🔮 Spiritual Items – Suitable for crystals, stones, and sacred items',
        9.73,
        NULL,
        'EC189',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '13"x15" Yellow & Beige Tote Bag | 330 GSM',
        'custom-13x15-yellow-beige-tote-bag-330-gsm',
        'Material 100% Cotton Canvas Fabric Quality 330 GSM | Yellow &amp; Beige Color Size 13x15 Inch Handle Type 24 Inch Long Strong Shoulder Handles Digital Print For Digital Print Maximum size is 6x4.5 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use - Maximum 6x6 Inch Key Features Premium Heavy Canvas Material Strong, durable, and long-lasting fabric for everyday use Comfortable Web Handles 24-inch handles designed to carry heavy weight comfortably Multi-Purpose Usage Ideal for shopping, office use, gifting, events, and branding Minimal &amp; Customizable Perfect blank canvas for printing logos, designs, or branding',
        93.7,
        NULL,
        'EC009',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '13"x15" Red & Beige Tote Bag | 330 GSM',
        'custom-13x15-red-beige-tote-bag-330-gsm',
        'Material 100% Cotton Canvas Fabric Quality 330 GSM | Red &amp; Beige Color Size 13x15 Inch Handle Type 24 Inch Long Strong Shoulder Handles Digital Print For Digital Print Maximum size is 6x4.5 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use - Maximum 6x6 Inch Key Features Premium Heavy Canvas Material Strong, durable, and long-lasting fabric for everyday use Comfortable Web Handles 24-inch handles designed to carry heavy weight comfortably Multi-Purpose Usage Ideal for shopping, office use, gifting, events, and branding Minimal &amp; Customizable Perfect blank canvas for printing logos, designs, or branding',
        93.7,
        NULL,
        'EC007',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '13"x15" Beige Tote Bag | 330 GSM',
        'custom-13x15-beige-tote-bag-330-gsm',
        'Material 100% Cotton Canvas Fabric Quality 330 GSM (Heavy Duty) Size 13x15 Inch Handle Type 24 Inch Long Strong Shoulder Handles Digital Print For Digital Print Maximum size is 6x4.5 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use - Maximum 6x6 Inch Key Features Premium Heavy Canvas Material Strong, durable, and long-lasting fabric for everyday use Comfortable Web Handles 24-inch handles designed to carry heavy weight comfortably Multi-Purpose Usage Ideal for shopping, office use, gifting, events, and branding Minimal &amp; Customizable Perfect blank canvas for printing logos, designs, or branding',
        75.0,
        NULL,
        'EC005',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hamper-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hamper-bags' AND s.slug = 'hamper-bags'),
        '8.5x6x3.5 Inch Mini Hamper Bag | 330 GSM',
        'custom-8-5x6-inch-mini-hamper-bag-330-gsm',
        'Material 100% Pure Cotton Size 8.5 x 6 x 3.5 inch Fabric Details 330 GSM Quality Digital Print For Digital Print Maximum size is 3.5x2.5 Inch 1 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use - Maximum 4x4 Inch Ideal for Ideal for jewelry, perfumes, chocolates &amp; small luxury items Perfect for corporate gifting &amp; festive hampers Great for boutique stores &amp; premium product packaging Suitable for wedding favors &amp; return gifts Can be used for dry fruits &amp; dessert packaging Compact size, perfect for travel or personal storage Enhances product presentation &amp; perceived value Durable canvas material with a premium finish',
        53.6,
        NULL,
        'PM-0124',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'canvas-tote-bags'),
        '10x8x5 Inch Cotton Canvas Bag | 330 GSM',
        'custom-10x8x5-inch-cotton-canvas-bag-330-gsm',
        'Material 100% Cotton Canvas Fabric Quality 330 GSM (Heavy Duty) Size 10x8x4 Inch ( Gasset Bag ) Handle Type 14 Inch Long Strong Shoulder Handles Digital Print For Digital Print Maximum size is 4x3 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use - Maximum 5x5 Inch Key Features Premium Heavy Canvas Material Strong, durable, and long-lasting fabric for everyday use Spacious Design with Gusset Full side &amp; bottom gusset (5") for extra capacity and better support Comfortable Web Handles 14-inch handles designed to carry heavy weight comfortably Multi-Purpose Usage Ideal for shopping, office use, gifting, events, and branding Minimal &amp; Customizable Perfect blank canvas for printing logos, designs, or branding',
        69.3,
        NULL,
        'EC256',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'canvas-tote-bags'),
        '15x12x4 Inch Cotton Canvas Bag | 330 GSM',
        'custom-15x12x4-inch-cotton-canvas-bag-330-gsm',
        'Material 100% Cotton Canvas Fabric Quality 330 GSM (Heavy Duty) Size 14 × 15 × 4 Inch ( Gasset Bag ) Handle Type 22 Inch Long Strong Shoulder Handles Digital Print For Digital Print Maximum size is 6x4.5 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use - Maximum 6x6 Inch Key Features Premium Heavy Canvas Material Strong, durable, and long-lasting fabric for everyday use Spacious Design with Gusset Full side &amp; bottom gusset (4") for extra capacity and better support Comfortable Web Handles 22-inch handles designed to carry heavy weight comfortably Multi-Purpose Usage Ideal for shopping, office use, gifting, events, and branding Minimal &amp; Customizable Perfect blank canvas for printing logos, designs, or branding',
        99.4,
        NULL,
        'EC258',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'canvas-tote-bags'),
        '14x15x4 Inch Cotton Canvas Bag | 330 GSM',
        'custom-14x15x4-inch-cotton-canvas-bag-330-gsm',
        'Material 100% Cotton Canvas Fabric Quality 330 GSM (Heavy Duty) Size 14 × 15 × 4 Inch ( Gasset Bag ) Handle Type 22 Inch Long Strong Shoulder Handles Digital Print For Digital Print Maximum size is 6x4.5 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use - Maximum 6x6 Inch Key Features Premium Heavy Canvas Material Strong, durable, and long-lasting fabric for everyday use Spacious Design with Gusset Full side &amp; bottom gusset (4") for extra capacity and better support Comfortable Web Handles 22-inch handles designed to carry heavy weight comfortably Multi-Purpose Usage Ideal for shopping, office use, gifting, events, and branding Minimal &amp; Customizable Perfect blank canvas for printing logos, designs, or branding',
        84.34,
        NULL,
        'EC257',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '16x14 Inch Cotton Tote Bag | 150 GSM',
        'custom-16x14-inch-cotton-tote-bag-150-gsm',
        'Material 100% Pure Cotton Size 16x14 Inch Fabric Details 150 GSM Quality Digital Print For Digital Print Maximum size is 7x4.5 Inch Screen Print Black or Same as your Logo Color ( Single color Only ) Key Features: ✅100% Natural Cotton – Eco-friendly, reusable, and biodegradable, making it the perfect alternative to plastic bags. ✅Strong &amp; Durable – Premium stitching and sturdy canvas fabric hold groceries, fruits, vegetables, books, and more with ease. ✅DIY &amp; Customizable – Ideal for screen printing, embroidery, fabric painting, tie-dye, and heat transfer vinyl – perfect for businesses, events, and personal use. ✅Multipurpose Tote – Use as a shopping bag, grocery bag, gift bag, craft project, corporate branding bag, or everyday carry-all. ✅Lightweight &amp; Convenient – Easy to fold, store, and carry anywhere – a must-have eco bag for daily shopping trips.',
        41.0,
        NULL,
        'EC176',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '18x14 Inch Cotton Tote Bag | 150 GSM',
        'custom-18x14-inch-cotton-tote-bag-150-gsm',
        'Material 100% Pure Cotton Size 18x14 Inch Fabric Details 150 GSM Quality Digital Print For Digital Print Maximum size is 8x5 Inch Screen Print Black or Same as your Logo Color ( Single color Only ) Key Features: ✅100% Natural Cotton – Eco-friendly, reusable, and biodegradable, making it the perfect alternative to plastic bags. ✅Strong &amp; Durable – Premium stitching and sturdy canvas fabric hold groceries, fruits, vegetables, books, and more with ease. ✅DIY &amp; Customizable – Ideal for screen printing, embroidery, fabric painting, tie-dye, and heat transfer vinyl – perfect for businesses, events, and personal use. ✅Multipurpose Tote – Use as a shopping bag, grocery bag, gift bag, craft project, corporate branding bag, or everyday carry-all. ✅Lightweight &amp; Convenient – Easy to fold, store, and carry anywhere – a must-have eco bag for daily shopping trips.',
        43.7,
        NULL,
        'EC197',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '14x16 Inch Cotton Tote Bag | 150 GSM',
        'custom-14x16-inch-cotton-tote-bag-150-gsm',
        'Material 100% Pure Cotton Size 14x16 Inch Fabric Details 150 GSM Quality Digital Print For Digital Print Maximum size is 7x4.5 Inch Screen Print Black or Same as your Logo Color ( Single color Only ) Key Features: ✅100% Natural Cotton – Eco-friendly, reusable, and biodegradable, making it the perfect alternative to plastic bags. ✅Strong &amp; Durable – Premium stitching and sturdy canvas fabric hold groceries, fruits, vegetables, books, and more with ease. ✅DIY &amp; Customizable – Ideal for screen printing, embroidery, fabric painting, tie-dye, and heat transfer vinyl – perfect for businesses, events, and personal use. ✅Multipurpose Tote – Use as a shopping bag, grocery bag, gift bag, craft project, corporate branding bag, or everyday carry-all. ✅Lightweight &amp; Convenient – Easy to fold, store, and carry anywhere – a must-have eco bag for daily shopping trips.',
        41.0,
        NULL,
        'EC207',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '8x10 Inch Cotton Tote Bag | 150 GSM',
        'custom-8x10-inch-cotton-tote-bag-150-gsm',
        'Material 100% Pure Cotton Size 8x10 Inch Fabric Details 150 GSM Quality 1 &amp; 2 Color Hand Screen Print - No size Limit Digital Print Heat Transfer DTF - Maximum size 4x3 Inch Key Features: ✅100% Natural Cotton – Eco-friendly, reusable, and biodegradable, making it the perfect alternative to plastic bags. ✅Strong &amp; Durable – Premium stitching and sturdy canvas fabric hold groceries, fruits, vegetables, books, and more with ease. ✅DIY &amp; Customizable – Ideal for screen printing, embroidery, fabric painting, tie-dye, and heat transfer vinyl – perfect for businesses, events, and personal use. ✅Multipurpose Tote – Use as a shopping bag, grocery bag, gift bag, craft project, corporate branding bag, or everyday carry-all. ✅Lightweight &amp; Convenient – Easy to fold, store, and carry anywhere – a must-have eco bag for daily shopping trips.',
        24.1,
        NULL,
        'EC200',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '12x14 Inch Cotton Tote Bag | 150 GSM',
        'custom-12x14-inch-cotton-tote-bag-150-gsm',
        'Material 100% Pure Cotton Size 12x14 Inch Fabric Details 150 GSM Quality Digital Print For Digital Print Maximum size is 6.5x4 Inch Screen Print Black or Same as your Logo Color ( Single color Only ) Key Features: ✅100% Natural Cotton – Eco-friendly, reusable, and biodegradable, making it the perfect alternative to plastic bags. ✅Strong &amp; Durable – Premium stitching and sturdy canvas fabric hold groceries, fruits, vegetables, books, and more with ease. ✅DIY &amp; Customizable – Ideal for screen printing, embroidery, fabric painting, tie-dye, and heat transfer vinyl – perfect for businesses, events, and personal use. ✅Multipurpose Tote – Use as a shopping bag, grocery bag, gift bag, craft project, corporate branding bag, or everyday carry-all. ✅Lightweight &amp; Convenient – Easy to fold, store, and carry anywhere – a must-have eco bag for daily shopping trips.',
        36.0,
        NULL,
        'EC205',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '10x12 Inch Cotton Tote Bag | 150 GSM',
        'custom-10x12-inch-cotton-tote-bag-150-gsm',
        'Material 100% Pure Cotton Size 10x12 Inch Fabric Details 150 GSM Quality Digital Print For Digital Print Maximum size is 6x3.5 Inch Screen Print Black or Same as your Logo Color ( Single color Only ) Key Features: ✅100% Natural Cotton – Eco-friendly, reusable, and biodegradable, making it the perfect alternative to plastic bags. ✅Strong &amp; Durable – Premium stitching and sturdy canvas fabric hold groceries, fruits, vegetables, books, and more with ease. ✅DIY &amp; Customizable – Ideal for screen printing, embroidery, fabric painting, tie-dye, and heat transfer vinyl – perfect for businesses, events, and personal use. ✅Multipurpose Tote – Use as a shopping bag, grocery bag, gift bag, craft project, corporate branding bag, or everyday carry-all. ✅Lightweight &amp; Convenient – Easy to fold, store, and carry anywhere – a must-have eco bag for daily shopping trips.',
        28.4,
        NULL,
        'EC204',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'drawstring-bags'),
        '14x16 Inch Cotton Drawstring Bag | 150 GSM',
        'custom-14x16-inch-cotton-drawstring-bag-150-gsm',
        'Material 100% Pure Cotton Size 14x16 Inch Fabric Details 150 GSM Quality 1 &amp; 2 Color Hand Screen Print - No size Limit Digital Print Heat Transfer DTF - Maximum size 7x5 Inch Key Features: 📏 Large 14x16 inch size – perfect for bigger &amp; bulkier items 🌿 Made from natural, eco-friendly cotton 🎯 Drawstring closure for secure and easy handling ✨ Premium, minimal look – ideal for custom branding &amp; bulk use ♻️ Reusable, durable &amp; sustainable packaging solution Ideal Use Cases: 👕 Full Clothing Sets – shirts, pants, or complete outfits 👟 Shoes (Standard Size) – clean and organized storage 💻 Laptop + Accessories – chargers, cables, and essentials in one place 🥦 Bulk Grocery Storage – store fruits, veggies, or dry goods 🧺 Laundry Sorting Bags – separate clothes for easy washing',
        34.1,
        NULL,
        'EC004',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'drawstring-bags'),
        '18x20 Inch Cotton Drawstring Bag | 150 GSM',
        'custom-18x20-inch-cotton-drawstring-bag-150-gsm',
        'Material 100% Pure Cotton Size 18x20 Inch Fabric Details 150 GSM Quality 1 &amp; 2 Color Hand Screen Print - No size Limit Digital Print Heat Transfer DTF - Maximum size 8x5 Inch Key Features: 📏 Extra-large 18x20 inch size – ideal for heavy &amp; bulky items 🌿 Made from natural, eco-friendly cotton 🎯 Strong drawstring closure for secure storage &amp; easy carrying ✨ Clean, premium look – perfect for branding &amp; bulk usage ♻️ Reusable, durable &amp; sustainable alternative to plastic bags Ideal Use Cases: 🧥 Large Clothing – jackets, coats, and winter wear 🛏️ Blanket / Towel Storage – organize bulky household items 🛍️ Bulk Shopping Bag – eco-friendly alternative for large purchases 🧺 Laundry Bags – handle bigger loads conveniently 🎁 Corporate Kits / Event Giveaways – ideal for packaging multiple items in one bag',
        46.1,
        NULL,
        'EC195',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'drawstring-bags'),
        '14x18 Inch Cotton Drawstring Bag | 150 GSM',
        'custom-14x18-inch-cotton-drawstring-bag-150-gsm',
        'Material 100% Pure Cotton Size 14x18 Inch Fabric Details 150 GSM Quality 1 &amp; 2 Color Hand Screen Print - No size Limit Digital Print Heat Transfer DTF - Maximum size 7x5 Inch Key Features: 📏 Extra spacious 14x18 inch size – ideal for large &amp; bulky items 🌿 Made from natural, eco-friendly cotton 🎯 Strong drawstring closure for secure and easy handling ✨ Premium, minimal look – perfect for branding &amp; customization ♻️ Reusable, durable &amp; sustainable packaging solution Ideal Use Cases: 🧥 Hoodies / Jackets – easy storage for heavier garments 🪔 Sarees / Ethnic Wear – safe and elegant packaging 🏋️ Gym Kits – clothes, towel, and essentials in one bag 🧳 Travel Packing Cubes Alternative – organize luggage efficiently 🎪 Exhibition Kit Bags – carry materials, samples, or giveaways neatly',
        33.5,
        NULL,
        'EC194',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'drawstring-bags'),
        '12x14 Inch Cotton Drawstring Bag | 150 GSM',
        'custom-12x14-inch-cotton-drawstring-bag-150-gsm',
        'Material 100% Pure Cotton Size 12x14Inch Fabric Details 150 GSM Quality 1 &amp; 2 Color Hand Screen Print - No size Limit Digital Print Heat Transfer DTF - Maximum size 6.5x5 Inch Key Features: 📏 Large 12x14 inch size – ideal for bulkier items 🌿 Made from natural, eco-friendly cotton 🎯 Drawstring closure for easy handling &amp; secure storage ✨ Clean, premium look – perfect for custom branding ♻️ Reusable, durable &amp; sustainable packaging solution Ideal Use Cases: 🧥 Hoodies (Lightweight) – neat and premium packaging 👗 Saree Blouse / Small Garments – organized and protective storage 📂 Office Document Kits – keep files and papers together 🏋️ Gym Clothes Set – carry workout essentials easily 🧳 Travel Packing Organizers – sort clothes and accessories efficiently',
        26.6,
        NULL,
        'EC193',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'drawstring-bags'),
        '10x12 Inch Cotton Drawstring Bag | 150 GSM',
        'custom-10x12-inch-cotton-drawstring-bag-150-gsm',
        'Material 100% Pure Cotton Size 10x12 Inch Fabric Details 150 GSM Quality 1 &amp; 2 Color Hand Screen Print - No size Limit Digital Print Heat Transfer DTF - Maximum size 6x4.5 Inch Key Features: 📏 Generous 10x12 inch size – perfect for larger items 🌿 Made from natural, eco-friendly cotton 🎯 Drawstring closure for secure &amp; convenient use ✨ Premium, minimal look – ideal for branding &amp; customization ♻️ Reusable, durable &amp; sustainable packaging solution Ideal Use Cases: 👕 T-shirts / Shirts – elevated, premium packaging experience 🩴 Shoes – ideal for flip-flops, sandals, and lightweight footwear 🥜 Bulk Dry Fruits / Snacks – great for gifting and storage 👶 Baby Clothing Sets – soft, safe, and organized packaging 🎁 Combo Gift Packs – perfect for curated gift hampers',
        22.4,
        NULL,
        'EC190',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'drawstring-bags'),
        '8x10 Inch Cotton Drawstring Bag | 150 GSM',
        'custom-8x10-inch-cotton-drawstring-bag-150-gsm',
        'Designed to elevate your brand with sustainable packaging, this custom cotton drawstring bag combines everyday functionality with professional logo printing, helping businesses create a lasting impression. Material 100% Pure Cotton Size 8 × 10 Inch (20.32 × 25.40 cm) Fabric Details 150 GSM Cotton Fabric Screen Printing 1 &amp; 2 Color Hand Screen Printing (No Print Size Limit) Digital Print Heat Transfer DTF (Maximum Print Size: 4 × 3 Inch ) Key Features: 📏 Spacious 8×10 inch size – ideal for medium-sized products. 🌿 Made from 100% pure, eco-friendly cotton. 🎨 Custom logo printing for professional branding. 🎯 Drawstring closure for easy use and secure storage. ♻️ Reusable and durable for sustainable packaging. Ideal Use Cases: 👕 T-Shirt Packaging – Perfect for packing a single T-shirt with a premium branded presentation. 📚 Books &amp; Notebooks – Ideal for educational kits, journals, and stationery packaging. 🧴 Travel Toiletry Kits – Great for organizing grooming products and travel essentials. 🎨 Activity &amp; DIY Kits – Suitable for kids'' activity kits, craft supplies, and hobby products. 🩲 Lingerie Packaging – Elegant packaging for innerwear, apparel, and boutique brands. 🏷️ Retail &amp; Promotional Packaging – Customize with your logo for boutiques, exhibitions, corporate gifts, and promotional giveaways.',
        18.4,
        NULL,
        'EC191',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'drawstring-bags'),
        '5x7 Inch Cotton Drawstring Bag | 150GSM',
        'custom-5x7-inch-cotton-drawstring-bag-150-gsm',
        'Create memorable packaging with custom-branded cotton drawstring bags made from 100% pure cotton. Designed for businesses seeking sustainable, reusable, and professional packaging solutions. Material 100% Pure Cotton Size 5×7 Inch (12.7 × 17.78 cm) Fabric Details 150 GSM Cotton Fabric Digital Print Heat Transfer DTF (Maximum Print Size: 2.5 × 2.5 Inch) Key Features: 📏 Practical 5x7 inch size – ideal for medium-small items 🌿 Made from natural, eco-friendly cotton 🎯 Drawstring closure for secure and convenient use ✨ Minimal &amp; premium look – perfect for custom branding ♻️ Reusable, durable &amp; sustainable packaging solution Ideal Use Cases: 📱 Mobile Accessories Packaging – Perfect for chargers, cables, earphones, and small electronic accessories. 💄 Cosmetics Packaging – Ideal for lipsticks, compact powders, beauty products, and makeup essentials. 🥜 Dry Fruit Packaging – Great for 100–200g dry fruits, festive gifts, and premium hampers. 🧼 Handmade Soap Packaging – Suitable for artisan soaps, organic skincare, and wellness brands. 🧴 Mini Skincare Kits – Perfect for travel-size skincare products, samples, and promotional kits. 🎁 Custom Promotional Packaging – Add your logo for corporate gifting, retail packaging, events, and brand promotions.',
        12.9,
        NULL,
        'EC192',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'drawstring-bags'),
        '4x8 Inch Cotton Drawstring Bag | 150 GSM',
        'custom-4x8-inch-cotton-drawstring-bag-150-gsm',
        'Showcase your brand with custom-printed cotton drawstring bags made from 100% pure cotton. Designed for sustainable, reusable packaging that combines functionality with a professional branded appearance. Material 100% Pure Cotton Size 4×8 Inch (10.16 × 20.32 cm) Fabric Details 150 GSM Cotton Fabric Digital Print Heat Transfer DTF (Maximum size 2x2 Inch) Key Features: 📏 Slim 4x8 inch size – perfect for long and narrow items 🌿 Made from natural, eco-friendly cotton 🎯 Drawstring closure for easy access &amp; secure storage ✨ Clean, minimal look – ideal for branding &amp; customization ♻️ Reusable &amp; durable – sustainable packaging solution Ideal Use Cases: 🍴 Cutlery Kits – Spoon, fork, straw sets for travel or eco brands 🪔 Incense Sticks (Agarbatti) – Neat and safe spiritual packaging 💄 Makeup Brushes – Store a few brushes for daily or travel use ✏️ Pens &amp; Stationery Kits – Organize pens, markers, and essentials neatly 🎁 Corporate &amp; Promotional Gifts – Customize with your logo for events, exhibitions, giveaways, and employee gifts.',
        12.8,
        NULL,
        'EC198',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'drawstring-bags'),
        '4×5 Inch Cotton Drawstring Bag | 150 GSM',
        'custom-4x5-inch-cotton-drawstring-bag-150-gsm',
        'Promote your brand with custom-printed cotton drawstring bags made from 100% pure cotton. A sustainable and reusable packaging solution for businesses, gifting, retail, and promotional packaging. Material 100% Pure Cotton Size 4x5 inch (10.16 x 12.7 cm) Fabric Details 150 GSM Quality Screen Printing 1 &amp; 2 Color Hand Screen Printing (No Print Size Limit) Digital Print Heat Transfer DTF (Maximum Print Size: 2 × 2 Inch) Key Features: 📏 Compact 4x5 inch size – perfect for small items 🌿 Made from natural, eco-friendly cotton 🎯 Drawstring closure for easy opening &amp; secure storage ✨ Clean look – ideal for branding &amp; customization ♻️ Reusable &amp; sustainable packaging solution Ideal Use Cases: 💍 Jewelry Packaging – Perfect for rings, earrings, and small accessories 🪙 Coins &amp; Collectibles – Safe storage for coins and tiny valuables 🎁 Return Gifts – Great for weddings, pooja, and festive giveaways 🌱 Seed Packaging – Ideal for eco-friendly and sustainable brands 🔮 Spiritual Items – Suitable for crystals, stones, and sacred items 🏷️ Retail &amp; Promotional Packaging – Add your logo for boutiques, exhibitions, corporate gifting, and promotional giveaways.',
        11.7,
        NULL,
        'EC245',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'saree-covers'),
        'Custom Cotton Saree Cover | 16x14 Inch',
        'custom-cotton-saree-cover-16x14-inch',
        'Big Size Single (16x14 Inch) With Zip Closure For Clothes Bags And Wardrobe Organizer With Transparent Mesh Window, Beige. Product Name - Customizable Saree Cover Fabric - 100% Pure Cotton (150 GSM) GSM (Grams per Square Meter) - 150 GSM Size (L x W) - 16 × 14 Inches Closure Type - Zipper Special Feature - Mesh Window for Visibility 𝐒𝐭𝐢𝐭𝐜𝐡𝐢𝐧𝐠 - Hand Stitched Usage/Application - Saree Storage, Wardrobe Organizer, Gifting Reusable - Yes, Washable and Reusable 𝐂𝐨𝐥𝐨𝐫 - Off-White (Beige) Country of Origin - Made in India This is a handmade product, so the actual measurements may be slightly more than or equal to the specified size. 𝐂𝐚𝐫𝐞: The saree covers are washable. Wash them with mild detergent and cold water. Iron after washing for a neat look.',
        38.9,
        NULL,
        'EC217',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '12x14 Inch Cotton Tote Bag | 220 GSM',
        'custom-12x14-inch-cotton-tote-bag-220-gsm',
        'Material 100% Pure Cotton Size 12x14 Inch Fabric Details 220 GSM Quality 1 &amp; 2 Color Hand Screen Print - No size Limit Digital Print Heat Transfer DTF - Maximum size 6x5 Inch Embroidery Machine Embroidery - Maximum size 6x6 Inch - 4 Color Max . Key Features: ✅100% Natural Cotton – Eco-friendly, reusable, and biodegradable, making it the perfect alternative to plastic bags. ✅Strong &amp; Durable – Premium stitching and sturdy canvas fabric hold groceries, fruits, vegetables, books, and more with ease. ✅DIY &amp; Customizable – Ideal for screen printing, embroidery, fabric painting, tie-dye, and heat transfer vinyl – perfect for businesses, events, and personal use. ✅Multipurpose Tote – Use as a shopping bag, grocery bag, gift bag, craft project, corporate branding bag, or everyday carry-all. ✅Lightweight &amp; Convenient – Easy to fold, store, and c',
        39.4,
        NULL,
        'EC148',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '14x18 Inch Cotton Tote Bag | 220 GSM',
        'custom-14x18-inch-cotton-tote-bag-220-gsm',
        'Material 100% Pure Cotton Size 14x18 Inch Fabric Details 220 GSM Quality 1 &amp; 2 Color Hand Screen Print - No size Limit Digital Print Heat Transfer DTF - Maximum size 8x5 Inch Embroidery Machine Embroidery - Maximum size 8x8 Inch - 4 Color Max . Key Features: ✅100% Natural Cotton – Eco-friendly, reusable, and biodegradable, making it the perfect alternative to plastic bags. ✅Strong &amp; Durable – Premium stitching and sturdy canvas fabric hold groceries, fruits, vegetables, books, and more with ease. ✅DIY &amp; Customizable – Ideal for screen printing, embroidery, fabric painting, tie-dye, and heat transfer vinyl – perfect for businesses, events, and personal use. ✅Multipurpose Tote – Use as a shopping bag, grocery bag, gift bag, craft project, corporate branding bag, or everyday carry-all. ✅Lightweight &amp; Convenient – Easy to fold, store, and c',
        48.8,
        NULL,
        'EC147',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '14x16 Inch Cotton Tote Bag | 220 GSM',
        '14x18-inch-cotton-tote-bag-220-gsm-custom',
        'Material 100% Pure Cotton Size 14x16 Inch Fabric Details 220 GSM Quality 1 &amp; 2 Color Hand Screen Print - No size Limit Digital Print Heat Transfer DTF - Maximum size 7x4.5 Inch Embroidery Machine Embroidery - Maximum size 7x6 Inch - 4 Color Max . Key Features: ✅100% Natural Cotton – Eco-friendly, reusable, and biodegradable, making it the perfect alternative to plastic bags. ✅Strong &amp; Durable – Premium stitching and sturdy canvas fabric hold groceries, fruits, vegetables, books, and more with ease. ✅DIY &amp; Customizable – Ideal for screen printing, embroidery, fabric painting, tie-dye, and heat transfer vinyl – perfect for businesses, events, and personal use. ✅Multipurpose Tote – Use as a shopping bag, grocery bag, gift bag, craft project, corporate branding bag, or everyday carry-all. ✅Lightweight &amp; Convenient – Easy to fold, store, and c',
        45.6,
        NULL,
        'EC145',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'saree-covers'),
        'Light Brown Cotton Saree Cover',
        'brown-cotton-saree-cover',
        'Perfect Size – 16 x 14 Inches: Spacious design to comfortably store and protect your precious sarees. 100% Pure Cotton Fabric: Breathable material prevents moisture buildup and helps maintain fabric quality. Protects &amp; Preserves: Keeps sarees safe from dust, humidity, and fabric deterioration, ensuring long-lasting vibrancy. Washable &amp; Reusable: Easy to clean and maintain for fresh, hygienic storage every time. Elegant Pastel Yellow Finish: Combines practical protection with a soft, premium look for your wardrobe.',
        449.0,
        NULL,
        'EC042',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'saree-covers'),
        'Pastel Yellow Cotton Saree Cover',
        'yellow-cotton-saree-cover',
        'Perfect Size – 16 x 14 Inches: Spacious design to comfortably store and protect your precious sarees. 100% Pure Cotton Fabric: Breathable material prevents moisture buildup and helps maintain fabric quality. Protects &amp; Preserves: Keeps sarees safe from dust, humidity, and fabric deterioration, ensuring long-lasting vibrancy. Washable &amp; Reusable: Easy to clean and maintain for fresh, hygienic storage every time. Elegant Pastel Yellow Finish: Combines practical protection with a soft, premium look for your wardrobe.',
        449.0,
        NULL,
        'EC044',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'pouch-bags'),
        'Everyday Cotton Zipper Pouch',
        'custom-everyday-cotton-zipper-pouch',
        'Material 100% Pure Cotton Size 8x5x2.5 (2.5 Inch Base) Fabric Details 330 GSM Quality 1 Color Hand Screen Print - No size Limit Digital Print Heat Transfer DTF - Maximum size 3.5x2.5 Inch Key Features: 📏 Perfect Everyday Size (8×5.5×2.5 inches) 🌿 Premium 330 GSM Cotton Fabric 🔒 Smooth &amp; Secure Zipper Closure 🎒 Easy to Carry &amp; Reusable ✨ Perfect for Customization Ideal Use Cases: 💄 Makeup &amp; Cosmetics – Store lipsticks, compact, brushes, skincare, and daily beauty essentials. ✏️ Stationery Pouch – Keep pens, pencils, markers, erasers, and office supplies organized. 🔌 Tech Accessories – Organize chargers, USB cables, power banks, earphones, and small gadgets. 💎 Jewellery Storage – Carry rings, earrings, necklaces, and other accessories safely while travelling. 🧳 Travel Organizer – Perfect for toiletries, medicines, grooming essentials, and travel accessories. 🎁 Corporate &amp; Promotional Gifts – Customize with your logo for events, employee gifts, or brand promotions.',
        33.0,
        NULL,
        'PM-0149',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'pouch-bags'),
        'Mini Cotton Zipper Pouch',
        'custom-mini-cotton-zipper-pouch',
        'Material 100% Pure Cotton Size 6x5x2.5 (2.5 Inch Base) Fabric Details 330 GSM Quality 1 Color Hand Screen Print - No size Limit Digital Print Heat Transfer DTF - Maximum size 3x2 Inch Key Features: 📏 Compact 6 × 5 × 2.5 Inch Size 🌿 Premium 330 GSM Cotton Canvas 🔒 Smooth &amp; Secure Zipper Closure 👜 Lightweight &amp; Easy to Carry ♻️ Eco-Friendly &amp; Reusable ✨ Perfect for Customization Ideal Use Cases: 💍 Jewellery Pouch – Store rings, earrings, bracelets, pendants, and other small accessories safely. 💄 Mini Makeup Essentials – Carry lipstick, lip balm, compact mirror, hair ties, and beauty essentials. 🎧 Tech Accessories – Organize earphones, charging cables, USB drives, memory cards, and adapters. 🪙 Coins &amp; Cash – Use as a compact coin purse or for keeping loose cash and cards. ✈️ Travel Essentials – Perfect for medicines, keys, SIM cards, sanitizer, or other small travel accessories. 🎁 Corporate &amp; Promotional Gifts – Customize with your logo for employee kits, giveaways, brand promotions, or event gifting.',
        26.5,
        NULL,
        'PM-0150',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'pouch-bags'),
        'Travel Cotton Zipper Pouch',
        'custom-travel-cotton-zipper-pouch',
        'Material 100% Pure Cotton Size 10x6x2.5 (2.5 Inch Base) Fabric Details 330 GSM Quality 1 Color Hand Screen Print - No size Limit Digital Print Heat Transfer DTF - Maximum size 4x2.5 Inch Key Features: 📏 Spacious 10 × 6 × 2.5 Inch Size 🌿 Premium 330 GSM Cotton Canvas 🔒 Smooth &amp; Secure Zipper Closure 🧳 Lightweight &amp; Travel-Friendly ♻️ Eco-Friendly &amp; Reusable ✨ Ideal for Customization Ideal Use Cases: 🧴 Toiletries &amp; Travel Essentials – Organize shampoo, toothbrush, razor, and travel-size products. 💄 Makeup &amp; Skincare Products – Store cosmetics, skincare, and daily beauty essentials. 🔌 Chargers &amp; Tech Accessories – Keep cables, chargers, power banks, and gadgets neatly organized. 📄 Documents &amp; Travel Accessories – Carry passports, tickets, IDs, and important travel items. 🧳 Luggage Organizer – Keep your suitcase organized and clutter-free during travel. 🎁 Corporate Gifting &amp; Branding – Customize with your logo for events, giveaways, and promotional gifts.',
        49.6,
        NULL,
        'PM-0151',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'canvas-tote-bags'),
        '15x12x5 Cotton Canvas Tote Bag | 400 GSM',
        'custom-premium-cotton-tote-bag-white',
        'Material 100% Cotton Canvas Fabric Quality 330 GSM (Heavy Duty) Size 15 × 12 × 5 Inch Digital Print For Digital Print Maximum size is 4x3 Inch 1&amp;2 Color Screen Print Hand Screen Print - No size Limit Embroidery 4 Threads can be use - Maximum 5x5 Inch Key Features Premium Heavy Canvas Material Strong, durable, and long-lasting fabric for everyday use Spacious Design with Base Bottom Full side &amp; bottom gusset (5") for extra capacity and better support Comfortable Web Handles 20-inch handles designed to carry heavy weight comfortably Multi-Purpose Usage Ideal for shopping, office use, gifting, events, and branding Minimal &amp; Customizable Perfect blank canvas for printing logos, designs, or branding',
        187.7,
        NULL,
        'PM-0152',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'box-tote-bags'),
        'Personalised Sunflower Tote Bag',
        'personalised-sunflower-embroidered-box-tote-bag',
        'Carry sunshine everywhere with this beautiful Sunflower Tote Bag . Made from durable cotton fabric, this eco-friendly bag features vibrant sunflower embroidery that adds charm and beauty to your everyday look. Designed with sturdy handles and a spacious interior, it is perfect for daily use, shopping, office, or casual outings. Lightweight yet strong, this reusable tote bag is a stylish alternative to leather bags and makes a thoughtful gift for nature and flower lovers. Features: Fabric: 100% Pure Cotton Canvas (330 GSM) Customisable: Custom name Only Design: Sunflower Box Tote Bag Closure: Secure Main Zipper Size: 12 x 14 x 5 Inch Eco-Friendly: Durable &amp; Reusable Best For: Shopping | Office | College | Gifting | Everyday Carry ➤ Note:- Charm not Included',
        899.0,
        NULL,
        'EC082',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'box-tote-bags'),
        'Personalised Humming Bird Bloom Tote Bag',
        'personalised-humming-bird-bloom-tote-bag',
        'The Personalised Humming Bird Bloom Tote Bag is a stylish and eco-friendly carry all designed for everyday use. Made from durable canvas with brown handles and trims, this tote blends with practicality. The front features a beautiful embroidered hummingbird and floral design in earthy tones, along with your personalised name, making it a unique bag just for you. Perfect for office, college, shopping, or casual outings, this tote offers enough space to carry books, files, groceries, or daily essentials. Its sturdy handles ensure comfort and long-lasting use, while the natural canvas fabric makes it a sustainable choice. Whether you’re looking for a thoughtful gift or a versatile daily bag, the Personalised Humming Bird Bloom Tote Bag is the perfect combination of beauty, strength, and personal touch. Features: Fabric: 100% Pure Cotton Canvas (330 GSM) Customisable: Custom name Only Design: Sunflower Box Tote Bag Closure: Secure Main Zipper Size: 12 x 14 x 5 Inch Eco-Friendly: Durable &amp; Reusable Best For: Shopping | Office | College | Gifting | Everyday Carry ➤ Note:- Charm not Included',
        899.0,
        NULL,
        'EC080',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'mini-tote-bags'),
        'Purple Unicorn Mini Hand Bag',
        'purple-unicorn-mini-hand-bag',
        'The Purple Unicorn Mini Hand Bag is a cute and stylish everyday bag designed with a magical unicorn embroidery on the front. Made with durable canvas fabric, it comes with a soft lavender panel decorated with colorful flowers and stars, giving it a dreamy and playful look. The bag features both short handles and a detachable long strap, making it easy to carry by hand or wear crossbody. With a front zipper pocket and spacious main compartment, this bag is perfect for school, shopping, travel, or casual outings. A must-have for unicorn lovers and anyone who enjoys fun fashion accessories. Features: Cute unicorn design - colorful embroidered unicorn with flowers and stars. Durable canvas material - strong, lightweight, and long-lasting. 2-in-1 style - carry as a handbag with top handles or as a crossbody with the detachable strap. Compact &amp; practical - perfect size for phone, wallet, keys, and small essentials. Everyday use - great for school, shopping, travel, or casual outings. Perfect gift choice - ideal for kids, teens, and unicorn lovers.',
        899.0,
        NULL,
        'PM-0155',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'mini-tote-bags'),
        'Beige Unicorn Mini Hand Bag',
        'beige-unicorn-mini-hand-bag',
        'The Beige Unicorn Mini Hand Bag is a cute and stylish accessory designed for everyday use. Made with durable canvas fabric, this bag features a beautiful embroidered unicorn design surrounded by colorful flowers and stars. It comes with sturdy top handles and a detachable adjustable strap, making it easy to carry as a handbag or shoulder bag. Perfect for kids, teens, and unicorn lovers, this mini bag is ideal for school, outings, or casual use. Features: Cute unicorn design – colorful embroidered unicorn with flowers and stars. Durable canvas material – strong, lightweight, and long-lasting. 2-in-1 style – carry as a handbag with top handles or as a crossbody with the detachable strap. Compact &amp; practical – perfect size for phone, wallet, keys, and small essentials. Everyday use – great for school, shopping, travel, or casual outings. Perfect gift choice – ideal for kids, teens, and unicorn lovers.',
        899.0,
        NULL,
        'PM-0156',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'mini-tote-bags'),
        'Twin Cats Mini Hand Bag',
        'twin-cats-mini-hand-bag',
        'Bring cuteness and charm to your everyday look with the Twin Cats Mini Hand Bag . Made from strong navy blue canvas, this bag is designed with beautiful embroidery of two lovely cats surrounded by flowers. Its compact size makes it perfect for carrying your daily essentials while adding a playful and stylish touch to your outfit. This handbag comes with dual handles and a detachable shoulder strap, so you can carry it your way – as a crossbody or as a mini tote. The front zipper pocket keeps small items handy, while the spacious main compartment keeps your belongings safe and organized. Perfect for casual outings, shopping, college, or gifting, the Twin Cats Mini Hand Bag is a must-have for cat lovers and anyone who enjoys unique accessories. Features: Cute Cat Embroidery – Features two adorable cats with floral embroidery for a stylish and playful look. Durable Material – Made with strong navy blue canvas for long-lasting use. Compact &amp; Spacious – Mini size with enough room to carry daily essentials. Multiple Carry Options – Comes with dual handles and a detachable, adjustable shoulder strap. Front Zipper Pocket – Easy access to small items like keys, phone, or cards. Everyday Use – Perfect for shopping, college, casual outings, or gifting to cat lovers.',
        899.0,
        NULL,
        'PM-0157',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'mini-tote-bags'),
        'Good Things Ahead Mini Hand Bag',
        'good-things-ahead-mini-hand-bag',
        'The Good Things Ahead Mini Hand Bag is a stylish and positive everyday bag designed to keep you motivated wherever you go. Made from durable canvas fabric, this handbag is lightweight, strong, and perfect for daily use. The front panel features colorful embroidery with the words ''Good Things Ahead'' and a cheerful sun, giving it a fun and uplifting look. This mini hand bag comes with sturdy top handles and a detachable shoulder strap, so you can carry it as a handbag, shoulder bag, or crossbody bag. The front zipper pocket adds extra convenience for storing keys, cards, or your phone, while the main compartment offers enough space for your essentials like a wallet, notebook, makeup, or tablet. Perfect for college, office, shopping, or casual outings, this bag adds a touch of positivity and color to your everyday style. Features: Premium Canvas Material - Made from durable and eco-friendly canvas fabric, lightweight yet strong for daily use. Positive &amp; Colorful Design - Embroidered ''Good Things Ahead'' text with a cheerful sun adds motivation and charm. Multi-Carry Options - Comes with sturdy top handles and a detachable, adjustable strap for handbag, shoulder, or crossbody use. Spacious &amp; Functional - Front zipper pocket for quick access and roomy main compartment for wallet, phone, notebook, or makeup. Perfect Everyday Bag - Ideal for college, office, shopping, travel, or casual outings with a touch of positivity. Trendy &amp; Gift-Ready - Stylish and uplifting design makes it a great gift for friends, students, or working professionals.',
        899.0,
        NULL,
        'PM-0158',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        'Black Daisy Tote Bag',
        'black-daisy-tote-bag',
        'Carry your essentials in style with this Black Daisy Tote Bag . Made from strong cotton fabric, this eco-friendly tote features a beautiful daisy bouquet print that adds a fresh and cheerful touch to your everyday look. With sturdy beige handles, it is comfortable to carry on your shoulder or in hand. Perfect for shopping, college, office, travel, or daily use, this reusable tote bag is both fashionable and practical. Features: Stylish Design: Black tote bag with a charming daisy bouquet print for a fresh and trendy look. Eco-Friendly Choice: Made from durable cotton fabric, reusable and sustainable alternative to plastic bags. Strong &amp; Durable: Sturdy canvas material with thick beige cotton handles for long-lasting use. Spacious &amp; Practical: Perfect size for carrying books, groceries, laptop, or daily essentials. Versatile Use: Ideal for shopping, college, office, travel, beach trips, or everyday carry. Perfect Gift: A thoughtful and stylish gift for friends, family, or nature lovers.',
        299.0,
        NULL,
        'PM-0159',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        'Black Panda Tote Bag',
        'black-panda-tote-bag',
        'Carry cuteness wherever you go with this Black Panda Tote Bag . Made from strong cotton canvas, this eco-friendly tote is designed for daily use and features a lovable panda print sitting on bamboo with a little butterfly. Its soft yet sturdy handles make it comfortable to carry, while the spacious design gives you enough room for shopping, books, office essentials, or casual outings. Perfect for panda lovers, students, and anyone who enjoys a stylish reusable bag. This Black Panda Tote Bag is lightweight, durable, and reusable, making it an eco-conscious choice for everyday life. Whether you’re going to college, work, or just stepping out for errands, this tote will keep you looking trendy while helping you reduce plastic use. Features: Cute Panda Design - Features an adorable panda sitting with bamboo and a butterfly, perfect for animal and nature lovers. Spacious &amp; Practical - Large enough to carry books, groceries, office files, or daily essentials with ease. Eco-Friendly Choice - Made from durable cotton canvas, reusable and sustainable, helping reduce plastic waste. Strong &amp; Comfortable Handles - Sturdy cotton straps for easy carrying on shoulder or in hand. Perfect Gift Idea - A fun and stylish tote bag for students, friends, or anyone who loves pandas and eco-friendly fashion.',
        299.0,
        NULL,
        'PM-0160',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        'Be Happy Sunflower Tote Bag',
        'be-happy-sunflower-tote-bag',
        'Carry positivity wherever you go with the Be Happy Sunflower Tote Bag . Made from strong and eco-friendly cotton fabric, this navy blue tote features a bright yellow sunflower print with the inspiring quote “ Be Happy ” . Its sturdy yellow handles make it comfortable to carry, while the spacious design is perfect for shopping, office, college, or daily outings. Stylish, reusable, and durable, this sunflower tote bag is a cheerful alternative to plastic bags and a perfect companion for everyday use. Features: Cheerful Design - Navy blue tote bag with a bright yellow sunflower and “Be Happy” motivational print. Durable Material - Made from strong, eco-friendly cotton canvas for long-lasting use. Multi-Purpose Use - Perfect for shopping, office, college, gifting, travel, or everyday outings. Comfortable to Carry - Sturdy yellow cotton handles ensure a strong grip and easy carrying. Eco-Friendly Choice - A reusable and sustainable alternative to plastic bags. Spacious &amp; Stylish - Large enough to carry books, groceries, or essentials while staying trendy.',
        299.0,
        NULL,
        'PM-0161',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        'Believe in Yourself Butterfly Tote Bag',
        'believe-in-yourself-butterfly-tote-bag',
        'The Believe in Yourself Butterfly Tote Bag is a stylish and eco-friendly cotton tote designed for everyday use. Featuring a beautiful butterfly and floral print with the motivational quote “Believe in Yourself,” this bag is perfect for carrying books, groceries, office supplies, or daily essentials. Its durable cotton fabric and strong handles make it long-lasting, reusable, and comfortable to carry. A perfect blend of fashion and functionality, this tote bag is great for students, shopping, work, travel, or gifting. Features: Motivational Design - Features a butterfly and floral print with the inspiring quote “Believe in Yourself.” Durable Cotton Fabric - Made from strong, eco-friendly cotton for long-lasting everyday use. Strong &amp; Comfortable Handles - Wide cotton straps make it easy to carry heavy items on your shoulder or in hand. Reusable &amp; Eco-Friendly - A sustainable alternative to plastic bags, perfect for shopping and daily use. Stylish &amp; Versatile - Ideal for college, office, groceries, travel, or as a thoughtful gift.',
        299.0,
        NULL,
        'PM-0162',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        'Plain Navy Blue Tote Bag',
        'plain-navy-blue-tote-bag',
        'Material 100% Pure Cotton Size 13x15 inch Fabric Details 330 GSM Quality | Navy Blue Handle Sky Blue Pure Cotton 1.5 Inch Wide Webbing Handle Length 24 Inch Long Straps ( 10 Inch Height ) Key Features : Spacious Size – roomy enough for books, groceries, or daily essentials. Comfortable Handles – Pure Cotton and Smooth Finished Webbing Handle, it is strong and durable Customizable Surface – Great for screen printing, embroidery, or fabric painting. Perfect for All Uses – Ideal for shopping, gifting, corporate packaging, events, and exhibitions. Lightweight &amp; Foldable – Easy to carry, pack, and reuse every day.',
        299.0,
        NULL,
        'PM-0163',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        'Evil Eye Everyday Tote Bag',
        'evil-eye-everyday-tote-bag',
        'Carry style and positivity everywhere with our Evil Eye Everyday Tote Bag . Made from strong and eco-friendly cotton canvas, this bag is durable, reusable, and perfect for daily use. The striking evil eye design at the center is not just trendy but also symbolizes protection and good vibes. With sturdy navy blue handles, it’s easy to carry on your shoulder or by hand, making it ideal for shopping, office, college, or casual outings. This eco-friendly tote bag is lightweight yet spacious enough to hold books, groceries, laptops, or everyday essentials. Washable and reusable, it’s a sustainable choice for anyone who loves fashion with purpose. Features: Evil Eye Everyday Tote Bag – Stylish cotton canvas bag with a protective evil eye design Durable &amp; Eco-Friendly – Made from strong, reusable cotton fabric, perfect for daily use Comfortable Handles – Sturdy navy blue cotton webbing handles for easy shoulder or hand carry Spacious &amp; Lightweight – Ideal for carrying books, groceries, laptop, or office/college essentials Washable &amp; Reusable – A sustainable alternative to plastic bags, easy to clean and long-lasting Trendy &amp; Meaningful – Evil eye print adds a touch of fashion while symbolizing good vibes and protection',
        299.0,
        NULL,
        'PM-0164',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        'Bow with Cherry Tote Bag',
        'bow-with-cherry-tote-bag',
        'The Bow with Cherry Tote Bag is a trendy and eco-friendly bag made from strong cotton canvas. Its unique cherry and bow design gives it a stylish and cheerful look, while the wide webbing handles ensure comfort for everyday use. This reusable tote is perfect for carrying groceries, books, office files, or daily essentials. Lightweight yet durable, it is the perfect mix of fashion and functionality. Use it for shopping, college, work, or casual outings – and do your part for the environment by switching to a sustainable tote bag. Features: Stylish Design: Beautiful tote bag with a cute bow and cherry print, perfect for daily use. Strong Fabric: Made with durable cotton canvas that can carry books, groceries, or essentials. Comfortable Handles: Wide cotton webbing straps make it easy to carry on the shoulder or by hand. Eco-Friendly &amp; Reusable: A sustainable alternative to plastic bags – washable and long-lasting. Multi-Purpose Use: Great for shopping, work, college, gifting, travel, or casual outings.',
        299.0,
        NULL,
        'PM-0165',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '18x20 Inch Cotton Tote Bag | 150 GSM',
        'custom-18x20-inch-cotton-canvas-tote-bag',
        'Material 100% Pure Cotton Size 18x20 Inch Fabric Details 150 GSM Quality 1 &amp; 2 Color Hand Screen Print - No size Limit Digital Print Heat Transfer DTF - Maximum size 8x5 Inch Key Features: ✅100% Natural Cotton – Eco-friendly, reusable, and biodegradable, making it the perfect alternative to plastic bags. ✅Strong &amp; Durable – Premium stitching and sturdy canvas fabric hold groceries, fruits, vegetables, books, and more with ease. ✅DIY &amp; Customizable – Ideal for screen printing, embroidery, fabric painting, tie-dye, and heat transfer vinyl – perfect for businesses, events, and personal use. ✅Multipurpose Tote – Use as a shopping bag, grocery bag, gift bag, craft project, corporate branding bag, or everyday carry-all. ✅Lightweight &amp; Convenient – Easy to fold, store, and carry anywhere – a must-have eco bag for daily shopping trips.',
        55.2,
        NULL,
        'EC250',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'box-tote-bags'),
        'Personalised Twin Petal Tote Bag',
        'personalised-twin-petal-embroidered-box-tote-bag',
        'The Twin Petal Tote Bag is a stylish and eco-friendly carry bag designed for everyday use. Made from premium canvas with sturdy brown handles, it is strong, lightweight, and reusable. The bag features beautiful floral artwork with pink and green petals, giving it a fresh and elegant look. Perfect for shopping, office, college, or casual outings, this tote adds a touch of nature-inspired charm to your daily style. Features: Fabric: 100% Pure Cotton Canvas (330 GSM) Customisable: Custom name Only Design: Twin Petal Box Tote Bag Closure: Secure Main Zipper Size: 12 x 14 x 5 Inch Eco-Friendly: Durable &amp; Reusable Best For: Shopping | Office | College | Gifting | Everyday Carry ➤ Note:- Charm not Included',
        899.0,
        NULL,
        'EC081',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'large-tote-bags'),
        'Mulberry Classic Women Office Bag',
        'mulberry-classic-women-office-bag',
        'Mulberry Classic Women Office Bag is a large tote bag (18 x 12 x 3 inches) designed for modern working women. With its spacious size, it easily fits your laptop, office files, makeup pouch, and daily essentials. The strong mulberry handles and base add durability and style, making it perfect for office, business meetings, and everyday use. Its sleek and classy design makes it a versatile choice for both professional and casual outfits. Features: Large Size (18 x 12 x 3 inches) - Spacious enough to carry laptop, files, and essentials. Durable Design - Strong mulberry handles and base for long-lasting use. Stylish Look - Classic mulberry and beige combination for a professional touch. Comfortable to Carry - Sturdy double handles for easy shoulder or hand carry. Multi-Purpose Use - Ideal for office, business meetings, shopping, or daily use.',
        999.0,
        NULL,
        'PM-0168',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'large-tote-bags'),
        'Brown Classic Women Office Bag',
        'brown-classic-women-office-bag',
        'Brown Classic Women Office Bag is a large tote bag (18 x 12 x 3 inches) designed for modern working women. With its spacious size, it easily fits your laptop, office files, makeup pouch, and daily essentials. The strong brown handles and base add durability and style, making it perfect for office, business meetings, and everyday use. Its sleek and classy design makes it a versatile choice for both professional and casual outfits. Features: Large Size (18 x 12 x 3 inches) - Spacious enough to carry laptop, files, and essentials. Durable Design - Strong brown handles and base for long-lasting use. Stylish Look - Classic brown and beige combination for a professional touch. Comfortable to Carry - Sturdy double handles for easy shoulder or hand carry. Multi-Purpose Use - Ideal for office, business meetings, shopping, or daily use.',
        999.0,
        NULL,
        'PM-0169',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'large-tote-bags'),
        'Black Classic Women Office Bag',
        'black-classic-women-office-bag',
        'Black Classic Women Office Bag is a large tote bag (18 x 12 x 3 inches) designed for modern working women. With its spacious size, it easily fits your laptop, office files, makeup pouch, and daily essentials. The strong black handles and base add durability and style, making it perfect for office, business meetings, and everyday use. Its sleek and classy design makes it a versatile choice for both professional and casual outfits. Features: Large Size (18 x 12 x 3 inches) - Spacious enough to carry laptop, files, and essentials. Durable Design - Strong black handles and base for long-lasting use. Stylish Look - Classic black and beige combination for a professional touch. Comfortable to Carry - Sturdy double handles for easy shoulder or hand carry. Multi-Purpose Use - Ideal for office, business meetings, shopping, or daily use.',
        999.0,
        NULL,
        'PM-0170',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'medium-tote-bags'),
        'Mulberry Classic Women Tote Bag',
        'mulberry-classic-women-tote-bag',
        'Mulberry Classic Women Tote Bag is a stylish and versatile medium-sized tote bag designed for daily use. Made with a modern two-tone design, it features a beige body with mulberry handles and base for a classy look. With a 16-inch width, 10-inch height, and 3-inch depth, it offers enough space to carry your essentials without being too bulky. The strong double handles provide a comfortable grip, while the neat stitching adds to its durability. Perfect for office, shopping, travel, or casual outings, this tote bag is both practical and fashionable. Features: Medium Size Tote - 16 inch wide, 10 inch high, 3 inch deep Stylish Two-Tone Design - Beige body with mulberry base and handles Durable Stitching - Strong finish for long-lasting use Comfortable Handles - Easy to carry on shoulder or hand Spacious Interior - Perfect for daily essentials Multi-Purpose Use - Ideal for office, shopping, travel, and casual outings',
        849.0,
        NULL,
        'PM-0171',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'medium-tote-bags'),
        'Brown Classic Women Tote Bag',
        'brown-classic-women-tote-bag',
        'Brown Classic Women Tote Bag is a stylish and versatile medium-sized tote bag designed for daily use. Made with a modern two-tone design, it features a beige body with brown handles and base for a classy look. With a 16-inch width, 10-inch height, and 3-inch depth, it offers enough space to carry your essentials without being too bulky. The strong double handles provide a comfortable grip, while the neat stitching adds to its durability. Perfect for office, shopping, travel, or casual outings, this tote bag is both practical and fashionable. Features: Medium Size Tote - 16 inch wide, 10 inch high, 3 inch deep Stylish Two-Tone Design - Beige body with brown base and handles Durable Stitching - Strong finish for long-lasting use Comfortable Handles - Easy to carry on shoulder or hand Spacious Interior - Perfect for daily essentials Multi-Purpose Use - Ideal for office, shopping, travel, and casual outings',
        849.0,
        NULL,
        'PM-0172',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'medium-tote-bags'),
        'Black Classic Women Tote Bag',
        'black-classic-women-tote-bag',
        'Black Classic Women Tote Bag is a stylish and versatile medium-sized tote bag designed for daily use. Made with a modern two-tone design, it features a beige body with black handles and base for a classy look. With a 16-inch width, 10-inch height, and 3-inch depth, it offers enough space to carry your essentials without being too bulky. The strong double handles provide a comfortable grip, while the neat stitching adds to its durability. Perfect for office, shopping, travel, or casual outings, this tote bag is both practical and fashionable. Features: Medium Size Tote - 16 inch wide, 10 inch high, 3 inch deep Stylish Two-Tone Design - Beige body with black base and handles Durable Stitching - Strong finish for long-lasting use Comfortable Handles - Easy to carry on shoulder or hand Spacious Interior - Perfect for daily essentials Multi-Purpose Use - Ideal for office, shopping, travel, and casual outings',
        849.0,
        NULL,
        'PM-0173',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'mini-tote-bags'),
        'Mulberry Classic Women Handbag - Mini',
        'mulberry-classic-women-handbag',
        'Mulberry Classic Women Handbag is a stylish mini bag designed for women who love elegance and simplicity. Made with a soft beige body and bold mulberry base with matching straps, this bag adds a modern touch to any outfit. Its compact size (11 x 8 x 3 inches) makes it perfect for carrying essentials like a phone, wallet, and keys. The sturdy handles with fine stitching give it a classy finish, making it suitable for daily use, office, or casual outings. Features: Mini Size: Compact handbag (11 x 8 x 3 inches) for daily essentials. Stylish Look: Beige body with classic mulberry base and straps. Durable Design: Strong stitching with sturdy handles for long-lasting use. Lightweight &amp; Easy to Carry: Perfect for office, travel, or casual outings. Versatile Use: Matches with both formal and casual outfits.',
        699.0,
        NULL,
        'PM-0174',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'mini-tote-bags'),
        'Brown Classic Women Handbag - Mini',
        'brown-classic-women-handbag',
        'Brown Classic Women Handbag is a stylish mini bag designed for women who love elegance and simplicity. Made with a soft beige body and bold brown base with matching straps, this bag adds a modern touch to any outfit. Its compact size (11 x 8 x 3 inches) makes it perfect for carrying essentials like a phone, wallet, and keys. The sturdy handles with fine stitching give it a classy finish, making it suitable for daily use, office, or casual outings. Features: Mini Size: Compact handbag (11 x 8 x 3 inches) for daily essentials. Stylish Look: Beige body with classic brown base and straps. Durable Design: Strong stitching with sturdy handles for long-lasting use. Lightweight &amp; Easy to Carry: Perfect for office, travel, or casual outings. Versatile Use: Matches with both formal and casual outfits.',
        699.0,
        NULL,
        'PM-0175',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'mini-tote-bags'),
        'Black Classic Women Handbag - Mini',
        'black-classic-women-handbag',
        'Black Classic Women Handbag is a stylish mini bag designed for women who love elegance and simplicity. Made with a soft beige body and bold black base with matching straps, this bag adds a modern touch to any outfit. Its compact size (11 x 8 x 3 inches) makes it perfect for carrying essentials like a phone, wallet, and keys. The sturdy handles with fine stitching give it a classy finish, making it suitable for daily use, office, or casual outings. Features: Mini Size: Compact handbag (11 x 8 x 3 inches) for daily essentials. Stylish Look: Beige body with classic black base and straps. Durable Design: Strong stitching with sturdy handles for long-lasting use. Lightweight &amp; Easy to Carry: Perfect for office, travel, or casual outings. Versatile Use: Matches with both formal and casual outfits.',
        699.0,
        NULL,
        'PM-0176',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'saree-covers'),
        '14x16 Inch Cotton Saree Cover',
        'cotton-saree-cover-with-mesh-window',
        'Big Size Single (14x16 Inch) With Zip Closure For Clothes Bags And Wardrobe Organizer With Transparent Mesh Window, Beige. 𝐅𝐚𝐛𝐫𝐢𝐜 - 𝐂𝐨𝐭𝐭𝐨𝐧 ( 150 𝐆𝐒𝐌) 𝐂𝐨𝐥𝐨𝐫 - 𝐎𝐟𝐟-𝐰𝐡𝐢𝐭𝐞 (𝐁𝐞𝐢𝐠𝐞) 𝐒𝐢𝐳𝐞 - 𝟏𝟒𝐱𝟏𝟔 𝐢𝐧𝐜𝐡 𝐒𝐭𝐢𝐭𝐜𝐡𝐢𝐧𝐠 - 𝐇𝐚𝐧𝐝 𝐒𝐭𝐢𝐭𝐜𝐡𝐞𝐝 This is a handmade product, so the actual measurements may be slightly more than or equal to the specified size. 𝐂𝐚𝐫𝐞: The saree covers are washable. Wash them with mild detergent and cold water. Iron after washing for a neat look.',
        349.0,
        NULL,
        'EC216',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'saree-covers'),
        '14x16 Inch Personalised Cotton Saree Cover',
        'personalised-cotton-saree-cover-with-mesh-window',
        'Big Size Single (14x16 Inch) With Zip Closure For Clothes Bags And Wardrobe Organizer With Transparent Mesh Window, Beige. Product Name - Customizable Saree Cover 𝐏𝐞𝐫𝐬𝐨𝐧𝐚𝐥𝐢𝐬𝐞𝐝 - Name Only Fabric - 100% Pure Cotton (150 GSM) GSM (Grams per Square Meter) - 150 GSM Size (L x W) - 14 × 16 Inches Closure Type - Zipper Special Feature - Mesh Window for Visibility 𝐒𝐭𝐢𝐭𝐜𝐡𝐢𝐧𝐠 - Hand Stitched Usage/Application - Saree Storage, Wardrobe Organizer, Gifting Reusable - Yes, Washable and Reusable 𝐂𝐨𝐥𝐨𝐫 - Off-White (Beige) Country of Origin - Made in India This is a handmade product, so the actual measurements may be slightly more than or equal to the specified size. 𝐂𝐚𝐫𝐞: The saree covers are washable. Wash them with mild detergent and cold water. Iron after washing for a neat look.',
        699.0,
        NULL,
        'EC216-2',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hand-bags' AND s.slug = 'lunch-bags'),
        'Office Lunch Bag',
        'office-lunch-bag',
        'Office Lunch Bag is a stylish and practical choice for carrying meals to work, school, travel, or picnics. Made from high-quality cotton and durable canvas fabric, this lunch bag is eco-friendly, lightweight, and reusable. It comes with a spacious compartment to store your food containers, snacks, fruits, and water bottles easily. The strong handles make it comfortable to carry, while the premium stitching ensures long-lasting use. Perfect for office professionals, students, and anyone who wants a neat and organized way to carry homemade food. This cotton and canvas office lunch bag is not only functional but also trendy, making it a great everyday essential. Features: Made from premium cotton canvas fabric for durability and eco-friendly use Lightweight and reusable lunch bag, easy to carry daily Spacious compartment fits lunch box, snacks, fruits, and water bottle Strong stitched handles for comfortable grip and long-lasting use Stylish and simple design suitable for office, school, college, and travel Eco-conscious choice – replaces single-use plastic or paper bags Easy to clean fabric, perfect for everyday use Compact size yet large enough for full meals and multiple containers Unisex design – perfect for men, women, and kids Ideal for work, travel, picnic, and gifting purposes',
        690.0,
        NULL,
        'EC230',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hand-bags' AND s.slug = 'kids-bags'),
        'Safari Kids Tote Bag',
        'safari-kids-tote-bag-for-girls-and-boys',
        'Safari Kids Tote Bag For Girls and Boys Make your little one''s day brighter with our adorable Kids Custom Canvas Bag ! Featuring a charming design that kids will love, this bag is perfect for carrying books, toys, lunch, or art supplies. Key Features: Material: High-quality, durable canvas with vibrant printed designs. Design: Adorable cartoon characters that appeal to kids of all ages. Size: Perfectly sized for kids’ everyday needs—easy to carry. Customizable: Personalize the design or add your child’s name for that special touch. Eco-Friendly: Made with reusable, sturdy materials, ensuring a sustainable choice. Handle: Soft and comfortable handles for little hands. Bag Size: 9 x 9 Inch Ideal For: School supplies Outings and playdates Art and craft storage Birthday return gifts',
        289.0,
        NULL,
        'EC201',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hand-bags' AND s.slug = 'kids-bags'),
        'Rabbit Kids Tote Bag',
        'rabbit-kids-tote-bag-for-girls-and-boys',
        'Rabbit Kids Tote Bag For Girls and Boys Make your little one''s day brighter with our adorable Kids Custom Canvas Bag ! Featuring a charming design that kids will love, this bag is perfect for carrying books, toys, lunch, or art supplies. Key Features: Material: High-quality, durable canvas with vibrant printed designs. Design: Adorable cartoon characters that appeal to kids of all ages. Size: Perfectly sized for kids’ everyday needs—easy to carry. Customizable: Personalize the design or add your child’s name for that special touch. Eco-Friendly: Made with reusable, sturdy materials, ensuring a sustainable choice. Handle: Soft and comfortable handles for little hands. Bag Size: 9 x 9 Inch Ideal For: School supplies Outings and playdates Art and craft storage Birthday return gifts',
        289.0,
        NULL,
        'EC173',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hand-bags' AND s.slug = 'kids-bags'),
        'Elephant Kids Tote Bag',
        'elephant-kids-tote-bag-for-girls-and-boys',
        'Elephant Kids Tote Bag For Girls and Boys Make your little one''s day brighter with our adorable Kids Custom Canvas Bag ! Featuring a charming design that kids will love, this bag is perfect for carrying books, toys, lunch, or art supplies. Key Features: Material: High-quality, durable canvas with vibrant printed designs. Design: Adorable cartoon characters that appeal to kids of all ages. Size: Perfectly sized for kids’ everyday needs - easy to carry. Customizable: Personalize the design or add your child’s name for that special touch. Eco-Friendly: Made with reusable, sturdy materials, ensuring a sustainable choice. Handle: Soft and comfortable handles for little hands. Bag Size: 9 x 9 Inch Ideal For: School supplies Outings and playdates Art and craft storage Birthday return gifts',
        289.0,
        NULL,
        'EC168',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hand-bags' AND s.slug = 'kids-bags'),
        'Lion Kids Tote Bag',
        'lion-kids-tote-bag-for-girls-and-boys',
        'Lion Kids Tote Bag For Girls and Boys Make your little one''s day brighter with our adorable Kids Custom Canvas Bag ! Featuring a charming design that kids will love, this bag is perfect for carrying books, toys, lunch, or art supplies. Key Features: Material: High-quality, durable canvas with vibrant printed designs. Design: Adorable cartoon characters that appeal to kids of all ages. Size: Perfectly sized for kids’ everyday needs—easy to carry. Customizable: Personalize the design or add your child’s name for that special touch. Eco-Friendly: Made with reusable, sturdy materials, ensuring a sustainable choice. Handle: Soft and comfortable handles for little hands. Bag Size: 9 x 9 Inch Ideal For: School supplies Outings and playdates Art and craft storage Birthday return gifts',
        289.0,
        NULL,
        'EC168-2',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hand-bags' AND s.slug = 'kids-bags'),
        'Moana Kids Tote Bag',
        'moana-kids-tote-bag-for-girls-and-boys',
        'Moana Kids Tote Bag For Girls and Boys Make your little one''s day brighter with our adorable Kids Custom Canvas Bag ! Featuring a charming design that kids will love, this bag is perfect for carrying books, toys, lunch, or art supplies. Key Features: Material: High-quality, durable canvas with vibrant printed designs. Design: Adorable cartoon characters that appeal to kids of all ages. Size: Perfectly sized for kids’ everyday needs—easy to carry. Customizable: Personalize the design or add your child’s name for that special touch. Eco-Friendly: Made with reusable, sturdy materials, ensuring a sustainable choice. Handle: Soft and comfortable handles for little hands. Bag Size: 9 x 9 Inch Ideal For: School supplies Outings and playdates Art and craft storage Birthday return gifts',
        289.0,
        NULL,
        'EC208',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hand-bags' AND s.slug = 'kids-bags'),
        'Barbie Kids Tote Bag',
        'fairy-kids-tote-bag-for-girls-and-boys',
        'Fairy Kids Tote Bag For Girls and Boys Make your little one''s day brighter with our adorable Kids Custom Canvas Bag ! Featuring a charming design that kids will love, this bag is perfect for carrying books, toys, lunch, or art supplies. Key Features: Material: High-quality, durable canvas with vibrant printed designs. Design: Adorable cartoon characters that appeal to kids of all ages. Size: Perfectly sized for kids’ everyday needs—easy to carry. Customizable: Personalize the design or add your child’s name for that special touch. Eco-Friendly: Made with reusable, sturdy materials, ensuring a sustainable choice. Handle: Soft and comfortable handles for little hands. Bag Size: 9 x 9 Inch Ideal For: School supplies Outings and playdates Art and craft storage Birthday return gifts',
        289.0,
        NULL,
        'EC202',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hand-bags' AND s.slug = 'kids-bags'),
        'Fairy Kids Tote Bag',
        'barbie-kids-tote-bag-for-girls-and-boys',
        'Barbie Kids Tote Bag For Girls and Boys Make your little one''s day brighter with our adorable Kids Custom Canvas Bag ! Featuring a charming design that kids will love, this bag is perfect for carrying books, toys, lunch, or art supplies. Key Features: Material: High-quality, durable canvas with vibrant printed designs. Design: Adorable cartoon characters that appeal to kids of all ages. Size: Perfectly sized for kids’ everyday needs—easy to carry. Customizable: Personalize the design or add your child’s name for that special touch. Eco-Friendly: Made with reusable, sturdy materials, ensuring a sustainable choice. Handle: Soft and comfortable handles for little hands. Bag Size: 9 x 9 Inch Ideal For: School supplies Outings and playdates Art and craft storage Birthday return gifts',
        289.0,
        NULL,
        'EC209',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'box-tote-bags'),
        'Butterfly Tote Bag',
        'butterfly-embroidered-box-tote-bag',
        'Carry your essentials in style with our beautiful Butterfly Embroidered Box Tote Bag . Made from sturdy 330 GSM pure cotton, this reusable bag features a secure zipper closure to keep your belongings safe. This is a stylish and practical tote bag featuring beautiful butterfly embroidery. Its boxy shape offers plenty of space for your belongings, making it perfect for daily use or special occasions. Fabric: 100% Pure Cotton Canvas (330 GSM) Design: Floral Butterfly Box Tote Bag Closure: Secure Main Zipper Size: 12 x 14 x 5 Inch Eco-Friendly: Durable &amp; Reusable ➤ Note:- Charm not Included',
        849.0,
        NULL,
        'EC180',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'box-tote-bags'),
        'Pichwai Tote Bag',
        'pichwai-embroidered-box-tote-bag',
        'This Pichwai Embroidered Box Tote Bag is a stylish and functional bag featuring intricate Pichwai embroidery. It has a boxy shape, offering ample space for your essentials, making it perfect for daily use or casual outings. The unique embroidery adds a touch of traditional art to a modern design. Features: ✅ Hand-embroidered floral design – Unique &amp; elegant ✅ Eco-friendly canvas material – Strong &amp; sustainable ✅ Spacious interior – Fits all your essentials ✅ Sturdy handles &amp; zipper closure – Secure &amp; convenient 📏 Size: [12 x 14 x 5 Inch] 👜 Material: 100% Cotton Canvas 🎨 Color: Pastel White Pichwai Embroidery Tote Bag ➤ Note:- Charm not Included',
        899.0,
        NULL,
        'EC252',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hand-bags' AND s.slug = 'kids-bags'),
        'Butterfly Kids Tote Bag',
        'butterfly-kids-tote-bag-for-girls-and-boys',
        'Butterfly Kids Tote Bag For Girls and Boys Make your little one''s day brighter with our adorable Kids Custom Canvas Bag ! Featuring a charming design that kids will love, this bag is perfect for carrying books, toys, lunch, or art supplies. Key Features: Material: High-quality, durable canvas with vibrant printed designs. Design: Adorable cartoon characters that appeal to kids of all ages. Size: Perfectly sized for kids’ everyday needs—easy to carry. Customizable: Personalize the design or add your child’s name for that special touch. Eco-Friendly: Made with reusable, sturdy materials, ensuring a sustainable choice. Handle: Soft and comfortable handles for little hands. Bag Size: 9 x 9 Inch Ideal For: School supplies Outings and playdates Art and craft storage Birthday return gifts',
        289.0,
        NULL,
        'EC209-2',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hand-bags' AND s.slug = 'kids-bags'),
        'Cat Kids Tote Bag',
        'cat-kids-tote-bag-for-girls-and-boys',
        'Cat Kids Tote Bag For Girls and Boys Make your little one''s day brighter with our adorable Kids Custom Canvas Bag ! Featuring a charming design that kids will love, this bag is perfect for carrying books, toys, lunch, or art supplies. Key Features: Material: High-quality, durable canvas with vibrant printed designs. Design: Adorable cartoon characters that appeal to kids of all ages. Size: Perfectly sized for kids’ everyday needs—easy to carry. Customizable: Personalize the design or add your child’s name for that special touch. Eco-Friendly: Made with reusable, sturdy materials, ensuring a sustainable choice. Handle: Soft and comfortable handles for little hands. Bag Size: 9 x 9 Inch Ideal For: School supplies Outings and playdates Art and craft storage Birthday return gifts',
        289.0,
        NULL,
        'EC209-3',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hand-bags' AND s.slug = 'kids-bags'),
        'Monkey Kids Tote Bag',
        'monkey-kids-tote-bag-for-girls-and-boys',
        'Monkey Kids Tote Bag For Girls and Boys Make your little one''s day brighter with our adorable Kids Custom Canvas Bag ! Featuring a charming design that kids will love, this bag is perfect for carrying books, toys, lunch, or art supplies. Key Features: Material: High-quality, durable canvas with vibrant printed designs. Design: Adorable cartoon characters that appeal to kids of all ages. Size: Perfectly sized for kids’ everyday needs—easy to carry. Customizable: Personalize the design or add your child’s name for that special touch. Eco-Friendly: Made with reusable, sturdy materials, ensuring a sustainable choice. Handle: Soft and comfortable handles for little hands. Bag Size: 9 x 9 Inch Ideal For: School supplies Outings and playdates Art and craft storage Birthday return gifts',
        289.0,
        NULL,
        'EC168-3',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hand-bags' AND s.slug = 'kids-bags'),
        'Labubu Kids Tote Bag',
        'labubu-kids-tote-bag-for-girls-and-boys',
        'Labubu Kids Tote Bag For Girls and Boys Make your little one''s day brighter with our adorable Kids Custom Canvas Bag ! Featuring a charming design that kids will love, this bag is perfect for carrying books, toys, lunch, or art supplies. Key Features: Material: High-quality, durable canvas with vibrant printed designs. Design: Adorable cartoon characters that appeal to kids of all ages. Size: Perfectly sized for kids’ everyday needs—easy to carry. Customizable: Personalize the design or add your child’s name for that special touch. Eco-Friendly: Made with reusable, sturdy materials, ensuring a sustainable choice. Handle: Soft and comfortable handles for little hands. Bag Size: 9 x 9 Inch Ideal For: School supplies Outings and playdates Art and craft storage Birthday return gifts',
        289.0,
        NULL,
        'EC202-2',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hand-bags' AND s.slug = 'kids-bags'),
        'Lilo Stitch Kids Tote Bag',
        'lilo-stitch-kids-tote-bag-for-girls-and-boys',
        'Lilo Stitch Kids Tote Bag For Girls and Boys Make your little one''s day brighter with our adorable Kids Custom Canvas Bag ! Featuring a charming design that kids will love, this bag is perfect for carrying books, toys, lunch, or art supplies. Key Features: Material: High-quality, durable canvas with vibrant printed designs. Design: Adorable cartoon characters that appeal to kids of all ages. Size: Perfectly sized for kids’ everyday needs—easy to carry. Customizable: Personalize the design or add your child’s name for that special touch. Eco-Friendly: Made with reusable, sturdy materials, ensuring a sustainable choice. Handle: Soft and comfortable handles for little hands. Bag Size: 9 x 9 Inch Ideal For: School supplies Outings and playdates Art and craft storage Birthday return gifts',
        289.0,
        NULL,
        'EC201-2',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hand-bags' AND s.slug = 'kids-bags'),
        'Shinchain Kids Tote Bag',
        'shinchain-kids-tote-bag-for-girls-and-boys',
        'Shinchain Kids Tote Bag For Girls and Boys Make your little one''s day brighter with our adorable Kids Custom Canvas Bag ! Featuring a charming design that kids will love, this bag is perfect for carrying books, toys, lunch, or art supplies. Key Features: Material: High-quality, durable canvas with vibrant printed designs. Design: Adorable cartoon characters that appeal to kids of all ages. Size: Perfectly sized for kids’ everyday needs—easy to carry. Customizable: Personalize the design or add your child’s name for that special touch. Eco-Friendly: Made with reusable, sturdy materials, ensuring a sustainable choice. Handle: Soft and comfortable handles for little hands. Bag Size: 9 x 9 Inch Ideal For: School supplies Outings and playdates Art and craft storage Birthday return gifts',
        289.0,
        NULL,
        'EC208-2',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hand-bags' AND s.slug = 'kids-bags'),
        'Squirrel Kids Tote Bag',
        'squirrel-kids-tote-bag-for-girls-and-boys',
        'Squirrel Kids Tote Bag For Girls and Boys Make your little one''s day brighter with our adorable Kids Custom Canvas Bag ! Featuring a charming design that kids will love, this bag is perfect for carrying books, toys, lunch, or art supplies. Key Features: Material: High-quality, durable canvas with vibrant printed designs. Design: Adorable cartoon characters that appeal to kids of all ages. Size: Perfectly sized for kids’ everyday needs—easy to carry. Customizable: Personalize the design or add your child’s name for that special touch. Eco-Friendly: Made with reusable, sturdy materials, ensuring a sustainable choice. Handle: Soft and comfortable handles for little hands. Bag Size: 9 x 9 Inch Ideal For: School supplies Outings and playdates Art and craft storage Birthday return gifts',
        289.0,
        NULL,
        'EC168-4',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hand-bags' AND s.slug = 'kids-bags'),
        'Giraffe Kids Tote Bag',
        'giraffe-kids-tote-bag-for-girls-and-boys',
        'Giraffe Kids Tote Bag For Girls and Boys Make your little one''s day brighter with our adorable Kids Custom Canvas Bag ! Featuring a charming design that kids will love, this bag is perfect for carrying books, toys, lunch, or art supplies. Key Features: Material: High-quality, durable canvas with vibrant printed designs. Design: Adorable cartoon characters that appeal to kids of all ages. Size: Perfectly sized for kids’ everyday needs—easy to carry. Customizable: Personalize the design or add your child’s name for that special touch. Eco-Friendly: Made with reusable, sturdy materials, ensuring a sustainable choice. Handle: Soft and comfortable handles for little hands. Bag Size: 9 x 9 Inch Ideal For: School supplies Outings and playdates Art and craft storage Birthday return gifts',
        289.0,
        NULL,
        'EC168-5',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hand-bags' AND s.slug = 'kids-bags'),
        'Shinchan Embroidery Kids Tote Bag',
        'shinchan-embroidery-kids-tote-bag',
        'The ECOCARRY 𝐒𝐡𝐢𝐧𝐜𝐡𝐚𝐧 𝐄𝐦𝐛𝐫𝐨𝐢𝐝𝐞𝐫𝐲 𝐊𝐢𝐝𝐬 𝐓𝐨𝐭𝐞 𝐁𝐚𝐠 is a cute and stylish bag for boys and girls. Made from soft cotton, it has a fun fighter jet design on the front. This bag is perfect for carrying a lunch box, snacks, books, or other small items. It’s great for school, tuition, picnics, or just everyday use. The bag is light, easy to carry, and comfortable, making it a perfect choice for kids to use every day. ✅ 𝐂𝐮𝐭𝐞 𝐒𝐡𝐢𝐧𝐜𝐡𝐚𝐧 𝐃𝐞𝐬𝐢𝐠𝐧 - Fun and playful cartoon embroidery on the front. ✅ 𝐃𝐮𝐫𝐚𝐛𝐥𝐞 𝐂𝐨𝐭𝐭𝐨𝐧 𝐌𝐚𝐭𝐞𝐫𝐢𝐚𝐥 - Made from soft, strong cotton for everyday use. ✅ 𝐏𝐞𝐫𝐟𝐞𝐜𝐭 𝐒𝐢𝐳𝐞 𝐟𝐨𝐫 𝐊𝐢𝐝𝐬 - Ideal for carrying lunch boxes, snacks, and books. ✅ 𝐕𝐞𝐫𝐬𝐚𝐭𝐢𝐥𝐞 𝐔𝐬𝐞 - Great for school, tuition, picnics, and casual outings. ✅ 𝐋𝐢𝐠𝐡𝐭𝐰𝐞𝐢𝐠𝐡𝐭 &amp; 𝐂𝐨𝐦𝐟𝐨𝐫𝐭𝐚𝐛𝐥𝐞 - Easy for kids to carry around with comfortable handles. ✅ 𝐔𝐧𝐢𝐬𝐞𝐱 𝐃𝐞𝐬𝐢𝐠𝐧 - Suitable for both boys and girls. 【 ECOCARRY 𝐒𝐡𝐢𝐧𝐜𝐡𝐚𝐧 𝐄𝐦𝐛𝐫𝐨𝐢𝐝𝐞𝐫𝐲 𝐊𝐢𝐝𝐬 𝐓𝐨𝐭𝐞 𝐁𝐚𝐠 𝐅𝐨𝐫 𝐆𝐢𝐫𝐥𝐬 𝐚𝐧𝐝 𝐁𝐨𝐲𝐬 I Cute Stylish Cartoon Cotton Casual Handbag I Perfect For Lunch Box Bag Picnic Tuition School 】',
        399.0,
        NULL,
        'EC101',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hand-bags' AND s.slug = 'kids-bags'),
        'Dinosaur Embroidery Kids Tote Bag',
        'dinosaur-embroidery-kids-tote-bag',
        'The ECOCARRY 𝐃𝐢𝐧𝐨𝐬𝐚𝐮𝐫 𝐄𝐦𝐛𝐫𝐨𝐢𝐝𝐞𝐫𝐲 𝐊𝐢𝐝𝐬 𝐓𝐨𝐭𝐞 𝐁𝐚𝐠 is a cute and stylish bag for boys and girls. Made from soft cotton, it has a fun fighter jet design on the front. This bag is perfect for carrying a lunch box, snacks, books, or other small items. It’s great for school, tuition, picnics, or just everyday use. The bag is light, easy to carry, and comfortable, making it a perfect choice for kids to use every day. ✅ 𝐂𝐮𝐭𝐞 𝐃𝐢𝐧𝐨𝐬𝐚𝐮𝐫 𝐃𝐞𝐬𝐢𝐠𝐧 - Fun and playful cartoon embroidery on the front. ✅ 𝐃𝐮𝐫𝐚𝐛𝐥𝐞 𝐂𝐨𝐭𝐭𝐨𝐧 𝐌𝐚𝐭𝐞𝐫𝐢𝐚𝐥 - Made from soft, strong cotton for everyday use. ✅ 𝐏𝐞𝐫𝐟𝐞𝐜𝐭 𝐒𝐢𝐳𝐞 𝐟𝐨𝐫 𝐊𝐢𝐝𝐬 - Ideal for carrying lunch boxes, snacks, and books. ✅ 𝐕𝐞𝐫𝐬𝐚𝐭𝐢𝐥𝐞 𝐔𝐬𝐞 - Great for school, tuition, picnics, and casual outings. ✅ 𝐋𝐢𝐠𝐡𝐭𝐰𝐞𝐢𝐠𝐡𝐭 &amp; 𝐂𝐨𝐦𝐟𝐨𝐫𝐭𝐚𝐛𝐥𝐞 - Easy for kids to carry around with comfortable handles. ✅ 𝐔𝐧𝐢𝐬𝐞𝐱 𝐃𝐞𝐬𝐢𝐠𝐧 - Suitable for both boys and girls. 【 ECOCARRY 𝐃𝐢𝐧𝐨𝐬𝐚𝐮𝐫 𝐄𝐦𝐛𝐫𝐨𝐢𝐝𝐞𝐫𝐲 𝐊𝐢𝐝𝐬 𝐓𝐨𝐭𝐞 𝐁𝐚𝐠 𝐅𝐨𝐫 𝐆𝐢𝐫𝐥𝐬 𝐚𝐧𝐝 𝐁𝐨𝐲𝐬 I Cute Stylish Cartoon Cotton Casual Handbag I Perfect For Lunch Box Bag Picnic Tuition School 】',
        399.0,
        NULL,
        'EC090',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hand-bags' AND s.slug = 'kids-bags'),
        'Cherry Embroidery Kids Tote Bag',
        'cherry-embroidery-kids-tote-bag',
        'The ECOCARRY 𝐂𝐡𝐞𝐫𝐫𝐲 𝐄𝐦𝐛𝐫𝐨𝐢𝐝𝐞𝐫𝐲 𝐊𝐢𝐝𝐬 𝐓𝐨𝐭𝐞 𝐁𝐚𝐠 is a cute and stylish bag for boys and girls. Made from soft cotton, it has a fun fighter jet design on the front. This bag is perfect for carrying a lunch box, snacks, books, or other small items. It’s great for school, tuition, picnics, or just everyday use. The bag is light, easy to carry, and comfortable, making it a perfect choice for kids to use every day. ✅ 𝐂𝐮𝐭𝐞 𝐂𝐡𝐞𝐫𝐫𝐲 𝐃𝐞𝐬𝐢𝐠𝐧 - Fun and playful cartoon embroidery on the front. ✅ 𝐃𝐮𝐫𝐚𝐛𝐥𝐞 𝐂𝐨𝐭𝐭𝐨𝐧 𝐌𝐚𝐭𝐞𝐫𝐢𝐚𝐥 - Made from soft, strong cotton for everyday use. ✅ 𝐏𝐞𝐫𝐟𝐞𝐜𝐭 𝐒𝐢𝐳𝐞 𝐟𝐨𝐫 𝐊𝐢𝐝𝐬 - Ideal for carrying lunch boxes, snacks, and books. ✅ 𝐕𝐞𝐫𝐬𝐚𝐭𝐢𝐥𝐞 𝐔𝐬𝐞 - Great for school, tuition, picnics, and casual outings. ✅ 𝐋𝐢𝐠𝐡𝐭𝐰𝐞𝐢𝐠𝐡𝐭 &amp; 𝐂𝐨𝐦𝐟𝐨𝐫𝐭𝐚𝐛𝐥𝐞 - Easy for kids to carry around with comfortable handles. ✅ 𝐔𝐧𝐢𝐬𝐞𝐱 𝐃𝐞𝐬𝐢𝐠𝐧 - Suitable for both boys and girls. 【 ECOCARRY 𝐂𝐡𝐞𝐫𝐫𝐲 𝐄𝐦𝐛𝐫𝐨𝐢𝐝𝐞𝐫𝐲 𝐊𝐢𝐝𝐬 𝐓𝐨𝐭𝐞 𝐁𝐚𝐠 𝐅𝐨𝐫 𝐆𝐢𝐫𝐥𝐬 𝐚𝐧𝐝 𝐁𝐨𝐲𝐬 I Cute Stylish Cartoon Cotton Casual Handbag I Perfect For Lunch Box Bag Picnic Tuition School. 】',
        399.0,
        NULL,
        'EC079',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hand-bags' AND s.slug = 'office-bags'),
        'Office Bag for Men and Women - Beige',
        'office-bag-for-men-and-women',
        'Stylish office bag for men and women. Shop high-quality office bags for ladies, girls, and professionals. Perfect blend of style and practicality. 𝐅𝐚𝐛𝐫𝐢𝐜 - 𝐂𝐨𝐭𝐭𝐨𝐧 𝐂𝐨𝐥𝐨𝐫 - 𝐎𝐟𝐟-𝐰𝐡𝐢𝐭𝐞 (𝐁𝐞𝐢𝐠𝐞) 𝐒𝐢𝐳𝐞 - 𝟏𝟏𝐱𝟏𝟑 𝐢𝐧𝐜𝐡 𝐖𝐞𝐢𝐠𝐡𝐭 - 𝟑𝟑𝟎 𝐆𝐒𝐌 𝐒𝐭𝐢𝐭𝐜𝐡𝐢𝐧𝐠 - 𝐇𝐚𝐧𝐝 𝐒𝐭𝐢𝐭𝐜𝐡𝐞𝐝 This is a handmade product, so the actual measurements may be slightly more than or equal to the specified size. 𝐂𝐚𝐫𝐞: The office bag are washable. Wash them with mild detergent and cold water. Iron after washing for a neat look.',
        999.0,
        NULL,
        'PM-0200',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hand-bags' AND s.slug = 'office-bags'),
        'Office Bag for Men and Women - Navy Blue',
        'office-bag-for-men-and-women-blue',
        'Stylish office bag for men and women. Shop high-quality office bags for ladies, girls, and professionals. Perfect blend of style and practicality. 𝐅𝐚𝐛𝐫𝐢𝐜 - 𝐂𝐨𝐭𝐭𝐨𝐧 𝐂𝐨𝐥𝐨𝐫 - 𝐍𝐚𝐯𝐲 𝐁𝐥𝐮𝐞 𝐒𝐢𝐳𝐞 - 𝟏𝟏𝐱𝟏𝟑 𝐢𝐧𝐜𝐡 𝐖𝐞𝐢𝐠𝐡𝐭 - 𝟑𝟑𝟎 𝐆𝐒𝐌 𝐒𝐭𝐢𝐭𝐜𝐡𝐢𝐧𝐠 - 𝐇𝐚𝐧𝐝 𝐒𝐭𝐢𝐭𝐜𝐡𝐞𝐝 This is a handmade product, so the actual measurements may be slightly more than or equal to the specified size. 𝐂𝐚𝐫𝐞: The office bag are washable. Wash them with mild detergent and cold water. Iron after washing for a neat look.',
        999.0,
        NULL,
        'PM-0201',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'box-tote-bags'),
        'Mother Life Tote Bag',
        'mother-life-embroidered-canvas-tote-bag',
        '𝐌𝐨𝐭𝐡𝐞𝐫 𝐋𝐢𝐟𝐞 𝐄𝐦𝐛𝐫𝐨𝐢𝐝𝐞𝐫𝐞𝐝 𝐂𝐚𝐧𝐯𝐚𝐬 𝐓𝐨𝐭𝐞 𝐁𝐚𝐠 This Mother Life tote bag is perfect for busy moms. Made from strong canvas material, it''s big enough to carry everything you need - snacks, diapers, books, or even your laptop. The words 𝐌𝐨𝐭𝐡𝐞𝐫 𝐋𝐢𝐟𝐞 are beautifully embroidered on the front, showing off your proud mom life in style. With comfortable shoulder straps and a simple, practical design, it’s great for everyday use - whether you''re going to the store, the park, or just out and about. It also makes a thoughtful gift for any mom who does it all. 𝐏𝐫𝐨𝐝𝐮𝐜𝐭 𝐝𝐞𝐭𝐚𝐢𝐥𝐬 Product Dimensions ‏ : ‎ 17 x 6.5 x 16.5 cm Manufacturer ‏ : ‎ Ecocarry Item part number ‏ : ‎ Mother Life Tote Bag Country of Origin ‏ : ‎ India Packer ‏ : ‎ Ecocarry Item Weight ‏ : ‎ 500 g Included Components ‏ : ‎ tote bag Generic Name ‏ : ‎ Embroidered Canvas Tote Bag',
        1699.0,
        NULL,
        'EC013',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'box-tote-bags'),
        'Teacher Life Tote Bag',
        'teacher-life-embroidered-canvas-tote-bag',
        '𝐓𝐞𝐚𝐜𝐡𝐞𝐫 𝐋𝐢𝐟𝐞 𝐄𝐦𝐛𝐫𝐨𝐢𝐝𝐞𝐫𝐞𝐝 𝐂𝐚𝐧𝐯𝐚𝐬 𝐓𝐨𝐭𝐞 𝐁𝐚𝐠 This Teacher Life tote bag is made for amazing teachers. It’s strong, roomy, and perfect for carrying books, papers, supplies, or even a laptop. The words 𝐓𝐞𝐚𝐜𝐡𝐞𝐫 𝐋𝐢𝐟𝐞 are nicely embroidered on the front, showing your pride in what you do. With sturdy shoulder straps and a simple design, it’s great for school, errands, or everyday use. A thoughtful and practical gift for any hardworking teacher. 𝐏𝐫𝐨𝐝𝐮𝐜𝐭 𝐝𝐞𝐭𝐚𝐢𝐥𝐬 Product Dimensions ‏ : ‎ 17 x 6.5 x 16.5 cm Manufacturer ‏ : ‎ Ecocarry Item part number ‏ : ‎ Teacher Life Tote Bag Country of Origin ‏ : ‎ India Packer ‏ : ‎ Ecocarry Item Weight ‏ : ‎ 500 g Included Components ‏ : ‎ tote bag Generic Name ‏ : ‎ Embroidered Canvas Tote Bag',
        1699.0,
        NULL,
        'EC253',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'box-tote-bags'),
        'Green Floral Tote Bag',
        'embroidered-green-floral-tote-bag',
        '𝐆𝐫𝐞𝐞𝐧 𝐅𝐥𝐨𝐫𝐚𝐥 𝐓𝐨𝐭𝐞 𝐁𝐚𝐠 Embroidered Green Floral Tote Bag is a stylish and practical bag with beautiful flower designs stitched on it. It has a strong, boxy shape that looks neat and gives you plenty of space to carry your things. The bag’s handles are sturdy, making it easy to carry. The floral embroidery makes it stand out, adding a fun and stylish touch to your outfit. Whether you''re using it for everyday activities or a special event, it''s a great mix of fashion and function. 𝐏𝐫𝐨𝐝𝐮𝐜𝐭 𝐝𝐞𝐭𝐚𝐢𝐥𝐬 Product Dimensions ‏ : ‎ 12.5 x 10 x 5 inch Manufacturer ‏ : ‎ Ecocarry Item part number ‏ : ‎ Box Tote Bag Country of Origin ‏ : ‎ India Packer ‏ : ‎ Ecocarry Item Weight ‏ : ‎ -- g Included Components ‏ : ‎ tote bag Generic Name ‏ : ‎ Embroidered Canvas Tote Bag',
        999.0,
        NULL,
        'EC232',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'box-tote-bags'),
        'Purple Floral Tote Bag',
        'embroidered-purple-floral-tote-bag',
        '𝐏𝐮𝐫𝐩𝐥𝐞 𝐅𝐥𝐨𝐫𝐚𝐥 𝐓𝐨𝐭𝐞 𝐁𝐚𝐠 Embroidered Purple Floral Tote Bag is a stylish and practical bag with beautiful flower designs stitched on it. It has a strong, boxy shape that looks neat and gives you plenty of space to carry your things. The bag’s handles are sturdy, making it easy to carry. The floral embroidery makes it stand out, adding a fun and stylish touch to your outfit. Whether you''re using it for everyday activities or a special event, it''s a great mix of fashion and function. 𝐏𝐫𝐨𝐝𝐮𝐜𝐭 𝐝𝐞𝐭𝐚𝐢𝐥𝐬 Product Dimensions ‏ : ‎ 12.5 x 10 x 5 inch Manufacturer ‏ : ‎ Ecocarry Item part number ‏ : ‎ Box Tote Bag Country of Origin ‏ : ‎ India Packer ‏ : ‎ Ecocarry Item Weight ‏ : ‎ -- g Included Components ‏ : ‎ tote bag Generic Name ‏ : ‎ Embroidered Canvas Tote Bag',
        999.0,
        NULL,
        'EC210',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'box-tote-bags'),
        'Pink Floral Tote Bag',
        'embroidered-pink-floral-tote-bag',
        '𝐏𝐢𝐧𝐤 𝐅𝐥𝐨𝐫𝐚𝐥 𝐓𝐨𝐭𝐞 𝐁𝐚𝐠 Embroidered Pink Floral Tote Bag is a stylish and practical bag with beautiful flower designs stitched on it. It has a strong, boxy shape that looks neat and gives you plenty of space to carry your things. The bag’s handles are sturdy, making it easy to carry. The floral embroidery makes it stand out, adding a fun and stylish touch to your outfit. Whether you''re using it for everyday activities or a special event, it''s a great mix of fashion and function. 𝐏𝐫𝐨𝐝𝐮𝐜𝐭 𝐝𝐞𝐭𝐚𝐢𝐥𝐬 Product Dimensions ‏ : ‎ 12.5 x 10 x 5 inch Manufacturer ‏ : ‎ Ecocarry Item part number ‏ : ‎ Box Tote Bag Country of Origin ‏ : ‎ India Packer ‏ : ‎ Ecocarry Item Weight ‏ : ‎ -- g Included Components ‏ : ‎ tote bag Generic Name ‏ : ‎ Embroidered Canvas Tote Bag',
        999.0,
        NULL,
        'EC221',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'box-tote-bags'),
        'Evil Eye Tote Bag',
        'embroidered-evil-eye-box-tote-bag',
        '𝐄𝐯𝐢𝐥 𝐄𝐲𝐞 𝐁𝐨𝐱 𝐓𝐨𝐭𝐞 𝐁𝐚𝐠 Carry your essentials with style and protection with the Evil Eye Box Tote Bag . Made from durable materials, it features spacious compartments to hold your daily necessities. The unique box shape offers a structured and modern look, making it perfect for both casual and semi-formal occasions. 𝐏𝐫𝐨𝐝𝐮𝐜𝐭 𝐝𝐞𝐭𝐚𝐢𝐥𝐬 Product Dimensions ‏ : ‎ 12.5 x 10 x 5 inch Manufacturer ‏ : ‎ Ecocarry Item part number ‏ : ‎ Box Tote Bag Country of Origin ‏ : ‎ India Packer ‏ : ‎ Ecocarry Item Weight ‏ : ‎ 120 g Included Components ‏ : ‎ tote bag Generic Name ‏ : ‎ Embroidered Canvas Tote Bag',
        999.0,
        NULL,
        'PM-0207',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hand-bags' AND s.slug = 'kids-bags'),
        'Airplane Embroidery Kids Tote Bag',
        'airplane-embroidery-kids-tote-bag',
        'The ECOCARRY 𝐀𝐢𝐫𝐩𝐥𝐚𝐧𝐞 𝐄𝐦𝐛𝐫𝐨𝐢𝐝𝐞𝐫𝐲 𝐊𝐢𝐝𝐬 𝐓𝐨𝐭𝐞 𝐁𝐚𝐠 is a cute and stylish bag for boys and girls. Made from soft cotton, it has a fun Airplane design on the front. This bag is perfect for carrying a lunch box, snacks, books, or other small items. It’s great for school, tuition, picnics, or just everyday use. The bag is light, easy to carry, and comfortable, making it a perfect choice for kids to use every day. ✅ 𝐂𝐮𝐭𝐞 𝐀𝐢𝐫𝐩𝐥𝐚𝐧𝐞 𝐃𝐞𝐬𝐢𝐠𝐧 - Fun and playful cartoon embroidery on the front. ✅ 𝐃𝐮𝐫𝐚𝐛𝐥𝐞 𝐂𝐨𝐭𝐭𝐨𝐧 𝐌𝐚𝐭𝐞𝐫𝐢𝐚𝐥 - Made from soft, strong cotton for everyday use. ✅ 𝐏𝐞𝐫𝐟𝐞𝐜𝐭 𝐒𝐢𝐳𝐞 𝐟𝐨𝐫 𝐊𝐢𝐝𝐬 - Ideal for carrying lunch boxes, snacks, and books. ✅ 𝐕𝐞𝐫𝐬𝐚𝐭𝐢𝐥𝐞 𝐔𝐬𝐞 - Great for school, tuition, picnics, and casual outings. ✅ 𝐋𝐢𝐠𝐡𝐭𝐰𝐞𝐢𝐠𝐡𝐭 &amp; 𝐂𝐨𝐦𝐟𝐨𝐫𝐭𝐚𝐛𝐥𝐞 - Easy for kids to carry around with comfortable handles. ✅ 𝐔𝐧𝐢𝐬𝐞𝐱 𝐃𝐞𝐬𝐢𝐠𝐧 - Suitable for both boys and girls. 【 ECOCARRY 𝐀𝐢𝐫𝐩𝐥𝐚𝐧𝐞 𝐄𝐦𝐛𝐫𝐨𝐢𝐝𝐞𝐫𝐲 𝐊𝐢𝐝𝐬 𝐓𝐨𝐭𝐞 𝐁𝐚𝐠 𝐅𝐨𝐫 𝐆𝐢𝐫𝐥𝐬 𝐚𝐧𝐝 𝐁𝐨𝐲𝐬 I Cute Stylish Cartoon Cotton Casual Handbag I Perfect For Lunch Box Bag Picnic Tuition School 】',
        399.0,
        NULL,
        'EC113',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hand-bags' AND s.slug = 'kids-bags'),
        'Dog Embroidery Kids Tote Bag',
        'dog-embroidery-kids-tote-bag',
        'The ECOCARRY 𝐃𝐨𝐠 𝐄𝐦𝐛𝐫𝐨𝐢𝐝𝐞𝐫𝐲 𝐊𝐢𝐝𝐬 𝐓𝐨𝐭𝐞 𝐁𝐚𝐠 is a cute and stylish bag for boys and girls. Made from soft cotton, it has a fun fighter jet design on the front. This bag is perfect for carrying a lunch box, snacks, books, or other small items. It’s great for school, tuition, picnics, or just everyday use. The bag is light, easy to carry, and comfortable, making it a perfect choice for kids to use every day. ✅ 𝐂𝐮𝐭𝐞 𝐃𝐨𝐠 𝐃𝐞𝐬𝐢𝐠𝐧 - Fun and playful cartoon embroidery on the front. ✅ 𝐃𝐮𝐫𝐚𝐛𝐥𝐞 𝐂𝐨𝐭𝐭𝐨𝐧 𝐌𝐚𝐭𝐞𝐫𝐢𝐚𝐥 - Made from soft, strong cotton for everyday use. ✅ 𝐏𝐞𝐫𝐟𝐞𝐜𝐭 𝐒𝐢𝐳𝐞 𝐟𝐨𝐫 𝐊𝐢𝐝𝐬 - Ideal for carrying lunch boxes, snacks, and books. ✅ 𝐕𝐞𝐫𝐬𝐚𝐭𝐢𝐥𝐞 𝐔𝐬𝐞 - Great for school, tuition, picnics, and casual outings. ✅ 𝐋𝐢𝐠𝐡𝐭𝐰𝐞𝐢𝐠𝐡𝐭 &amp; 𝐂𝐨𝐦𝐟𝐨𝐫𝐭𝐚𝐛𝐥𝐞 - Easy for kids to carry around with comfortable handles. ✅ 𝐔𝐧𝐢𝐬𝐞𝐱 𝐃𝐞𝐬𝐢𝐠𝐧 - Suitable for both boys and girls. 【 ECOCARRY 𝐃𝐨𝐠 𝐄𝐦𝐛𝐫𝐨𝐢𝐝𝐞𝐫𝐲 𝐊𝐢𝐝𝐬 𝐓𝐨𝐭𝐞 𝐁𝐚𝐠 𝐅𝐨𝐫 𝐆𝐢𝐫𝐥𝐬 𝐚𝐧𝐝 𝐁𝐨𝐲𝐬 I Cute Stylish Cartoon Cotton Casual Handbag I Perfect For Lunch Box Bag Picnic Tuition School 】',
        399.0,
        NULL,
        'EC022',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'hand-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'hand-bags' AND s.slug = 'kids-bags'),
        'Monkey Embroidery Kids Tote Bag',
        'monkey-embroidery-kids-tote-bag',
        'The ECOCARRY 𝐌𝐨𝐧𝐤𝐞𝐲 𝐄𝐦𝐛𝐫𝐨𝐢𝐝𝐞𝐫𝐲 𝐊𝐢𝐝𝐬 𝐓𝐨𝐭𝐞 𝐁𝐚𝐠 is a cute and stylish bag for boys and girls. Made from soft cotton, it has a fun fighter jet design on the front. This bag is perfect for carrying a lunch box, snacks, books, or other small items. It’s great for school, tuition, picnics, or just everyday use. The bag is light, easy to carry, and comfortable, making it a perfect choice for kids to use every day. ✅ 𝐂𝐮𝐭𝐞 𝐌𝐨𝐧𝐤𝐞𝐲 𝐃𝐞𝐬𝐢𝐠𝐧 - Fun and playful cartoon embroidery on the front. ✅ 𝐃𝐮𝐫𝐚𝐛𝐥𝐞 𝐂𝐨𝐭𝐭𝐨𝐧 𝐌𝐚𝐭𝐞𝐫𝐢𝐚𝐥 - Made from soft, strong cotton for everyday use. ✅ 𝐏𝐞𝐫𝐟𝐞𝐜𝐭 𝐒𝐢𝐳𝐞 𝐟𝐨𝐫 𝐊𝐢𝐝𝐬 - Ideal for carrying lunch boxes, snacks, and books. ✅ 𝐕𝐞𝐫𝐬𝐚𝐭𝐢𝐥𝐞 𝐔𝐬𝐞 - Great for school, tuition, picnics, and casual outings. ✅ 𝐋𝐢𝐠𝐡𝐭𝐰𝐞𝐢𝐠𝐡𝐭 &amp; 𝐂𝐨𝐦𝐟𝐨𝐫𝐭𝐚𝐛𝐥𝐞 - Easy for kids to carry around with comfortable handles. ✅ 𝐔𝐧𝐢𝐬𝐞𝐱 𝐃𝐞𝐬𝐢𝐠𝐧 - Suitable for both boys and girls. 【 ECOCARRY 𝐌𝐨𝐧𝐤𝐞𝐲 𝐄𝐦𝐛𝐫𝐨𝐢𝐝𝐞𝐫𝐲 𝐊𝐢𝐝𝐬 𝐓𝐨𝐭𝐞 𝐁𝐚𝐠 𝐅𝐨𝐫 𝐆𝐢𝐫𝐥𝐬 𝐚𝐧𝐝 𝐁𝐨𝐲𝐬 I Cute Stylish Cartoon Cotton Casual Handbag I Perfect For Lunch Box Bag Picnic Tuition School 】',
        399.0,
        NULL,
        'EC022-2',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'box-tote-bags'),
        'Personalised Butterfly Tote Bag',
        'personalised-butterfly-embroidered-box-tote-bag',
        'Carry your essentials in style with our Personalised Butterfly Embroidered Box Tote Bag . Made from thick, durable pure cotton, this bag features a secure zipper closure and a spacious design. Personalise it with a name to create the perfect accessory or a thoughtful gift. Eco-friendly, reusable, and beautifully unique. Fabric: 100% Pure Cotton Canvas (330 GSM) Customisable: Custom name Only Design: Floral Butterfly Box Tote Bag Closure: Secure Main Zipper Size: 12 x 14 x 5 Inch Eco-Friendly: Durable &amp; Reusable ➤ Note:- Charm not Included',
        899.0,
        NULL,
        'EC180-2',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '14x18 Inch Cotton Tote Bag | 150 GSM',
        'custom-14x18-cotton-canvas-tote-bag',
        'Material 100% Pure Cotton Size 14x18 Inch Fabric Details 150 GSM Quality 1 &amp; 2 Color Hand Screen Print - No size Limit Digital Print Heat Transfer DTF - Maximum size 8x5 Inch Key Features: ✅100% Natural Cotton – Eco-friendly, reusable, and biodegradable, making it the perfect alternative to plastic bags. ✅Strong &amp; Durable – Premium stitching and sturdy canvas fabric hold groceries, fruits, vegetables, books, and more with ease. ✅DIY &amp; Customizable – Ideal for screen printing, embroidery, fabric painting, tie-dye, and heat transfer vinyl – perfect for businesses, events, and personal use. ✅Multipurpose Tote – Use as a shopping bag, grocery bag, gift bag, craft project, corporate branding bag, or everyday carry-all. ✅Lightweight &amp; Convenient – Easy to fold, store, and carry anywhere – a must-have eco bag for daily shopping trips.',
        46.1,
        NULL,
        'EC206',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '12x10 Inch Cotton  Tote Bag | 150 GSM',
        'custom-12x10-cotton-canvas-tote-bag',
        'Material 100% Pure Cotton Size 12x10 Inch Fabric Details 150 GSM Quality 1 &amp; 2 Color Hand Screen Print - No size Limit Digital Print Heat Transfer DTF - Maximum size 4x3 Inch Key Features: ✅100% Natural Cotton – Eco-friendly, reusable, and biodegradable, making it the perfect alternative to plastic bags. ✅Strong &amp; Durable – Premium stitching and sturdy canvas fabric hold groceries, fruits, vegetables, books, and more with ease. ✅DIY &amp; Customizable – Ideal for screen printing, embroidery, fabric painting, tie-dye, and heat transfer vinyl – perfect for businesses, events, and personal use. ✅Multipurpose Tote – Use as a shopping bag, grocery bag, gift bag, craft project, corporate branding bag, or everyday carry-all. ✅Lightweight &amp; Convenient – Easy to fold, store, and carry anywhere – a must-have eco bag for daily shopping trips.',
        31.8,
        NULL,
        'EC175',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'tote-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'tote-bags' AND s.slug = 'everyday-tote-bags'),
        '14x12  Inch Cotton Tote Bag | 150 GSM',
        'custom-14x12-cotton-canvas-tote-bag',
        'Material 100% Pure Cotton Size 14x12 Inch Fabric Details 150 GSM Quality 1 &amp; 2 Color Hand Screen Print - No size Limit Digital Print Heat Transfer DTF - Maximum size 7x4.5 Inch Key Features: ✅100% Natural Cotton – Eco-friendly, reusable, and biodegradable, making it the perfect alternative to plastic bags. ✅Strong &amp; Durable – Premium stitching and sturdy canvas fabric hold groceries, fruits, vegetables, books, and more with ease. ✅DIY &amp; Customizable – Ideal for screen printing, embroidery, fabric painting, tie-dye, and heat transfer vinyl – perfect for businesses, events, and personal use. ✅Multipurpose Tote – Use as a shopping bag, grocery bag, gift bag, craft project, corporate branding bag, or everyday carry-all. ✅Lightweight &amp; Convenient – Easy to fold, store, and carry anywhere – a must-have eco bag for daily shopping trips.',
        38.3,
        NULL,
        'EC174',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'saree-covers'),
        '16x14 Inch Cotton Saree Cover (Plain)',
        'cotton-saree-cover-with-zip',
        'Big Size Single (16x14 Inch) With Zip Closure For Clothes Bags And Wardrobe Organizer With Transparent Mesh Window, Beige. 𝐅𝐚𝐛𝐫𝐢𝐜 - 𝐂𝐨𝐭𝐭𝐨𝐧 ( 150 𝐆𝐒𝐌) 𝐂𝐨𝐥𝐨𝐫 - 𝐎𝐟𝐟-𝐰𝐡𝐢𝐭𝐞 (𝐁𝐞𝐢𝐠𝐞) 𝐒𝐢𝐳𝐞 - 𝟏𝟔𝐱𝟏𝟒 𝐢𝐧𝐜𝐡 𝐒𝐭𝐢𝐭𝐜𝐡𝐢𝐧𝐠 - 𝐇𝐚𝐧𝐝 𝐒𝐭𝐢𝐭𝐜𝐡𝐞𝐝 This is a handmade product, so the actual measurements may be slightly more than or equal to the specified size. 𝐂𝐚𝐫𝐞: The saree covers are washable. Wash them with mild detergent and cold water. Iron after washing for a neat look.',
        399.0,
        NULL,
        'EC217-2',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.products
    (category_id, subcategory_id, name, slug, description, price, compare_at_price, sku, is_active)
VALUES
    (
        (SELECT id FROM public.categories WHERE slug = 'packaging-bags'),
        (SELECT s.id FROM public.subcategories s JOIN public.categories c ON c.id = s.category_id WHERE c.slug = 'packaging-bags' AND s.slug = 'saree-covers'),
        '16x14 Inch Cotton Saree Cover With Name',
        'personalised-cotton-saree-cover-with-zip',
        'Big Size Single (16x14 Inch) With Zip Closure For Clothes Bags And Wardrobe Organizer With Transparent Mesh Window, Beige. Product Name - Customizable Saree Cover 𝐏𝐞𝐫𝐬𝐨𝐧𝐚𝐥𝐢𝐬𝐞𝐝 - Name Only Fabric - 100% Pure Cotton (150 GSM) GSM (Grams per Square Meter) - 150 GSM Size (L x W) - 16 × 14 Inches Closure Type - Zipper Special Feature - Mesh Window for Visibility 𝐒𝐭𝐢𝐭𝐜𝐡𝐢𝐧𝐠 - Hand Stitched Usage/Application - Saree Storage, Wardrobe Organizer, Gifting Reusable - Yes, Washable and Reusable 𝐂𝐨𝐥𝐨𝐫 - Off-White (Beige) Country of Origin - Made in India This is a handmade product, so the actual measurements may be slightly more than or equal to the specified size. 𝐂𝐚𝐫𝐞: The saree covers are washable. Wash them with mild detergent and cold water. Iron after washing for a neat look.',
        699.0,
        NULL,
        'EC217-3',
        true
    )
ON CONFLICT (slug)
DO UPDATE SET
    category_id = EXCLUDED.category_id,
    subcategory_id = EXCLUDED.subcategory_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    sku = EXCLUDED.sku,
    is_active = EXCLUDED.is_active,
    updated_at = now();

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'SK118'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC277'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC276'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC274'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0005'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0006'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0007'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'SK117'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'SK116'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'SK115'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0011'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0012'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC211'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC213'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC212'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0016'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0017'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC240'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC239'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC241'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0021'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0022'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC046'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC130'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC068'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC057'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC214'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC057-2'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC248'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC246'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC247'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0032'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0033'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0034'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0035'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0036'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0037'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0038'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0039'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0040'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0041'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0042'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0043'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'SK114'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'SK113'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'SK112'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'SK101'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'SK102'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0049'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0050'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0051'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0052'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0053'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0054'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC290'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC291'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0057'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0058'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'CT01'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC264'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC266'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC265'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0063'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0064'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0065'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0066'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0067'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0068'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0069'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0070'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0071'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0072'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0073'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC085'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC129'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0076'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0077'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC014'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC006'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC015'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC012'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC011'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC008'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC010'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC060'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC059'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'SK104'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC062'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC063'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC064'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC132'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC066'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC067'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC065'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC069'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC283'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC284'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC285'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC286'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC287'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC288'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC289'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'SK105'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'SK106'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'SK107'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'SK108'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'SK109'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'SK110'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'SK111'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC281'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC282'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC280'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC279'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC196'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC262'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC261'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC259'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC260'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC043'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC189'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC009'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC007'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC005'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0124'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC256'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC258'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC257'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC176'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC197'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC207'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC200'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC205'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC204'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC004'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC195'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC194'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC193'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC190'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC191'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC192'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC198'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC245'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC217'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC148'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC147'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC145'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC042'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC044'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0149'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0150'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0151'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0152'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC082'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC080'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0155'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0156'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0157'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0158'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0159'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0160'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0161'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0162'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0163'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0164'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0165'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC250'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC081'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0168'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0169'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0170'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0171'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0172'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0173'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0174'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0175'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0176'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC216'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC216-2'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC230'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC201'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC173'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC168'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC168-2'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC208'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC202'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC209'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC180'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC252'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC209-2'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC209-3'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC168-3'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC202-2'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC201-2'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC208-2'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC168-4'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC168-5'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC101'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC090'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC079'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0200'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0201'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC013'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC253'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC232'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC210'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC221'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'PM-0207'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC113'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC022'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC022-2'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC180-2'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC206'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC175'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC174'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC217-2'
ON CONFLICT (product_id)
DO NOTHING;

INSERT INTO public.inventory
    (product_id, quantity, reserved_quantity, low_stock_threshold)
SELECT id, 0, 0, 10
FROM public.products WHERE sku = 'EC217-3'
ON CONFLICT (product_id)
DO NOTHING;

COMMIT;
