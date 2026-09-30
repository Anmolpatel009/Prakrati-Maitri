alter table public.bulk_order_enquiries
  add column if not exists reference_image_path text;

insert into storage.buckets (id, name, public)
values (
  'bulk-order-references',
  'bulk-order-references',
  false
)
on conflict (id) do update
set public = false;

drop policy if exists "Admins can view bulk order reference images"
on storage.objects;

create policy "Admins can view bulk order reference images"
on storage.objects
for select
to authenticated
using (
  bucket_id = 'bulk-order-references'
  and public.is_admin()
);
