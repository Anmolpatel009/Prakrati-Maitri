"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import CartBadge from "@/components/cart/CartBadge";
import type { NavbarCustomizationConfig, NavbarItem } from "@/lib/shop/navbar-customization";
import type { StorefrontAnnouncementConfig } from "@/lib/shop/announcement-strip";

type StoreCategory = {
  id: string;
  name: string;
  slug: string;
  image_url: string | null;
  is_active: boolean;
};

type StoreSubcategory = {
  id: string;
  category_id: string;
  name: string;
  slug: string;
  is_active: boolean;
  display_order: number;
};

type Props = {
  navbarData: { categories: StoreCategory[]; subcategories: StoreSubcategory[] };
  customization: NavbarCustomizationConfig;
  announcementConfig: StorefrontAnnouncementConfig;
};

type LinkItem = { label: string; note?: string | null; href: string };
type CategoryView = {
  key: string;
  id: string;
  name: string;
  desc: string;
  thumb: string;
  picture: string;
  href: string;
  groups: { title: string; links: LinkItem[] }[];
};
type NavRow = { key: string; label: string; type: "category" | "link"; catKey?: string; href?: string };
type Door = "shop" | "bulk";

const BULK_URL = "/bulk-order";

function fallbackCategoryImage(slug: string, name: string): string {
  const key = `${slug} ${name}`.toLowerCase();
  if (key.includes("print")) return "/images/header/menu-printed-thumb.webp";
  if (key.includes("tote")) return "/images/header/menu-tote-thumb.webp";
  if (key.includes("hamper")) return "/images/header/menu-hamper-thumb.webp";
  if (key.includes("packaging") || key.includes("pouch") || key.includes("saree")) return "/images/header/menu-packaging-thumb.webp";
  if (key.includes("jute") || key.includes("hand") || key.includes("sling") || key.includes("laptop")) return "/images/header/menu-hand-thumb.webp";
  return "/images/header/bulk-canvas-front-jute.webp";
}

function makeCategoryViews(categories: StoreCategory[], subcategories: StoreSubcategory[]): CategoryView[] {
  return categories.filter((category) => category.is_active).map((category) => {
    const href = `/shop/${category.slug}`;
    const children = subcategories
      .filter((subcategory) => subcategory.is_active && subcategory.category_id === category.id)
      .sort((a, b) => (a.display_order ?? 0) - (b.display_order ?? 0) || a.name.localeCompare(b.name));
    const links: LinkItem[] = children.length
      ? children.map((subcategory) => ({
          label: subcategory.name,
          href: `${href}/${subcategory.slug}`,
          note: null,
        }))
      : [{ label: `Shop all ${category.name}`, href }];
    const image = category.image_url || fallbackCategoryImage(category.slug, category.name);
    return {
      key: category.id,
      id: category.id,
      name: category.name,
      desc: children.length ? `${children.length} collections and styles` : "Explore the collection",
      thumb: image,
      picture: image,
      href,
      groups: [{ title: `Browse ${category.name}`, links }],
    };
  });
}

function makeNavRows(items: NavbarItem[], categoryViews: CategoryView[], categories: StoreCategory[], subcategories: StoreSubcategory[]): NavRow[] {
  const rows: NavRow[] = [];
  for (const item of items) {
    if (item.type === "bulk_orders") continue; // Bulk has its own door in this design.
    if (item.type === "category") {
      const category = categoryViews.find((candidate) => candidate.id === item.id);
      if (category) rows.push({ key: item.key, label: item.label?.trim() || category.name, type: "category", catKey: category.key });
      continue;
    }
    if (item.type === "subcategory") {
      const subcategory = subcategories.find((candidate) => candidate.id === item.id);
      const parent = subcategory && categories.find((candidate) => candidate.id === subcategory.category_id);
      if (subcategory && parent) rows.push({ key: item.key, label: item.label?.trim() || subcategory.name, type: "link", href: `/shop/${parent.slug}/${subcategory.slug}` });
      continue;
    }
    if (item.type === "new") rows.push({ key: item.key, label: item.label?.trim() || "NEW", type: "link", href: item.href || "/shop?category=new" });
    else if (item.type === "reviews") rows.push({ key: item.key, label: item.label?.trim() || "REVIEWS", type: "link", href: item.href || "/reviews" });
    else if (item.type === "link") rows.push({ key: item.key, label: item.label?.trim() || "LINK", type: "link", href: item.href || "/shop" });
  }
  if (!rows.some((row) => row.type === "category")) {
    for (const category of categoryViews) rows.push({ key: `category:${category.id}`, label: category.name, type: "category", catKey: category.key });
  }
  return rows;
}

function Arrow() {
  return <svg className="pm-ar" viewBox="0 0 24 24" aria-hidden="true"><path d="M5 12h14M13 6l6 6-6 6" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" /></svg>;
}
function Go() {
  return <svg className="pm-dd-go" viewBox="0 0 24 24" aria-hidden="true"><path d="M9 6l6 6-6 6" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" /></svg>;
}
function Building() {
  return <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 21V5h10v16M14 9h6v12M7 9h4M7 13h4M7 17h4M17 13h1M17 17h1M2 21h20" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinejoin="round" /></svg>;
}
function CategoryGroups({ category }: { category: CategoryView }) {
  return <>
    {category.groups.map((group) => <div className="pm-dd-group" key={group.title}>
      <h4>{group.title}</h4>
      <ul>{group.links.map((link) => <li key={`${link.href}-${link.label}`}><a href={link.href}><span>{link.label}</span>{link.note ? <small>{link.note}</small> : null}</a></li>)}</ul>
    </div>)}
  </>;
}

export default function TwoDoorsHeader({ navbarData, customization, announcementConfig }: Props) {
  const categories = useMemo(() => makeCategoryViews(navbarData.categories, navbarData.subcategories), [navbarData.categories, navbarData.subcategories]);
  const navRows = useMemo(() => makeNavRows(customization.items, categories, navbarData.categories, navbarData.subcategories), [customization.items, categories, navbarData.categories, navbarData.subcategories]);
  const defaultCategory = categories.find((category) => category.href.endsWith("/hamper-bags"))?.key || categories[0]?.key || "";
  const [door, setDoor] = useState<Door>("shop");
  const [open, setOpenState] = useState(false);
  const [active, setActive] = useState(defaultCategory);
  const [accordion, setAccordion] = useState<string | null>(defaultCategory);
  const [isPhone, setIsPhone] = useState(false);
  const shopButton = useRef<HTMLButtonElement>(null);

  useEffect(() => {
    if (!categories.some((category) => category.key === active) && defaultCategory) setActive(defaultCategory);
    if (!categories.some((category) => category.key === accordion) && defaultCategory) setAccordion(defaultCategory);
  }, [categories, active, accordion, defaultCategory]);

  useEffect(() => {
    const mediaQuery = window.matchMedia("(max-width:767px)");
    const update = () => setIsPhone(mediaQuery.matches);
    update();
    mediaQuery.addEventListener("change", update);
    if (window.location.pathname === BULK_URL || window.location.hash === "#bulk" || new URLSearchParams(window.location.search).get("door") === "bulk") setDoor("bulk");
    return () => mediaQuery.removeEventListener("change", update);
  }, []);

  useEffect(() => {
    const root = document.documentElement;
    const previous = root.style.overflow;
    if (open && isPhone && door === "shop") root.style.overflow = "hidden";
    return () => { root.style.overflow = previous; };
  }, [open, isPhone, door]);

  useEffect(() => {
    if (!open || door !== "shop") return;
    const handleOutside = (event: MouseEvent | TouchEvent) => {
      const target = event.target;
      if (!(target instanceof Element)) return;
      if (target.closest(".pm-dd-box") || target.closest(".pm-hd-navbtn") || target.closest("#pm-door-shop") || target.closest(".pm-hd-burger")) return;
      setOpenState(false);
    };
    const handleEscape = (event: KeyboardEvent) => {
      if (event.key === "Escape") {
        setOpenState(false);
        shopButton.current?.focus();
      }
    };
    document.addEventListener("mousedown", handleOutside);
    document.addEventListener("touchstart", handleOutside);
    document.addEventListener("keydown", handleEscape);
    return () => {
      document.removeEventListener("mousedown", handleOutside);
      document.removeEventListener("touchstart", handleOutside);
      document.removeEventListener("keydown", handleEscape);
    };
  }, [open, door]);

  const clickShop = () => {
  if (window.location.pathname === BULK_URL) {
    window.location.href = "/";
    return;
  }
  setDoor("shop");
  setOpenState(false);
};
  const clickCategory = (key: string) => {
    if (!isPhone && open && active === key) {
      setOpenState(false);
      return;
    }
    setActive(key);
    setAccordion(key);
    setOpenState(true);
  };
  const chooseBulk = () => { window.location.href = BULK_URL; };

  return <header className="pm-hd" id="top">
    {announcementConfig.enabled && (
      <div className="pm-hd-strip">
        <p className="pm-hd-strip-d">{announcementConfig.desktopText}</p>
        <p className="pm-hd-strip-m">{announcementConfig.mobileText}</p>
        {announcementConfig.bulkLinkEnabled && (
          <div className="pm-hd-strip-r">
            <a href={announcementConfig.bulkLinkUrl || BULK_URL}>
              {announcementConfig.bulkLinkText} <Arrow />
            </a>
          </div>
        )}
      </div>
    )}

    <div className="pm-hd-main">
      <button type="button" className="pm-hd-burger" aria-label="Open shop menu" onClick={() => { setDoor("shop"); setOpenState(true); }}>
        <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 7h16M4 12h16M4 17h16" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" /></svg>
      </button>
      <a className="pm-hd-logo" href="/shop" aria-label="Prakriti Maitri home">
        <span className="pm-hd-mark" aria-hidden="true"><img src="/prakrati-maitri-logo.jpg" alt="" /></span>
        <span className="pm-hd-name" style={{ color: "#4E3320" }}><b style={{ fontFamily: customization.brand_font_family, fontSize: `${Math.min(Math.max(customization.brand_font_size, 20), 32)}px`, fontWeight: customization.brand_font_weight, fontStyle: customization.brand_font_style, color: "#4E3320" }}>PRAKRITI MAITRI</b><small>Jute bags · Manufacturer</small></span>
      </a>
      <div className="pm-hd-doors" role="tablist" aria-label="Choose shopping experience">
        <button ref={shopButton} type="button" role="tab" id="pm-door-shop" aria-selected={door === "shop"} aria-expanded={open} aria-controls="pm-dd" onClick={clickShop}>
          <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 9l1.5-5h13L20 9M4 9v11h16V9M4 9h16M9 20v-6h6v6" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinejoin="round" /> </svg>
          Shop
        </button>
        <button type="button" role="tab" id="pm-door-bulk" aria-selected={door === "bulk"} aria-controls="pm-bk" onClick={chooseBulk}><Building />Corporate &amp; Bulk</button>
      </div>
      <div className="pm-hd-icons">


        <a href="/cart" aria-label="Cart" className="pm-hd-cart"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 8h14l-1.2 12H6.2z" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinejoin="round" /><path d="M9 8V6a3 3 0 0 1 6 0v2" fill="none" stroke="currentColor" strokeWidth="1.8" /></svg><CartBadge /></a>
      </div>
    </div>

    <div className="pm-hd-shop" hidden={door !== "shop"} style={{ display: door === "shop" ? undefined : "none" }}>
      <nav className="pm-hd-nav" aria-label="Shop categories"><ul>
        {/* NAV CLEANUP - REMOVE PREV AND REVIEWS */}
        {navRows.filter((row) => !["PREV", "REVIEWS"].includes(row.label.trim().toUpperCase())).map((row) => <li key={row.key}>
          {row.type === "category" && row.catKey ? <button type="button" className="pm-hd-navbtn" aria-controls="pm-dd" aria-expanded={open && active === row.catKey} onClick={() => clickCategory(row.catKey!)}>
            {row.label}<svg className="pm-nav-chev" viewBox="0 0 24 24" aria-hidden="true"><path d="M6 9l6 6 6-6" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" /></svg>
          </button> : <a href={row.href || "/shop"}>{row.label}</a>}
        </li>)}
                <li className="pm-hd-bulk-cta-item" style={{ flexShrink: 0, marginLeft: "10px", display: "flex", alignItems: "center" }}>
          <a
            href={BULK_URL}
            className="pm-hd-navbtn pm-hd-bulk-cta"
            aria-label="Bulk Order"
            style={{
              alignItems: "center",
              backgroundColor: "#8B4513",
              border: "1px solid #8B4513",
              borderRadius: "9999px",
              color: "#FFFFFF",
              display: "inline-flex",
              gap: "6px",
              height: "30px",
              justifyContent: "center",
              padding: "0 11px",
              textDecoration: "none",
              textTransform: "uppercase",
              whiteSpace: "nowrap"
            }}
          >
            Bulk Order <Arrow />
          </a>
        </li>
      </ul></nav>

      <div className="pm-dd" id="pm-dd" hidden={!open}>
        <div className="pm-dd-backdrop" onClick={() => setOpenState(false)} />
        <div className="pm-dd-box" role="dialog" aria-label="Shop by category">
          <div className="pm-dd-sheethead"><span className="pm-dd-grab" /><h3>Shop by category</h3>
            <button type="button" className="pm-dd-x" aria-label="Close categories" onClick={() => setOpenState(false)}><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M6 6l12 12M18 6L6 18" stroke="currentColor" strokeWidth="2" strokeLinecap="round" /></svg></button>
          </div>
          <div className="pm-dd-left"><p className="pm-dd-eb">All categories</p><ul>
            {categories.map((category) => {
              const expanded = isPhone ? accordion === category.key : active === category.key;
              return <li key={category.key}>
                <button type="button" className="pm-dd-cat" aria-expanded={expanded} onMouseEnter={() => !isPhone && setActive(category.key)} onFocus={() => !isPhone && setActive(category.key)} onClick={() => isPhone ? setAccordion(accordion === category.key ? null : category.key) : setActive(category.key)}>
                  <span className="pm-dd-thumb"><img src={category.thumb} alt="" width={44} height={44} loading="lazy" /></span>
                  <span className="pm-dd-ct"><b>{category.name}</b><small>{category.desc}</small></span><Go />
                </button>
                <div className="pm-dd-acc"><CategoryGroups category={category} /><a className="pm-dd-all" href={category.href}>Shop all <Arrow /></a></div>
              </li>;
            })}
          </ul></div>
          {categories.map((category) => <div className="pm-dd-panel" key={category.key} hidden={active !== category.key}>
            <div className="pm-dd-mid"><div className="pm-dd-midhead"><h3>{category.name}</h3><a href={category.href}>Shop all <Arrow /></a></div><div className="pm-dd-groups"><CategoryGroups category={category} /></div></div>
            <div className="pm-dd-side"><a className="pm-dd-pic" href={category.href}><span><img src={category.picture} alt={category.name} loading="lazy" /></span><b>Shop all {category.name.toLowerCase()} <Arrow /></b></a>
              <a className="pm-dd-bulk" href={BULK_URL}><Building /><span><b>Ordering 100+ pieces?</b><small>Your logo · factory-direct bulk price</small></span><Arrow /></a>
            </div>
          </div>)}
          <a className="pm-dd-mbulk" href={BULK_URL}><Building />Ordering 100+? Get bulk price</a>
        </div>
      </div>
    </div>

  </header>;
}