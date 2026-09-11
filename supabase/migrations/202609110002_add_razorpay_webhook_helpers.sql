begin;

create or replace function public.fail_online_order_from_webhook(
  p_order_id uuid,
  p_payment_id text default null,
  p_reason text default null
)
returns void
language plpgsql
security definer
set search_path = public
as $function$
declare
  v_status text;
  v_payment_status text;
  v_payment_method text;
  v_item record;
begin
  select
    status,
    payment_status,
    payment_method
  into
    v_status,
    v_payment_status,
    v_payment_method
  from public.orders
  where id = p_order_id
  for update;

  if not found then
    raise exception 'Order not found.';
  end if;

  if v_payment_method <> 'online' then
    raise exception 'Order is not an online payment order.';
  end if;

  if v_payment_status = 'paid' then
    return;
  end if;

  if v_status = 'cancelled' then
    return;
  end if;

  for v_item in
    select product_id, quantity
    from public.order_items
    where order_id = p_order_id
  loop
    update public.inventory
    set
      reserved_quantity = greatest(
        0,
        reserved_quantity - v_item.quantity
      ),
      updated_at = now()
    where product_id = v_item.product_id;
  end loop;

  update public.orders
  set
    status = 'cancelled',
    payment_status = 'failed',
    payment_id = coalesce(p_payment_id, payment_id),
    payment_failure_reason = nullif(trim(p_reason), ''),
    updated_at = now()
  where id = p_order_id;
end;
$function$;

revoke all on function public.fail_online_order_from_webhook(
  uuid,
  text,
  text
) from public;

commit;
