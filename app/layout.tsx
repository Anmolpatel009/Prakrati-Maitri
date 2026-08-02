import type { Metadata } from "next";
import "./globals.css";
import { CartProvider } from "@/components/cart/CartProvider";

export const metadata: Metadata = {
  title: "Prakratri Matri",
  description: "Sustainable and eco-friendly products",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body>
        <CartProvider>
          {children}
        </CartProvider>
      </body>
    </html>
  );

}