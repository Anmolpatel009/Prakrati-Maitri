"use client";

import { usePathname } from "next/navigation";
import type { ReactNode } from "react";
import GlobalStorefrontFooter from "@/components/storefront/GlobalStorefrontFooter";

const HIDDEN_PREFIXES = [
  "/admin",
  "/login",
  "/signup",
  "/forgot-password",
  "/reset-password",
  "/verify-email",
  "/onboarding",
];

export default function StorefrontChrome({
  header,
  backgroundColor,
  children,
}: {
  header: ReactNode;
  backgroundColor: string;
  children: ReactNode;
}) {
  const pathname = usePathname();

  const isHidden = HIDDEN_PREFIXES.some(
    (prefix) =>
      pathname === prefix ||
      pathname.startsWith(`${prefix}/`),
  );

  if (isHidden) {
    return <>{children}</>;
  }

  return (
    <div
      className="storefront-global-shell"
      style={{
        backgroundColor,
        minHeight: "100vh",
        ["--site-background" as string]: backgroundColor,
      }}
    >
      {header}
      {children}
      <GlobalStorefrontFooter />
    </div>
  );
}
