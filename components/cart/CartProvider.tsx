"use client";

import {
  createContext,
  useContext,
  useEffect,
  useState,
  ReactNode,
} from "react";

export type CartItem = {
  productId: string;
  name: string;
  slug: string;
  price: number;
  imageUrl: string | null;
  quantity: number;
};

type CartContextType = {
  items: CartItem[];
  addItem: (item: Omit<CartItem, "quantity">, quantity?: number) => void;
  removeItem: (productId: string) => void;
  updateQuantity: (productId: string, quantity: number) => void;
  clearCart: () => void;
  totalItems: number;
  subtotal: number;
};

const CartContext = createContext<CartContextType | undefined>(undefined);

const STORAGE_KEY = "prakratri-matri-cart";

export function CartProvider({ children }: { children: ReactNode }) {
  const [items, setItems] = useState<CartItem[]>([]);
  const [hydrated, setHydrated] = useState(false);

  // Load cart from localStorage
  useEffect(() => {
    try {
      const storedCart = localStorage.getItem(STORAGE_KEY);

      if (storedCart) {
        const parsedCart = JSON.parse(storedCart);

        if (Array.isArray(parsedCart)) {
          setItems(parsedCart);
        }
      }
    } catch (error) {
      console.error("Unable to load cart:", error);
    } finally {
      setHydrated(true);
    }
  }, []);

  // Save cart to localStorage
  useEffect(() => {
    if (!hydrated) {
      return;
    }

    try {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(items));
    } catch (error) {
      console.error("Unable to save cart:", error);
    }
  }, [items, hydrated]);

  function addItem(
    item: Omit<CartItem, "quantity">,
    quantity = 1
  ) {
    setItems((currentItems) => {
      const existingItem = currentItems.find(
        (cartItem) => cartItem.productId === item.productId
      );

      if (existingItem) {
        return currentItems.map((cartItem) =>
          cartItem.productId === item.productId
            ? {
                ...cartItem,
                quantity: cartItem.quantity + quantity,
              }
            : cartItem
        );
      }

      return [
        ...currentItems,
        {
          ...item,
          quantity,
        },
      ];
    });
  }

  function removeItem(productId: string) {
    setItems((currentItems) =>
      currentItems.filter(
        (item) => item.productId !== productId
      )
    );
  }

  function updateQuantity(
    productId: string,
    quantity: number
  ) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    setItems((currentItems) =>
      currentItems.map((item) =>
        item.productId === productId
          ? {
              ...item,
              quantity,
            }
          : item
      )
    );
  }

  function clearCart() {
    setItems([]);
  }

  const totalItems = items.reduce(
    (total, item) => total + item.quantity,
    0
  );

  const subtotal = items.reduce(
    (total, item) => total + item.price * item.quantity,
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

export function useCart() {
  const context = useContext(CartContext);

  if (!context) {
    throw new Error(
      "useCart must be used inside CartProvider"
    );
  }

  return context;
}