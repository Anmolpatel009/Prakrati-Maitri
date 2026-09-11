begin;

alter table public.orders
  add column if not exists razorpay_order_id text,
  add column if not exists payment_failure_reason text;

create unique index if not exists orders_razorpay_order_id_key
  on public.orders (razorpay_order_id)
  where razorpay_order_id is not null;

create table if not exists public.razorpay_webhook_events (
  event_id text primary key,
  event_type text not null,
  processed_at timestamptz not null default now()
);

create or replace function public.create_order_with_payment(
  p_items jsonb,
  p_shipping jsonb,
  p_payment_method text
)
returns uuid
language plpgsql
security definer
set search_path = public
as $function$
declare
  v_order_id uuid;
  v_user_id uuid;

  v_subtotal numeric := 0;
  v_shipping_fee numeric := 0;
  v_total numeric := 0;

  v_item jsonb;
  v_product_id uuid;
  v_quantity integer;

  v_product_name text;
  v_product_sku text;
  v_price numeric;
  v_stock integer;
  v_line_total numeric;

  v_order_status text;
  v_payment_status text;
begin
  v_user_id := auth.uid();

  if v_user_id is null then
    raise exception 'You must be logged in.';
  end if;

  if p_payment_method is null
     or p_payment_method not in ('online', 'cod') then
    raise exception 'Invalid payment method. Use online or cod.';
  end if;

  if p_items is null
     or jsonb_array_length(p_items) = 0 then
    raise exception 'Cart is empty.';
  end if;

  if p_payment_method = 'cod' then
    v_order_status := 'confirmed';
    v_payment_status := 'cod_pending';
  else
    v_order_status := 'pending';
    v_payment_status := 'pending';
  end if;

  /*
    Server-authoritative subtotal + inventory reservation.
  */
  for v_item in
    select *
    from jsonb_array_elements(p_items)
  loop
    v_product_id := (v_item->>'productId')::uuid;
    v_quantity := (v_item->>'quantity')::integer;

    if v_quantity <= 0 then
      raise exception 'Invalid quantity.';
    end if;

    select
      p.name,
      p.sku,
      p.price,
      i.quantity - i.reserved_quantity
    into
      v_product_name,
      v_product_sku,
      v_price,
      v_stock
    from products p
    join inventory i
      on i.product_id = p.id
    where p.id = v_product_id
      and p.is_active = true
    for update of i;

    if not found then
      raise exception 'Product is unavailable.';
    end if;

    if v_quantity > v_stock then
      raise exception 'Not enough stock for %.', v_product_name;
    end if;

    v_line_total := v_price * v_quantity;
    v_subtotal := v_subtotal + v_line_total;
  end loop;

  /*
    Shipping rule:
      subtotal < 999  -> ₹80
      subtotal >= 999 -> FREE
  */
  if v_subtotal >= 999 then
    v_shipping_fee := 0;
  else
    v_shipping_fee := 80;
  end if;

  v_total := v_subtotal + v_shipping_fee;

  insert into orders (
    user_id,
    status,
    payment_method,
    payment_status,
    payment_id,
    subtotal,
    shipping_fee,
    total,
    shipping_first_name,
    shipping_last_name,
    shipping_phone,
    shipping_address,
    shipping_city,
    shipping_state,
    shipping_country,
    shipping_postal_code
  )
  values (
    v_user_id,
    v_order_status,
    p_payment_method,
    v_payment_status,
    null,
    v_subtotal,
    v_shipping_fee,
    v_total,
    p_shipping->>'firstName',
    p_shipping->>'lastName',
    p_shipping->>'phone',
    p_shipping->>'address',
    p_shipping->>'city',
    p_shipping->>'state',
    p_shipping->>'country',
    p_shipping->>'postalCode'
  )
  returning id into v_order_id;

  /*
    Snapshot order items and reserve inventory.
  */
  for v_item in
    select *
    from jsonb_array_elements(p_items)
  loop
    v_product_id := (v_item->>'productId')::uuid;
    v_quantity := (v_item->>'quantity')::integer;

    select
      p.name,
      p.sku,
      p.price
    into
      v_product_name,
      v_product_sku,
      v_price
    from products p
    where p.id = v_product_id
      and p.is_active = true;

    if not found then
      raise exception 'Product is unavailable.';
    end if;

    v_line_total := v_price * v_quantity;

    insert into order_items (
      order_id,
      product_id,
      product_name,
      product_sku,
      quantity,
      unit_price,
      line_total
    )
    values (
      v_order_id,
      v_product_id,
      v_product_name,
      v_product_sku,
      v_quantity,
      v_price,
      v_line_total
    );

    update inventory
    set
      reserved_quantity = reserved_quantity + v_quantity,
      updated_at = now()
    where product_id = v_product_id;
  end loop;

  return v_order_id;
end;
$function$;


create or replace function public.cancel_pending_online_order(
  p_order_id uuid,
  p_reason text default null
)
returns void
language plpgsql
security definer
set search_path = public
as $function$
declare
  v_order_user_id uuid;
  v_status text;
  v_payment_method text;
  v_item record;
begin
  select
    user_id,
    status,
    payment_method
  into
    v_order_user_id,
    v_status,
    v_payment_method
  from public.orders
  where id = p_order_id
  for update;

  if not found then
    raise exception 'Order not found.';
  end if;

  if v_order_user_id <> auth.uid() then
    raise exception 'Unauthorized.';
  end if;

  if v_payment_method <> 'online' then
    raise exception 'Only online orders can be cancelled.';
  end if;

  if v_status <> 'pending' then
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
    payment_failure_reason = nullif(trim(p_reason), ''),
    updated_at = now()
  where id = p_order_id;
end;
$function$;

revoke all on function public.cancel_pending_online_order(uuid, text)
from public;

grant execute on function public.cancel_pending_online_order(uuid, text)
to authenticated;

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
    payment_failure_reason = nullif(
      trim(p_reason),
      ''
    ),
    updated_at = now()
  where id = p_order_id;
end;
$function$;

revoke all on function public.fail_online_order_from_webhook(
  uuid,
  text,
  text
)
from public;

commit;
