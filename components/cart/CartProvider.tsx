"use client";

import {
  createContext,
  useContext,
  useEffect,
  useState,
  ReactNode,
} from "react";

export type CartCustomization = {
  type: "standard" | "custom";
  imageUrl: string | null;
  note: string;
};

export type CartItem = {
  cartItemId: string;

  productId: string;
  name: string;
  slug: string;

  price: number;
  imageUrl: string | null;
  quantity: number;

  customization: CartCustomization | null;
};

type AddItemInput = {
  productId: string;
  name: string;
  slug: string;
  price: number;
  imageUrl: string | null;
  customization?: CartCustomization | null;
};

type CartContextType = {
  items: CartItem[];

  addItem: (
    item: AddItemInput,
    quantity?: number
  ) => void;

  removeItem: (cartItemId: string) => void;

  updateQuantity: (
    cartItemId: string,
    quantity: number
  ) => void;

  clearCart: () => void;

  totalItems: number;
  subtotal: number;
};

const CartContext =
  createContext<CartContextType | undefined>(
    undefined
  );

const STORAGE_KEY = "prakratri-matri-cart";

function createCartItemId(): string {
  if (
    typeof crypto !== "undefined" &&
    typeof crypto.randomUUID === "function"
  ) {
    return crypto.randomUUID();
  }

  return `${Date.now()}-${Math.random()
    .toString(36)
    .slice(2)}`;
}

function getCustomizationKey(
  customization: CartCustomization | null | undefined
): string {
  if (!customization) {
    return "standard";
  }

  return JSON.stringify({
    type: customization.type,
    imageUrl: customization.imageUrl,
    note: customization.note.trim(),
  });
}

export function CartProvider({
  children,
}: {
  children: ReactNode;
}) {
  const [items, setItems] = useState<CartItem[]>([]);
  const [hydrated, setHydrated] = useState(false);

  // =====================================================
  // LOAD CART
  // =====================================================

  useEffect(() => {
    try {
      const storedCart =
        localStorage.getItem(STORAGE_KEY);

      if (storedCart) {
        const parsedCart = JSON.parse(storedCart);

        if (Array.isArray(parsedCart)) {
          setItems(parsedCart);
        }
      }
    } catch (error) {
      console.error(
        "Unable to load cart:",
        error
      );
    } finally {
      setHydrated(true);
    }
  }, []);

  // =====================================================
  // SAVE CART
  // =====================================================

  useEffect(() => {
    if (!hydrated) {
      return;
    }

    try {
      localStorage.setItem(
        STORAGE_KEY,
        JSON.stringify(items)
      );
    } catch (error) {
      console.error(
        "Unable to save cart:",
        error
      );
    }
  }, [items, hydrated]);

  // =====================================================
  // ADD ITEM
  // =====================================================

  function addItem(
    item: AddItemInput,
    quantity = 1
  ) {
    const safeQuantity = Math.max(
      1,
      Math.floor(quantity)
    );

    const customization =
      item.customization ?? null;

    const customizationKey =
      getCustomizationKey(customization);

    setItems((currentItems) => {
      const existingItem =
        currentItems.find(
          (cartItem) =>
            cartItem.productId ===
              item.productId &&
            getCustomizationKey(
              cartItem.customization
            ) === customizationKey
        );

      if (existingItem) {
        return currentItems.map(
          (cartItem) =>
            cartItem.cartItemId ===
            existingItem.cartItemId
              ? {
                  ...cartItem,
                  quantity:
                    cartItem.quantity +
                    safeQuantity,
                }
              : cartItem
        );
      }

      return [
        ...currentItems,
        {
          ...item,
          cartItemId: createCartItemId(),
          quantity: safeQuantity,
          customization,
        },
      ];
    });
  }

  // =====================================================
  // REMOVE ITEM
  // =====================================================

  function removeItem(
    cartItemId: string
  ) {
    setItems((currentItems) =>
      currentItems.filter(
        (item) =>
          item.cartItemId !== cartItemId
      )
    );
  }

  // =====================================================
  // UPDATE QUANTITY
  // =====================================================

  function updateQuantity(
    cartItemId: string,
    quantity: number
  ) {
    const safeQuantity = Math.floor(quantity);

    if (safeQuantity <= 0) {
      removeItem(cartItemId);
      return;
    }

    setItems((currentItems) =>
      currentItems.map((item) =>
        item.cartItemId === cartItemId
          ? {
              ...item,
              quantity: safeQuantity,
            }
          : item
      )
    );
  }

  // =====================================================
  // CLEAR CART
  // =====================================================

  function clearCart() {
    setItems([]);
  }

  // =====================================================
  // TOTAL ITEMS
  // =====================================================

  const totalItems = items.reduce(
    (total, item) =>
      total + item.quantity,
    0
  );

  // =====================================================
  // SUBTOTAL
  // =====================================================

  const subtotal = items.reduce(
    (total, item) =>
      total +
      item.price * item.quantity,
    0
  );

  return (
    <CartContext.Provider
      value={{
        items,
        addItem,
        removeItem,
        updateQuantity,
        clearCart,
        totalItems,
        subtotal,
      }}
    >
      {children}
    </CartContext.Provider>
  );
}

// =======================================================
// USE CART
// =======================================================

export function useCart() {
  const context = useContext(CartContext);

  if (!context) {
    throw new Error(
      "useCart must be used inside CartProvider"
    );
  }

  return context;
}