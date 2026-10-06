alter table public.bulk_order_enquiries
  add column if not exists bag_size text,
  add column if not exists delivery_pincode varchar(6),
  add column if not exists delivery_timeline text;

alter table public.bulk_order_enquiries
  drop constraint if exists bulk_order_enquiries_delivery_timeline_check;

alter table public.bulk_order_enquiries
  add constraint bulk_order_enquiries_delivery_timeline_check
  check (
    delivery_timeline is null
    or delivery_timeline in (
      'urgent',
      'within_7_days',
      'within_15_days',
      'flexible'
    )
  );
