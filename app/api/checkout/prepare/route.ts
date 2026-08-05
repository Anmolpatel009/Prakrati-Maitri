import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

type CheckoutItem = {
  productId: string;
  quantity: number;
};

type CheckoutRequest = {
  items: CheckoutItem[];
};

export async function POST(request: Request) {
  try {
    const supabase = await createClient();

    // --------------------------------------------------
    // 1. Verify authenticated user
    // --------------------------------------------------

    const {
      data: { user },
      error: authError,
    } = await supabase.auth.getUser();

    if (authError || !user) {
      return NextResponse.json(
        {
          error: "You must be logged in to checkout.",
        },
        { status: 401 }
      );
    }

    // --------------------------------------------------
    // 2. Parse request
    // --------------------------------------------------

    const body = (await request.json()) as CheckoutRequest;

    if (!Array.isArray(body.items) || body.items.length === 0) {
      return NextResponse.json(
        {
          error: "Your cart is empty.",
        },
        { status: 400 }
      );
    }

    // --------------------------------------------------
    // 3. Validate cart items
    // --------------------------------------------------

    for (const item of body.items) {
      if (
        typeof item.productId !== "string" ||
        item.productId.trim() === ""
      ) {
        return NextResponse.json(
          {
            error: "Invalid product ID.",
          },
          { status: 400 }
        );
      }

      if (
        !Number.isInteger(item.quantity) ||
        item.quantity <= 0
      ) {
        return NextResponse.json(
          {
            error: "Invalid product quantity.",
          },
          { status: 400 }
        );
      }
    }

    // Prevent duplicate product IDs.
    const productIds = body.items.map(
      (item) => item.productId
    );

    if (new Set(productIds).size !== productIds.length) {
      return NextResponse.json(
        {
          error: "Duplicate products are not allowed.",
        },
        { status: 400 }
      );
    }

    // --------------------------------------------------
    // 4. Fetch active products from Supabase
    // --------------------------------------------------

    const { data: products, error: productsError } =
      await supabase
        .from("products")
        .select(
          "id, name, slug, sku, price, is_active"
        )
        .in("id", productIds);

    if (productsError) {
      console.error(
        "Product lookup failed:",
        productsError
      );

      return NextResponse.json(
        {
          error: "Unable to verify products.",
        },
        { status: 500 }
      );
    }

    if (!products || products.length !== productIds.length) {
      return NextResponse.json(
        {
          error:
            "One or more products are no longer available.",
        },
        { status: 400 }
      );
    }

    // --------------------------------------------------
    // 5. Make sure products are active
    // --------------------------------------------------

    for (const product of products) {
      if (!product.is_active) {
        return NextResponse.json(
          {
            error: `${product.name} is currently unavailable.`,
          },
          { status: 409 }
        );
      }
    }

    // --------------------------------------------------
    // 6. Fetch inventory
    // --------------------------------------------------

    const {
      data: inventory,
      error: inventoryError,
    } = await supabase
      .from("inventory")
      .select(
        "product_id, quantity, reserved_quantity"
      )
      .in("product_id", productIds);

    if (inventoryError) {
      console.error(
        "Inventory lookup failed:",
        inventoryError
      );

      return NextResponse.json(
        {
          error: "Unable to verify inventory.",
        },
        { status: 500 }
      );
    }

    // --------------------------------------------------
    // 7. Create lookup maps
    // --------------------------------------------------

    const productMap = new Map(
      products.map((product) => [
        product.id,
        product,
      ])
    );

    const inventoryMap = new Map(
      (inventory ?? []).map((stock) => [
        stock.product_id,
        stock,
      ])
    );

    // --------------------------------------------------
    // 8. Validate inventory + calculate prices
    // --------------------------------------------------

    const preparedItems = [];

    for (const item of body.items) {
      const product = productMap.get(
        item.productId
      );

      if (!product) {
        return NextResponse.json(
          {
            error: "Product not found.",
          },
          { status: 400 }
        );
      }

      const stock = inventoryMap.get(
        item.productId
      );

      if (!stock) {
        return NextResponse.json(
          {
            error: `${product.name} is currently out of stock.`,
          },
          { status: 409 }
        );
      }

      const quantity = stock.quantity ?? 0;

      const reservedQuantity =
        stock.reserved_quantity ?? 0;

      const availableQuantity = Math.max(
        0,
        quantity - reservedQuantity
      );

      // ------------------------------------------------
      // Stock validation
      // ------------------------------------------------

      if (
        availableQuantity < item.quantity
      ) {
        return NextResponse.json(
          {
            error: `${product.name} does not have enough stock.`,
            productId: product.id,
            requestedQuantity: item.quantity,
            availableQuantity,
          },
          { status: 409 }
        );
      }

      // ------------------------------------------------
      // Server-authoritative price
      // ------------------------------------------------

      const unitPrice = Number(product.price);

      if (
        !Number.isFinite(unitPrice) ||
        unitPrice < 0
      ) {
        console.error(
          "Invalid product price:",
          product
        );

        return NextResponse.json(
          {
            error: `Invalid price for ${product.name}.`,
          },
          { status: 500 }
        );
      }

      const lineTotal =
        unitPrice * item.quantity;

      preparedItems.push({
        productId: product.id,
        name: product.name,
        slug: product.slug,
        sku: product.sku,
        quantity: item.quantity,
        unitPrice,
        lineTotal,
        availableQuantity,
      });
    }

    // --------------------------------------------------
    // 9. Calculate totals SERVER-SIDE
    // --------------------------------------------------

    const subtotal = preparedItems.reduce(
      (sum, item) => sum + item.lineTotal,
      0
    );

    // Shipping logic comes later.
    const shippingFee = 0;

    const total = subtotal + shippingFee;

    // --------------------------------------------------
    // 10. Return trusted checkout data
    // --------------------------------------------------

    return NextResponse.json({
      success: true,

      checkout: {
        userId: user.id,

        items: preparedItems,

        subtotal,

        shippingFee,

        total,
      },
    });
  } catch (error) {
    console.error(
      "Checkout preparation failed:",
      error
    );

    return NextResponse.json(
      {
        error: "Unable to prepare checkout.",
      },
      { status: 500 }
    );
  }
}