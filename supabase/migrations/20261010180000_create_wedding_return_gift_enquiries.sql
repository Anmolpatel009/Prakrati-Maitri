create table if not exists public.wedding_return_gift_enquiries (
  id uuid primary key default gen_random_uuid(),
  bride_name text not null check (char_length(btrim(bride_name)) between 1 and 24),
  groom_name text not null check (char_length(btrim(groom_name)) between 1 and 24),
  wedding_date date,
  guest_range text not null check (guest_range in ('50–100', '100–300', '300–700', '700+')),
  gift_choice text not null check (gift_choice in (
    'Jute hamper bag',
    'Potli bag',
    'Saree cover',
    'Printed jute tote',
    'Help me choose'
  )),
  status text not null default 'new' check (status in ('new', 'contacted', 'in_discussion', 'converted', 'closed')),
  admin_notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists wedding_return_gift_enquiries_created_at_idx
  on public.wedding_return_gift_enquiries (created_at desc);
create index if not exists wedding_return_gift_enquiries_status_idx
  on public.wedding_return_gift_enquiries (status);

alter table public.wedding_return_gift_enquiries enable row level security;

drop policy if exists "Public can submit wedding return gift enquiries"
  on public.wedding_return_gift_enquiries;
create policy "Public can submit wedding return gift enquiries"
  on public.wedding_return_gift_enquiries
  for insert to anon, authenticated
  with check (status = 'new' and admin_notes is null);

drop policy if exists "Admins can view wedding return gift enquiries"
  on public.wedding_return_gift_enquiries;
create policy "Admins can view wedding return gift enquiries"
  on public.wedding_return_gift_enquiries
  for select to authenticated
  using (public.is_admin());

drop policy if exists "Admins can update wedding return gift enquiries"
  on public.wedding_return_gift_enquiries;
create policy "Admins can update wedding return gift enquiries"
  on public.wedding_return_gift_enquiries
  for update to authenticated
  using (public.is_admin())
  with check (public.is_admin());

grant insert on public.wedding_return_gift_enquiries to anon, authenticated;
grant select, update on public.wedding_return_gift_enquiries to authenticated;

create or replace function public.set_wedding_return_gift_enquiry_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists set_wedding_return_gift_enquiry_updated_at
  on public.wedding_return_gift_enquiries;
create trigger set_wedding_return_gift_enquiry_updated_at
  before update on public.wedding_return_gift_enquiries
  for each row execute function public.set_wedding_return_gift_enquiry_updated_at();