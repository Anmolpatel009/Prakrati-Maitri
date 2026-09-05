-- ============================================================
-- STOREFRONT MEDIA CMS
-- ============================================================

create table if not exists public.storefront_media (
  id uuid primary key default gen_random_uuid(),

  media_type text not null
    check (media_type in ('image', 'video')),

  title text not null,

  file_url text not null,

  thumbnail_url text,

  alt_text text,

  mime_type text,

  file_size bigint,

  is_active boolean not null default true,

  created_at timestamptz not null default now(),

  updated_at timestamptz not null default now()
);


create index if not exists storefront_media_active_idx
  on public.storefront_media (is_active, created_at desc);


-- ============================================================
-- HOMEPAGE SECTIONS
-- ============================================================

create table if not exists public.homepage_sections (
  id uuid primary key default gen_random_uuid(),

  section_key text not null unique,

  section_type text not null,

  eyebrow text,

  title text,

  description text,

  cta_text text,

  cta_url text,

  media_id uuid references public.storefront_media(id)
    on delete set null,

  display_order integer not null default 0,

  is_active boolean not null default true,

  created_at timestamptz not null default now(),

  updated_at timestamptz not null default now()
);


create index if not exists homepage_sections_order_idx
  on public.homepage_sections (is_active, display_order);


-- ============================================================
-- UPDATED_AT TRIGGER
-- ============================================================

create or replace function public.update_storefront_cms_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;


drop trigger if exists storefront_media_updated_at
  on public.storefront_media;

create trigger storefront_media_updated_at
before update on public.storefront_media
for each row
execute function public.update_storefront_cms_updated_at();


drop trigger if exists homepage_sections_updated_at
  on public.homepage_sections;

create trigger homepage_sections_updated_at
before update on public.homepage_sections
for each row
execute function public.update_storefront_cms_updated_at();


-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

alter table public.storefront_media enable row level security;

alter table public.homepage_sections enable row level security;


-- Public storefront can only read active media.

create policy "Public can view active storefront media"
on public.storefront_media
for select
using (is_active = true);


-- Public storefront can only read active homepage sections.

create policy "Public can view active homepage sections"
on public.homepage_sections
for select
using (is_active = true);


-- Admin media permissions.

create policy "Admins can insert storefront media"
on public.storefront_media
for insert
to authenticated
with check (public.is_admin());


create policy "Admins can update storefront media"
on public.storefront_media
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());


create policy "Admins can delete storefront media"
on public.storefront_media
for delete
to authenticated
using (public.is_admin());


-- Admin homepage section permissions.

create policy "Admins can insert homepage sections"
on public.homepage_sections
for insert
to authenticated
with check (public.is_admin());


create policy "Admins can update homepage sections"
on public.homepage_sections
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());


create policy "Admins can delete homepage sections"
on public.homepage_sections
for delete
to authenticated
using (public.is_admin());


-- ============================================================
-- STORAGE BUCKET
-- ============================================================

insert into storage.buckets (
  id,
  name,
  public
)
values (
  'storefront-media',
  'storefront-media',
  true
)
on conflict (id) do nothing;


-- Public can read storefront media.

create policy "Public can view storefront media files"
on storage.objects
for select
using (
  bucket_id = 'storefront-media'
);


-- Admins can upload.

create policy "Admins can upload storefront media files"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'storefront-media'
  and public.is_admin()
);


-- Admins can replace/update.

create policy "Admins can update storefront media files"
on storage.objects
for update
to authenticated
using (
  bucket_id = 'storefront-media'
  and public.is_admin()
)
with check (
  bucket_id = 'storefront-media'
  and public.is_admin()
);


-- Admins can delete.

create policy "Admins can delete storefront media files"
on storage.objects
for delete
to authenticated
using (
  bucket_id = 'storefront-media'
  and public.is_admin()
);


-- ============================================================
-- INITIAL HOMEPAGE SECTION DEFINITIONS
-- ============================================================

insert into public.homepage_sections (
  section_key,
  section_type,
  eyebrow,
  title,
  description,
  cta_text,
  cta_url,
  display_order
)
values

(
  'hero',
  'hero',
  'ECO-FRIENDLY COLLECTION',
  'Thoughtful products. Meaningful choices.',
  'Sustainable bags designed for everyday life, gifting, celebrations and businesses.',
  'Explore Collection',
  '/shop?category=new',
  0
),

(
  'featured_collection',
  'collection',
  'OUR COLLECTION',
  'Made for every occasion',
  'Thoughtfully designed bags for everyday use, gifting, packaging and bulk orders.',
  'View More',
  '/shop?category=new',
  1
),

(
  'purpose_banner',
  'banner',
  'MADE WITH PURPOSE',
  'Carry something that means more.',
  'Eco-friendly choices that bring beauty, usefulness and purpose together.',
  'Shop Collection',
  '/shop',
  2
),

(
  'master_categories',
  'categories',
  'EXPLORE',
  'Shop by Category',
  'Find the right bag for every purpose.',
  null,
  null,
  3
),

(
  'gifting_banner',
  'banner',
  'CELEBRATE SUSTAINABLY',
  'Gifts that make moments memorable.',
  'Discover thoughtful bags for celebrations, gifting and special occasions.',
  'Explore Collection',
  '/shop?event=raksha-bandhan',
  4
),

(
  'most_loved',
  'product_collection',
  'CUSTOMER FAVOURITES',
  'Most Loved Products',
  'Some of the products our customers keep coming back for.',
  null,
  null,
  5
),

(
  'advertising_video',
  'video',
  'OUR STORY',
  'See what Prakriti Maitri stands for.',
  null,
  null,
  null,
  6
),

(
  'story_banner',
  'story',
  null,
  null,
  null,
  null,
  null,
  7
)

on conflict (section_key) do nothing;
