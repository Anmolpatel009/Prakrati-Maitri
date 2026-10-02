import type { Metadata } from "next";
import "./globals.css";
import { CartProvider } from "@/components/cart/CartProvider";
import GlobalStorefrontHeader from "@/components/storefront/GlobalStorefrontHeader";
import StorefrontChrome from "@/components/storefront/StorefrontChrome";
import { getShopNavbarData } from "@/lib/shop/navbar";
import {
  getNavbarCustomization,
  type NavbarItem,
} from "@/lib/shop/navbar-customization";
import { getSiteAppearance } from "@/lib/shop/site-appearance";

export const metadata: Metadata = {
  title: "Prakriti Maitri",
  description: "Sustainable and eco-friendly products",
};

export default async function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const navbarData = await getShopNavbarData();
  const siteAppearance = await getSiteAppearance();

  const fallbackItems: NavbarItem[] = [
    { key: "new", type: "new" },
    ...navbarData.categories.map((category) => ({
      key: `category:${category.id}`,
      type: "category" as const,
      id: category.id,
    })),
    { key: "reviews", type: "reviews" },
    { key: "bulk_orders", type: "bulk_orders" },
  ];

  const navbarCustomization = await getNavbarCustomization(
    fallbackItems,
  );

  return (
    <html lang="en">
      <body>
        <CartProvider>
          <StorefrontChrome
            backgroundColor={siteAppearance.background_color}
            header={
              <GlobalStorefrontHeader
                navbarData={navbarData}
                customization={navbarCustomization}
              />
            }
          >
            {children}
          </StorefrontChrome>
        </CartProvider>
      </body>
    </html>
  );
}
