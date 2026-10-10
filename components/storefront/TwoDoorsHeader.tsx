"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import CartBadge from "@/components/cart/CartBadge";
import type { NavbarCustomizationConfig, NavbarItem } from "@/lib/shop/navbar-customization";

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
type BulkTile = { name: string; note: string; img: string };
type Door = "shop" | "bulk";

const BULK_URL = "/bulk-order";
const BULK_TILES: BulkTile[] = [
  { name: "Canvas-Front Jute", note: "5 sizes", img: "/images/header/bulk-canvas-front-jute.webp" },
  { name: "Cotton Tote Bags", note: "150–350 GSM", img: "/images/header/menu-tote-thumb.webp" },
  { name: "Conference Bags", note: "Fits A4 files", img: "/images/header/bulk-conference-bags.webp" },
  { name: "Window Hampers", note: "4 sizes", img: "/images/header/menu-hamper-thumb.webp" },
  { name: "Drawstring Bags", note: "10 sizes", img: "/images/header/menu-packaging-thumb.webp" },
  { name: "Saree Covers", note: "Packs of 6 / 12 / 24", img: "/images/header/bulk-saree-covers.webp" },
  { name: "Jute Zipper Bags", note: "5 sizes", img: "/images/header/menu-hand-thumb.webp" },
  { name: "Natural Jute Hampers", note: "3 sizes", img: "/images/header/bulk-natural-jute-hampers.webp" },
  { name: "Checks Hampers", note: "3 colours", img: "/images/header/bulk-checks-hampers.webp" },
  { name: "Small Pouches", note: "Jewellery & favours", img: "/images/header/menu-packaging-thumb.webp" },
];

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

export default function TwoDoorsHeader({ navbarData, customization }: Props) {
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
    if (window.location.hash === "#bulk" || new URLSearchParams(window.location.search).get("door") === "bulk") setDoor("bulk");
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
    if (door !== "shop") {
      setDoor("shop");
      setOpenState(true);
      return;
    }
    setOpenState((current) => !current);
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
  const chooseBulk = () => { setDoor("bulk"); setOpenState(false); };

  return <header className="pm-hd" id="top">
    <div className="pm-hd-strip">
      <p className="pm-hd-strip-d">Free delivery over ₹100 order value</p>
      <p className="pm-hd-strip-m">Bulk orders · custom logo · PAN India delivery</p>
      <div className="pm-hd-strip-r"><a href={BULK_URL}>Bulk enquiries <Arrow /></a></div>
    </div>

    <div className="pm-hd-main">
      <button type="button" className="pm-hd-burger" aria-label="Open shop menu" onClick={() => { setDoor("shop"); setOpenState(true); }}>
        <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 7h16M4 12h16M4 17h16" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" /></svg>
      </button>
      <a className="pm-hd-logo" href="/shop" aria-label="Prakriti Maitri home">
        <span className="pm-hd-mark" aria-hidden="true"><img src="/prakrati-maitri-logo.jpg" alt="" /></span>
        <span className="pm-hd-name" style={{ color: "#4E3320" }}><b style={{ fontFamily: customization.brand_font_family, fontSize: `${Math.min(Math.max(customization.brand_font_size, 20), 32)}px`, fontWeight: customization.brand_font_weight, fontStyle: customization.brand_font_style, color: "#4E3320" }}>PRAKRITI MAITRI</b><small>Eco bags · Manufacturer</small></span>
      </a>
      <div className="pm-hd-doors" role="tablist" aria-label="Choose shopping experience">
        <button ref={shopButton} type="button" role="tab" id="pm-door-shop" aria-selected={door === "shop"} aria-expanded={open} aria-controls="pm-dd" onClick={clickShop}>
          <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 9l1.5-5h13L20 9M4 9v11h16V9M4 9h16M9 20v-6h6v6" fill="none" stroke="currentColor" strokeWidth="1.7" strokeLinejoin="round" /> </svg>
          Shop <svg className="pm-chev" viewBox="0 0 24 24" aria-hidden="true"><path d="M6 9l6 6 6-6" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" /></svg>
        </button>
        <button type="button" role="tab" id="pm-door-bulk" aria-selected={door === "bulk"} aria-controls="pm-bk" onClick={chooseBulk}><Building />Corporate &amp; Bulk</button>
      </div>
      <div className="pm-hd-icons">


        <a href="/cart" aria-label="Cart" className="pm-hd-cart"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 8h14l-1.2 12H6.2z" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinejoin="round" /><path d="M9 8V6a3 3 0 0 1 6 0v2" fill="none" stroke="currentColor" strokeWidth="1.8" /></svg><CartBadge /></a>
      </div>
    </div>

    <div className="pm-hd-shop" hidden={door !== "shop"}>
      <nav className="pm-hd-nav" aria-label="Shop categories"><ul>
        {/* NAV CLEANUP - REMOVE PREV AND REVIEWS */}
        {navRows.filter((row) => !["PREV", "REVIEWS"].includes(row.label.trim().toUpperCase())).map((row) => <li key={row.key}>
          {row.type === "category" && row.catKey ? <button type="button" className="pm-hd-navbtn" aria-controls="pm-dd" aria-expanded={open && active === row.catKey} onClick={() => clickCategory(row.catKey!)}>
            {row.label}<svg className="pm-nav-chev" viewBox="0 0 24 24" aria-hidden="true"><path d="M6 9l6 6 6-6" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" /></svg>
          </button> : <a href={row.href || "/shop"}>{row.label}</a>}
        </li>)}
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

    <div className="pm-bk" id="pm-bk" hidden={door !== "bulk"}>
      <div className="pm-bk-in"><div className="pm-bk-l">
        <div className="pm-bk-head"><h2>Branded bags for your business</h2><span>Bulk price on every product</span></div>
        <ul className="pm-bk-tiles">{BULK_TILES.map((tile) => <li key={tile.name}><a className="pm-bk-tile" href={`${BULK_URL}?source=header&product=${encodeURIComponent(tile.name)}`}>
          <span className="pm-bk-pic"><img src={tile.img} alt={tile.name} width={200} height={200} loading="lazy" /></span><b>{tile.name}</b><small>{tile.note}</small>
        </a></li>)}</ul>
      </div>
      <form className="pm-bk-form" action={BULK_URL} method="get">
        <input type="hidden" name="source" value="header" /><span className="pm-bk-eb">Bulk quote</span><h3>Tell us the bag, quantity and logo.</h3>
        <label className="pm-sr" htmlFor="pm-bk-product">Product</label><input id="pm-bk-product" name="product" placeholder="Product · e.g. canvas jute bag 14×16" required />
        <div className="pm-bk-row"><label className="pm-sr" htmlFor="pm-bk-qty">Quantity</label><input id="pm-bk-qty" name="quantity" type="number" min="1" inputMode="numeric" placeholder="Quantity" required />
          <label className="pm-sr" htmlFor="pm-bk-city">City</label><input id="pm-bk-city" name="city" placeholder="City" required /></div>
        <button type="submit">Get bulk price <Arrow /></button>
        <ul className="pm-bk-trust">
          <li><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 20V10l5 3V10l5 3V10l5 3V4h3v16z" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinejoin="round" /></svg>Direct manufacturer</li>
          <li><svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="9" fill="none" stroke="currentColor" strokeWidth="1.6" /><path d="M8 12.5l2.6 2.5L16 9.5" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" /></svg>Custom logo printing</li>
          <li><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M6 3h9l4 4v14H6zM14 3v5h5M9 12h7M9 16h7" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinejoin="round" /></svg>GST invoice</li>
          <li><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M2 6h11v10H2zM13 10h5l3 3v3h-8z" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinejoin="round" /><circle cx="6" cy="18" r="2" fill="none" stroke="currentColor" strokeWidth="1.6" /><circle cx="17" cy="18" r="2" fill="none" stroke="currentColor" strokeWidth="1.6" /></svg>PAN India delivery</li>
        </ul>
      </form></div>
    </div>
  </header>;
}