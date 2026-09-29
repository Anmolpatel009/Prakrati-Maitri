create or replace function public.attach_razorpay_order_id(
  p_order_id uuid,
  p_razorpay_order_id text
)
returns uuid
language plpgsql
security definer
set search_path = public
as $function$
declare
  v_user_id uuid;
  v_status text;
  v_payment_status text;
  v_payment_method text;
  v_existing_razorpay_order_id text;
begin
  if auth.uid() is null then
    raise exception 'Unauthorized.';
  end if;

  if p_razorpay_order_id is null
     or trim(p_razorpay_order_id) = '' then
    raise exception 'Razorpay order ID is required.';
  end if;

  select
    user_id,
    status,
    payment_status,
    payment_method,
    razorpay_order_id
  into
    v_user_id,
    v_status,
    v_payment_status,
    v_payment_method,
    v_existing_razorpay_order_id
  from public.orders
  where id = p_order_id
  for update;

  if not found then
    raise exception 'Order not found.';
  end if;

  if v_user_id <> auth.uid() then
    raise exception 'Unauthorized.';
  end if;

  if v_payment_method <> 'online' then
    raise exception 'Only online orders can use Razorpay.';
  end if;

  if v_status <> 'pending' or v_payment_status <> 'pending' then
    raise exception 'Order is not pending payment.';
  end if;

  if v_existing_razorpay_order_id is not null then
    if v_existing_razorpay_order_id = p_razorpay_order_id then
      return p_order_id;
    end if;

    raise exception 'Razorpay order ID is already attached.';
  end if;

  update public.orders
  set
    razorpay_order_id = trim(p_razorpay_order_id),
    updated_at = now()
  where id = p_order_id;

  return p_order_id;
end;
$function$;

revoke all on function public.attach_razorpay_order_id(uuid, text)
from public;

grant execute on function public.attach_razorpay_order_id(uuid, text)
to authenticated;
