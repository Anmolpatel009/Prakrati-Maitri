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
    const handleOutsideClick = (event: MouseEvent | TouchEvent) => {
      if (
        dropdownRef.current &&
        !dropdownRef.current.contains(event.target as Node)
      ) {
        setOpen(false);
      }
    };

    document.addEventListener("mousedown", handleOutsideClick);
    document.addEventListener("touchstart", handleOutsideClick);

    return () => {
      document.removeEventListener("mousedown", handleOutsideClick);
      document.removeEventListener("touchstart", handleOutsideClick);
    };
  }, []);

  return (
    <div
      ref={dropdownRef}
      className={`nav-dropdown${open ? " is-open" : ""}`}
    >
      <div className="nav-dropdown-trigger">
        <a
          href={`/shop/${category.slug}`}
          className="nav-dropdown-label"
        >
          {category.name.toUpperCase()}
        </a>

        <button
          type="button"
          className="nav-dropdown-toggle"
          aria-label={`Open ${category.name} submenu`}
          aria-expanded={open}
          onClick={(event) => {
            event.preventDefault();
            event.stopPropagation();
            setOpen((current) => !current);
          }}
        >
          <span aria-hidden="true">⌄</span>
        </button>
      </div>

      <div
        className="nav-dropdown-menu"
        aria-hidden={!open}
      >
        <a
          href={`/shop/${category.slug}`}
          onClick={() => setOpen(false)}
        >
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
