"use client";

import { useEffect, useRef, useState } from "react";

type Subcategory = {
  id: string;
  name: string;
  slug: string;
};

type ShopNavDropdownProps = {
  category: {
    name: string;
    slug: string;
  };
  subcategories: Subcategory[];
};

export default function ShopNavDropdown({
  category,
  subcategories,
}: ShopNavDropdownProps) {
  const [open, setOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    function handleOutsideClick(event: MouseEvent) {
      if (
        dropdownRef.current &&
        !dropdownRef.current.contains(event.target as Node)
      ) {
        setOpen(false);
      }
    }

    document.addEventListener("mousedown", handleOutsideClick);

    return () => {
      document.removeEventListener("mousedown", handleOutsideClick);
    };
  }, []);

  return (
    <div
      ref={dropdownRef}
      className={`nav-dropdown${open ? " is-open" : ""}`}
    >
      <div className="nav-dropdown-trigger">
        <a href={`/shop/${category.slug}`}>
          {category.name.toUpperCase()}
        </a>

        <button
          type="button"
          className="nav-dropdown-toggle"
          aria-label={`Open ${category.name} menu`}
          aria-expanded={open}
          onClick={() => setOpen((current) => !current)}
        >
          <span aria-hidden="true">⌄</span>
        </button>
      </div>

      <div className="nav-dropdown-menu">
        <a href={`/shop/${category.slug}`} onClick={() => setOpen(false)}>
          All {category.name}
        </a>

        {subcategories.map((subcategory) => (
          <a
            key={subcategory.id}
            href={`/shop/${category.slug}/${subcategory.slug}`}
            onClick={() => setOpen(false)}
          >
            {subcategory.name}
          </a>
        ))}
      </div>
    </div>
  );
}
