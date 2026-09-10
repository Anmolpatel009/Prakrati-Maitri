"use client";

import { createPortal } from "react-dom";
import {
  useCallback,
  useEffect,
  useRef,
  useState,
} from "react";
import type { CSSProperties } from "react";

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
  const [menuPosition, setMenuPosition] = useState({
    top: 0,
    left: 12,
  });

  const dropdownRef = useRef<HTMLDivElement>(null);
  const toggleRef = useRef<HTMLButtonElement>(null);
  const mobileMenuRef = useRef<HTMLDivElement>(null);

  const updateMenuPosition = useCallback(() => {
    const button = toggleRef.current;

    if (!button) {
      return;
    }

    const rect = button.getBoundingClientRect();

    const menuWidth = Math.min(
      260,
      Math.max(210, window.innerWidth - 24)
    );

    let left = rect.left;

    if (left + menuWidth > window.innerWidth - 12) {
      left = window.innerWidth - menuWidth - 12;
    }

    left = Math.max(12, left);

    setMenuPosition({
      top: Math.round(rect.bottom + 8),
      left: Math.round(left),
    });
  }, []);

  useEffect(() => {
    const handleOutside = (event: MouseEvent | TouchEvent) => {
      const target = event.target as Node;

      const insideDropdown =
        dropdownRef.current?.contains(target) ?? false;

      const insideMobileMenu =
        mobileMenuRef.current?.contains(target) ?? false;

      if (!insideDropdown && !insideMobileMenu) {
        setOpen(false);
      }
    };

    const handleEscape = (event: KeyboardEvent) => {
      if (event.key === "Escape") {
        setOpen(false);
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
  }, []);

  useEffect(() => {
    if (!open) {
      return;
    }

    updateMenuPosition();

    const update = () => {
      updateMenuPosition();
    };

    window.addEventListener("resize", update);
    window.addEventListener("scroll", update, true);

    return () => {
      window.removeEventListener("resize", update);
      window.removeEventListener("scroll", update, true);
    };
  }, [open, updateMenuPosition]);

  const mobileMenuStyle = {
    "--nav-dropdown-top": `${menuPosition.top}px`,
    "--nav-dropdown-left": `${menuPosition.left}px`,
  } as CSSProperties;

  const menuContent = (
    <>
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
    </>
  );

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
          ref={toggleRef}
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

      {/* Desktop dropdown */}
      <div className="nav-dropdown-menu nav-dropdown-menu-desktop">
        {menuContent}
      </div>

      {/* Mobile dropdown is rendered outside the scrolling navbar */}
      {open &&
        typeof document !== "undefined" &&
        createPortal(
          <div
            ref={mobileMenuRef}
            className="nav-dropdown-menu-mobile"
            style={mobileMenuStyle}
          >
            {menuContent}
          </div>,
          document.body
        )}
    </div>
  );
}
