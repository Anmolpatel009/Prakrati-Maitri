import { createClient } from "@/lib/supabase/server";

export type StorefrontAnnouncementConfig = {
  enabled: boolean;
  desktopText: string;
  mobileText: string;
  bulkLinkEnabled: boolean;
  bulkLinkText: string;
  bulkLinkUrl: string;
};

const DEFAULT_CONFIG: StorefrontAnnouncementConfig = {
  enabled: true,
  desktopText: "Free delivery over ₹100 order value",
  mobileText: "Bulk orders · custom logo · PAN India delivery",
  bulkLinkEnabled: true,
  bulkLinkText: "Bulk enquiries",
  bulkLinkUrl: "/bulk-order",
};

function stringValue(value: unknown, fallback: string): string {
  return typeof value === "string" ? value : fallback;
}

function safeHref(value: unknown): string {
  if (typeof value !== "string") return "/bulk-order";
  const href = value.trim();

  // Permit same-site paths and explicit HTTP(S) URLs only.
  if (href.startsWith("/") && !href.startsWith("//")) return href;
  if (/^https?:\/\//i.test(href)) return href;

  return "/bulk-order";
}

function parseConfig(description: string | null): StorefrontAnnouncementConfig {
  if (!description) return DEFAULT_CONFIG;

  try {
    const raw: unknown = JSON.parse(description);
    if (!raw || typeof raw !== "object" || Array.isArray(raw)) {
      return DEFAULT_CONFIG;
    }

    const value = raw as Record<string, unknown>;
    return {
      enabled: value.enabled !== false,
      desktopText: stringValue(
        value.desktopText ?? value.desktop_text,
        DEFAULT_CONFIG.desktopText,
      ),
      mobileText: stringValue(
        value.mobileText ?? value.mobile_text,
        DEFAULT_CONFIG.mobileText,
      ),
      bulkLinkEnabled:
        value.bulkLinkEnabled !== false && value.bulk_link_enabled !== false,
      bulkLinkText: stringValue(
        value.bulkLinkText ?? value.bulk_link_text,
        DEFAULT_CONFIG.bulkLinkText,
      ),
      bulkLinkUrl: safeHref(value.bulkLinkUrl ?? value.bulk_link_url),
    };
  } catch {
    return DEFAULT_CONFIG;
  }
}

export async function getStorefrontAnnouncementConfig(): Promise<StorefrontAnnouncementConfig> {
  try {
    const supabase = await createClient();
    const { data, error } = await supabase
      .from("homepage_sections")
      .select("description")
      .eq("section_key", "storefront_announcements")
      .maybeSingle();

    if (error) return DEFAULT_CONFIG;
    return parseConfig(data?.description ?? null);
  } catch {
    // Announcement settings are optional; never take down the storefront.
    return DEFAULT_CONFIG;
  }
}