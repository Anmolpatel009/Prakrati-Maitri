"use client";

import {
  createContext,
  useContext,
  useEffect,
  useState,
  ReactNode,
} from "react";
import { createClient } from "@/lib/supabase/client";

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
  minimumOrderQuantity: number;
  customization: CartCustomization | null;
};

type AddItemInput = {
  productId: string;
  name: string;
  slug: string;
  price: number;
  imageUrl: string | null;  minimumOrderQuantity?: number;
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

const LEGACY_STORAGE_KEY = "prakratri-matri-cart";
const GUEST_STORAGE_KEY = "prakratri-matri-cart-guest";

function getUserStorageKey(userId: string): string {
  return `prakratri-matri-cart-user-${userId}`;
}

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
  const [storageKey, setStorageKey] =
    useState(GUEST_STORAGE_KEY);
  const [hydrated, setHydrated] = useState(false);

  // =====================================================
  // LOAD CART + AUTH OWNERSHIP
  // =====================================================

  useEffect(() => {
    const supabase = createClient();
    let mounted = true;

    function loadCartForKey(
      key: string,
      clearLegacyGuestCart = false
    ) {
      try {
        let storedCart = localStorage.getItem(key);

        // Preserve carts created before cart ownership was introduced.
        if (
          key === GUEST_STORAGE_KEY &&
          !storedCart
        ) {
          storedCart =
            localStorage.getItem(LEGACY_STORAGE_KEY);

          if (storedCart) {
            localStorage.setItem(
              GUEST_STORAGE_KEY,
              storedCart
            );
            localStorage.removeItem(
              LEGACY_STORAGE_KEY
            );
          }
        }

        if (clearLegacyGuestCart) {
          localStorage.removeItem(
            LEGACY_STORAGE_KEY
          );
        }

        const parsedCart = storedCart
          ? JSON.parse(storedCart)
          : [];

        setItems(
          Array.isArray(parsedCart)
            ? parsedCart
            : []
        );
        setStorageKey(key);
      } catch (error) {
        console.error(
          "Unable to load cart:",
          error
        );
        setItems([]);
        setStorageKey(key);
      }
    }

    async function initializeCart() {
      try {
        const {
          data: { session },
        } = await supabase.auth.getSession();

        if (!mounted) {
          return;
        }

        if (session?.user) {
          // Never import the anonymous/legacy cart
          // into an authenticated account.
          loadCartForKey(
            getUserStorageKey(session.user.id),
            true
          );
        } else {
          loadCartForKey(GUEST_STORAGE_KEY);
        }
      } finally {
        if (mounted) {
          setHydrated(true);
        }
      }
    }

    void initializeCart();

    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange(
      (event, session) => {
        if (!mounted) {
          return;
        }

        if (event === "SIGNED_IN" && session?.user) {
          // Authentication creates a new cart boundary.
          // Guest items must never enter the account cart.
          setHydrated(false);

          try {
            localStorage.removeItem(
              GUEST_STORAGE_KEY
            );
            localStorage.removeItem(
              LEGACY_STORAGE_KEY
            );
          } catch (error) {
            console.error(
              "Unable to clear guest cart:",
              error
            );
          }

          loadCartForKey(
            getUserStorageKey(session.user.id)
          );
          setHydrated(true);
          return;
        }

        if (event === "SIGNED_OUT") {
          setHydrated(false);
          loadCartForKey(GUEST_STORAGE_KEY);
          setHydrated(true);
        }
      }
    );

    return () => {
      mounted = false;
      subscription.unsubscribe();
    };
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
        storageKey,
        JSON.stringify(items)
      );
    } catch (error) {
      console.error(
        "Unable to save cart:",
        error
      );
    }
  }, [items, storageKey, hydrated]);

  // =====================================================
  // ADD ITEM
  // =====================================================

  function addItem(
    item: AddItemInput,
    quantity = 1
  ) {
        const minimumOrderQuantity = Math.max(
      1,
      Math.floor(item.minimumOrderQuantity ?? 1)
    );

    const safeQuantity = Math.max(
      minimumOrderQuantity,
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
                  minimumOrderQuantity: Math.max(
                    1,
                    Math.floor(
                      item.minimumOrderQuantity ??
                        cartItem.minimumOrderQuantity ??
                        1
                    )
                  ),
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
          minimumOrderQuantity,
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

    setItems((currentItems) =>
      currentItems.map((item) => {
        if (item.cartItemId !== cartItemId) {
          return item;
        }

        const minimumOrderQuantity = Math.max(
          1,
          Math.floor(item.minimumOrderQuantity ?? 1)
        );

        return {
          ...item,
          minimumOrderQuantity,
          quantity: Math.max(
            minimumOrderQuantity,
            safeQuantity
          ),
        };
      })
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