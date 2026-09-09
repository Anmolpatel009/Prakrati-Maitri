create table if not exists public.collection_banners (
  id uuid primary key default gen_random_uuid(),
  slot integer not null,
  image_url text not null,
  alt_text text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint collection_banners_slot_check
    check (slot between 1 and 4),

  constraint collection_banners_slot_unique
    unique (slot)
);

create index if not exists collection_banners_active_slot_idx
  on public.collection_banners (is_active, slot);

alter table public.collection_banners enable row level security;

create policy "Public can view active collection banners"
on public.collection_banners
for select
to anon, authenticated
using (is_active = true);

create policy "Admins can manage collection banners"
on public.collection_banners
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());