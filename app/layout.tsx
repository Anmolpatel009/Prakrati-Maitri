import type { Metadata } from "next";
import "./globals.css";

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
      <body>{children}</body>
    </html>
  );
}