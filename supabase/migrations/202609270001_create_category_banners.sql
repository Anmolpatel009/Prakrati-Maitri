create table if not exists public.category_banners (
  id uuid primary key default gen_random_uuid(),

  category_id uuid not null
    references public.categories(id)
    on delete cascade,

  image_url text not null,
  alt_text text,
  is_active boolean not null default true,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint category_banners_category_unique
    unique (category_id)
);

create index if not exists category_banners_active_category_idx
  on public.category_banners (is_active, category_id);

alter table public.category_banners enable row level security;

drop policy if exists "Public can view active category banners"
on public.category_banners;

create policy "Public can view active category banners"
on public.category_banners
for select
to anon, authenticated
using (is_active = true);

drop policy if exists "Admins can manage category banners"
on public.category_banners;

create policy "Admins can manage category banners"
on public.category_banners
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());
