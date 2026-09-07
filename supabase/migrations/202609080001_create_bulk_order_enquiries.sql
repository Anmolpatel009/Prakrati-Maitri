create table if not exists public.bulk_order_enquiries (
  id uuid primary key default gen_random_uuid(),

  name text not null,
  mobile text not null,
  email text,

  business_name text,

  category_id uuid references public.categories(id) on delete set null,
  product_id uuid references public.products(id) on delete set null,

  quantity integer not null check (quantity > 0),

  purpose text not null,
  message text,

  status text not null default 'new'
    check (
      status in (
        'new',
        'contacted',
        'in_discussion',
        'converted',
        'closed'
      )
    ),

  admin_notes text,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists bulk_order_enquiries_status_idx
  on public.bulk_order_enquiries(status);

create index if not exists bulk_order_enquiries_created_at_idx
  on public.bulk_order_enquiries(created_at desc);

alter table public.bulk_order_enquiries enable row level security;

drop policy if exists "Public can submit bulk order enquiries"
  on public.bulk_order_enquiries;

create policy "Public can submit bulk order enquiries"
on public.bulk_order_enquiries
for insert
to anon, authenticated
with check (true);

drop policy if exists "Admins can view bulk order enquiries"
  on public.bulk_order_enquiries;

create policy "Admins can view bulk order enquiries"
on public.bulk_order_enquiries
for select
to authenticated
using (public.is_admin());

drop policy if exists "Admins can update bulk order enquiries"
  on public.bulk_order_enquiries;

create policy "Admins can update bulk order enquiries"
on public.bulk_order_enquiries
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

create or replace function public.set_bulk_order_enquiry_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists set_bulk_order_enquiry_updated_at
  on public.bulk_order_enquiries;

create trigger set_bulk_order_enquiry_updated_at
before update on public.bulk_order_enquiries
for each row
execute function public.set_bulk_order_enquiry_updated_at();
