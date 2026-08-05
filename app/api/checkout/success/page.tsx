import Link from "next/link";

type SuccessPageProps = {
  searchParams: Promise<{
    order?: string;
  }>;
};

export default async function SuccessPage({
  searchParams,
}: SuccessPageProps) {
  const params = await searchParams;
  const orderId = params.order;

  return (
    <main>
      <h1>Order Confirmed</h1>

      <p>
        Thank you for your order.
      </p>

      {orderId && (
        <p>
          <strong>Order ID:</strong> {orderId}
        </p>
      )}

      <p>
        Your order has been successfully created.
      </p>

      <p>
        <Link href="/shop">
          Continue Shopping
        </Link>
      </p>

      <p>
        <Link href="/account/orders">
          View My Orders
        </Link>
      </p>
    </main>
  );
}