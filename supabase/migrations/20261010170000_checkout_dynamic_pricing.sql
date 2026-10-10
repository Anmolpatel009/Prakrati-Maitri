-- Dynamic checkout pricing. Order item unit prices and inventory reservation remain
-- owned by the original order function; this wrapper adjusts only order-level totals.
begin;

alter table public.orders
  add column if not exists extra_charges_total numeric(12,2) not null default 0,
  add column if not exists promo_discount numeric(12,2) not null default 0,
  add column if not exists promo_code text,
  add column if not exists pricing_breakdown jsonb not null default '{}'::jsonb;

alter function public.create_order_with_payment(jsonb, jsonb, text)
  rename to create_order_with_payment_legacy;

create or replace function public.calculate_checkout_pricing(
  p_items jsonb,
  p_promo_code text default null
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $pricing$
declare
  v_config jsonb := '{}'::jsonb;
  v_item jsonb;
  v_charge jsonb;
  v_promo jsonb;
  v_product_id uuid;
  v_quantity integer;
  v_price numeric;
  v_category_id text;
  v_subcategory_id text;
  v_subtotal numeric(12,2) := 0;
  v_delivery_fee numeric(12,2) := 0;
  v_delivery_amount numeric(12,2) := 80;
  v_threshold numeric(12,2) := 999;
  v_threshold_is_null boolean := false;
  v_charges_total numeric(12,2) := 0;
  v_charge_amount numeric(12,2);
  v_match_quantity integer;
  v_extra_lines jsonb := '[]'::jsonb;
  v_promo_code text := upper(trim(coalesce(p_promo_code, '')));
  v_promo_discount numeric(12,2) := 0;
  v_promo_valid boolean := true;
  v_total numeric(12,2) := 0;
begin
  if jsonb_typeof(p_items) <> 'array' or jsonb_array_length(p_items) = 0 then
    raise exception 'Cart is empty.';
  end if;

  begin
    select description::jsonb into v_config
    from public.homepage_sections
    where section_key = 'checkout_pricing_config' and is_active = true
    limit 1;
  exception when others then
    v_config := '{}'::jsonb;
  end;
  v_config := coalesce(v_config, '{}'::jsonb);
  v_delivery_amount := greatest(0, coalesce(nullif(v_config->>'deliveryFeeAmount','')::numeric, 80));
  v_threshold_is_null := (v_config ? 'freeDeliveryThreshold' and v_config->'freeDeliveryThreshold' = 'null'::jsonb);
  if not v_threshold_is_null then
    begin
      v_threshold := coalesce(nullif(v_config->>'freeDeliveryThreshold','')::numeric, 999);
    exception when others then
      v_threshold := 999;
    end;
  end if;

  for v_item in select value from jsonb_array_elements(p_items) as e(value) loop
    v_product_id := nullif(v_item->>'productId','')::uuid;
    v_quantity := nullif(v_item->>'quantity','')::integer;
    if v_product_id is null or v_quantity is null or v_quantity < 1 then
      raise exception 'Invalid cart item.';
    end if;
    select p.price, p.category_id::text, p.subcategory_id::text
      into v_price, v_category_id, v_subcategory_id
    from public.products p where p.id = v_product_id;
    if not found then raise exception 'Product is unavailable.'; end if;
    if v_price is null or v_price < 0 then raise exception 'Invalid product price.'; end if;
    v_subtotal := v_subtotal + (v_price * v_quantity);
  end loop;

  if not v_threshold_is_null and v_subtotal >= v_threshold then
    v_delivery_fee := 0;
  else
    v_delivery_fee := v_delivery_amount;
  end if;

  if jsonb_typeof(v_config->'charges') = 'array' then
    for v_charge in select value from jsonb_array_elements(v_config->'charges') as c(value) loop
      if coalesce(v_charge->>'active','true') <> 'false' then
        v_charge_amount := greatest(0, coalesce(nullif(v_charge->>'amount','')::numeric, 0));
        if v_charge_amount > 0 and coalesce(v_charge->>'categoryId','') <> '' then
          select coalesce(sum((e.value->>'quantity')::integer),0)::integer
            into v_match_quantity
          from jsonb_array_elements(p_items) as e(value)
          join public.products p on p.id = nullif(e.value->>'productId','')::uuid
          where p.category_id::text = v_charge->>'categoryId'
            and (coalesce(v_charge->>'subcategoryId','') = ''
              or p.subcategory_id::text = v_charge->>'subcategoryId');
          if coalesce(v_match_quantity,0) > 0 then
            if v_charge->>'application' = 'once_per_order' then
              v_charges_total := v_charges_total + v_charge_amount;
              v_extra_lines := v_extra_lines || jsonb_build_array(jsonb_build_object(
                'id', v_charge->>'id', 'label', coalesce(nullif(v_charge->>'label',''),'Extra charge'),
                'amount', v_charge_amount, 'application', 'once_per_order'));
            else
              v_charges_total := v_charges_total + (v_charge_amount * v_match_quantity);
              v_extra_lines := v_extra_lines || jsonb_build_array(jsonb_build_object(
                'id', v_charge->>'id', 'label', coalesce(nullif(v_charge->>'label',''),'Extra charge'),
                'amount', v_charge_amount * v_match_quantity, 'application', 'per_item'));
            end if;
          end if;
        end if;
      end if;
    end loop;
  end if;

  if v_promo_code <> '' then
    v_promo_valid := false;
    if jsonb_typeof(v_config->'promoCodes') = 'array' then
      for v_promo in select value from jsonb_array_elements(v_config->'promoCodes') as p(value) loop
        if upper(coalesce(v_promo->>'code','')) = v_promo_code
           and coalesce(v_promo->>'active','true') <> 'false' then
          v_promo_valid := true;
          v_promo_discount := least(v_subtotal, greatest(0, coalesce(nullif(v_promo->>'discountAmount','')::numeric, 0)));
          exit;
        end if;
      end loop;
    end if;
  end if;
  v_total := greatest(0, v_subtotal + v_delivery_fee + v_charges_total - v_promo_discount);
  return jsonb_build_object(
    'subtotal', round(v_subtotal,2),
    'shippingFee', round(v_delivery_fee,2),
    'extraCharges', v_extra_lines,
    'extraChargesTotal', round(v_charges_total,2),
    'promoCode', case when v_promo_valid and v_promo_discount > 0 then v_promo_code else null end,
    'promoDiscount', round(v_promo_discount,2),
    'validPromo', v_promo_valid,
    'total', round(v_total,2)
  );
end;
$pricing$;

create or replace function public.create_order_with_payment(
  p_items jsonb,
  p_shipping jsonb,
  p_payment_method text
)
returns uuid
language plpgsql
security definer
set search_path = public
as $checkout$
declare
  v_order_id uuid;
  v_pricing jsonb;
  v_promo_code text := upper(trim(coalesce(p_shipping->>'_promoCode','')));
begin
  v_order_id := public.create_order_with_payment_legacy(p_items, p_shipping, p_payment_method);
  v_pricing := public.calculate_checkout_pricing(p_items, v_promo_code);
  if v_promo_code <> '' and coalesce((v_pricing->>'validPromo')::boolean,false) = false then
    raise exception 'Promo code is invalid or inactive.';
  end if;
  update public.orders
  set subtotal = (v_pricing->>'subtotal')::numeric,
      shipping_fee = (v_pricing->>'shippingFee')::numeric,
      extra_charges_total = (v_pricing->>'extraChargesTotal')::numeric,
      promo_code = v_pricing->>'promoCode',
      promo_discount = (v_pricing->>'promoDiscount')::numeric,
      pricing_breakdown = v_pricing,
      total = (v_pricing->>'total')::numeric
  where id = v_order_id;
  return v_order_id;
end;
$checkout$;

revoke all on function public.create_order_with_payment_legacy(jsonb, jsonb, text) from public, anon, authenticated, service_role;
grant execute on function public.calculate_checkout_pricing(jsonb, text) to anon, authenticated, service_role;
grant execute on function public.create_order_with_payment(jsonb, jsonb, text) to anon, authenticated, service_role;
commit;