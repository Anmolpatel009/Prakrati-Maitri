create table if not exists public.storefront_nav_cards (
  id uuid primary key default gen_random_uuid(),

  card_type text not null
    check (card_type in ('category', 'subcategory', 'product', 'custom')),

  category_id uuid references public.categories(id) on delete cascade,
  subcategory_id uuid references public.subcategories(id) on delete cascade,
  product_id uuid references public.products(id) on delete cascade,

  title text not null,
  image_url text,
  href text,

  is_active boolean not null default true,
  display_order integer not null default 0,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint storefront_nav_cards_source_check
    check (
      (card_type = 'category' and category_id is not null and subcategory_id is null and product_id is null)
      or
      (card_type = 'subcategory' and subcategory_id is not null and category_id is null and product_id is null)
      or
      (card_type = 'product' and product_id is not null and category_id is null and subcategory_id is null)
      or
      (card_type = 'custom' and category_id is null and subcategory_id is null and product_id is null)
    )
);

create index if not exists storefront_nav_cards_order_idx
  on public.storefront_nav_cards (is_active, display_order);

create index if not exists storefront_nav_cards_category_idx
  on public.storefront_nav_cards (category_id);

create index if not exists storefront_nav_cards_subcategory_idx
  on public.storefront_nav_cards (subcategory_id);

create index if not exists storefront_nav_cards_product_idx
  on public.storefront_nav_cards (product_id);

alter table public.storefront_nav_cards enable row level security;

drop policy if exists "Public can view active storefront nav cards"
  on public.storefront_nav_cards;

create policy "Public can view active storefront nav cards"
  on public.storefront_nav_cards
  for select
  using (is_active = true);
