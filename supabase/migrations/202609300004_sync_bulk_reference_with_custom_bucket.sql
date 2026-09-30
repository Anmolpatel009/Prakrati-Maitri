-- Keep the public bulk enquiry form insert path
-- synchronized with Production.
drop policy if exists "Public can submit bulk order enquiries"
on public.bulk_order_enquiries;

create policy "Public can submit bulk order enquiries"
on public.bulk_order_enquiries
for insert
to anon, authenticated
with check (true);

-- Reuse the existing Custom Bag storage bucket, but isolate
-- Bulk Enquiry objects under a separate path prefix.
drop policy if exists "Public can upload bulk order references"
on storage.objects;

create policy "Public can upload bulk order references"
on storage.objects
for insert
to anon, authenticated
with check (
  bucket_id = 'custom-bag-references'
  and name like 'bulk-orders/%'
);
