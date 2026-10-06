"use client";

import { useEffect, useState } from "react";

type ShopMode = "shop" | "bulk";

const STORAGE_KEY = "pm_door";

export default function ShopModeSwitcher() {
  const [mode, setMode] = useState<ShopMode>("shop");

  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const queryMode = params.get("door");

    if (queryMode === "bulk" || queryMode === "shop") {
      setMode(queryMode);
      localStorage.setItem(STORAGE_KEY, queryMode);
      return;
    }

    const storedMode = localStorage.getItem(STORAGE_KEY);

    if (storedMode === "bulk" || storedMode === "shop") {
      setMode(storedMode);
    }
  }, []);

  function selectMode(nextMode: ShopMode) {
    setMode(nextMode);
    localStorage.setItem(STORAGE_KEY, nextMode);

    window.dispatchEvent(
      new CustomEvent("pm:door", {
        detail: { door: nextMode },
      }),
    );

    const url = new URL(window.location.href);

    if (nextMode === "bulk") {
      url.pathname = "/shop";
      url.searchParams.set("door", "bulk");
    } else {
      url.pathname = "/shop";
      url.searchParams.delete("door");
    }

    window.location.href = url.toString();
  }

  return (
    <div
      className="pm-doors"
      role="tablist"
      aria-label="Choose how you want to buy"
    >
      <button
        className="pm-door"
        type="button"
        role="tab"
        aria-selected={mode === "shop"}
        onClick={() => selectMode("shop")}
      >
        Shop
      </button>

      <button
        className="pm-door"
        type="button"
        role="tab"
        aria-selected={mode === "bulk"}
        onClick={() => selectMode("bulk")}
      >
        Corporate & Bulk
      </button>
    </div>
  );
}