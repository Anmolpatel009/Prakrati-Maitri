alter table public.products
  add column if not exists short_description text;

create or replace function public.create_product_with_inventory_with_short_description(
  p_category_id uuid,
  p_subcategory_id uuid,
  p_name text,
  p_slug text,
  p_description text,
  p_short_description text,
  p_price numeric,
  p_compare_at_price numeric,
  p_sku text,
  p_is_active boolean,
  p_quantity integer
)
returns uuid
language plpgsql
security definer
set search_path = public
as $function$
declare
  new_product_id uuid;
begin
  if not public.is_admin() then
    raise exception 'Not authorized';
  end if;

  new_product_id := public.create_product_with_inventory(
    p_category_id,
    p_subcategory_id,
    p_name,
    p_slug,
    p_description,
    p_price,
    p_compare_at_price,
    p_sku,
    p_is_active,
    p_quantity
  );

  update public.products
  set short_description = nullif(trim(p_short_description), '')
  where id = new_product_id;

  return new_product_id;
end;
$function$;

revoke all on function public.create_product_with_inventory_with_short_description(
  uuid, uuid, text, text, text, text, numeric, numeric, text, boolean, integer
)
from public;

grant execute on function public.create_product_with_inventory_with_short_description(
  uuid, uuid, text, text, text, text, numeric, numeric, text, boolean, integer
)
to authenticated;
