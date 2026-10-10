"use client";

import { useEffect, useRef } from "react";

type NavCard = {
  id: string;
  title: string;
  href: string | null;
  image_url: string | null;
};

type CategoryRailProps = {
  navCards: NavCard[];
};

export default function CategoryRail({ navCards }: CategoryRailProps) {
  const railRef = useRef<HTMLElement>(null);
  const pausedRef = useRef(false);
  const interactingRef = useRef(false);

  useEffect(() => {
    const rail = railRef.current;

    if (!rail || navCards.length === 0) {
      return;
    }

    let animationFrame = 0;
    let initialFrame = 0;
    let lastTime = performance.now();
    const mobileQuery = window.matchMedia("(max-width: 768px)");

    /*
     * Same visual speed as the previous 28s CSS animation,
     * but now the movement is controlled through scrollLeft.
     *
     * This allows:
     * 1. automatic movement
     * 2. native finger scrolling
     * 3. pause while touching
     * 4. automatic resume after release
     */
    const speed = 28;

    const getHalfWidth = () => {
      return rail.scrollWidth / 2;
    };

    const normalizePosition = () => {
      const halfWidth = getHalfWidth();

      if (halfWidth <= rail.clientWidth) {
        return;
      }

      /*
       * Because the cards are duplicated, the second half
       * is visually identical to the first half.
       */
      if (rail.scrollLeft >= halfWidth) {
        rail.scrollLeft -= halfWidth;
      } else if (rail.scrollLeft <= 0) {
        rail.scrollLeft += halfWidth;
      }
    };

    const startAtMiddle = () => {
      const halfWidth = getHalfWidth();

      if (halfWidth > rail.clientWidth) {
        rail.scrollLeft = halfWidth;
      }
    };

    const animate = (now: number) => {
      if (mobileQuery.matches) {
        animationFrame = 0;
        return;
      }

      const delta = Math.min(now - lastTime, 50);
      lastTime = now;

      if (!pausedRef.current && !interactingRef.current) {
        rail.scrollLeft += (speed * delta) / 1000;
        normalizePosition();
      }

      animationFrame = requestAnimationFrame(animate);
    };

    /*
     * Finger / touch interaction:
     * pause automatic movement while the user is interacting.
     * Native horizontal scrolling handles the actual finger drag.
     */
    const handlePointerDown = () => {
      interactingRef.current = true;
      lastTime = performance.now();
    };

    const handlePointerUp = () => {
      interactingRef.current = false;
      lastTime = performance.now();
    };

    const handlePointerCancel = () => {
      interactingRef.current = false;
      lastTime = performance.now();
    };

    const stopAnimation = () => {
      if (initialFrame) cancelAnimationFrame(initialFrame);
      if (animationFrame) cancelAnimationFrame(animationFrame);
      initialFrame = 0;
      animationFrame = 0;
    };

    const startAnimation = () => {
      if (mobileQuery.matches) {
        rail.scrollLeft = 0;
        return;
      }

      initialFrame = requestAnimationFrame(() => {
        initialFrame = 0;

        if (mobileQuery.matches) return;

        startAtMiddle();
        lastTime = performance.now();
        animationFrame = requestAnimationFrame(animate);
      });
    };

    const handleBreakpointChange = () => {
      stopAnimation();
      interactingRef.current = false;

      if (mobileQuery.matches) {
        rail.scrollLeft = 0;
      } else {
        startAnimation();
      }
    };

    startAnimation();
    mobileQuery.addEventListener("change", handleBreakpointChange);

    rail.addEventListener("pointerdown", handlePointerDown);
    rail.addEventListener("pointerup", handlePointerUp);
    rail.addEventListener("pointercancel", handlePointerCancel);

    return () => {
      cancelAnimationFrame(initialFrame);
      cancelAnimationFrame(animationFrame);

      rail.removeEventListener("pointerdown", handlePointerDown);
      rail.removeEventListener("pointerup", handlePointerUp);
      rail.removeEventListener("pointercancel", handlePointerCancel);
      mobileQuery.removeEventListener("change", handleBreakpointChange);

    };
  }, [navCards.length]);

  if (navCards.length === 0) {
    return null;
  }

  const cards = [...navCards, ...navCards];

  return (
    <section
      ref={railRef}
      className="category-rail"
      aria-label="Shop categories"
    >
      <div className="category-rail-track">
        {cards.map((card, index) => (
          <a
            key={`${card.id}-${index}`}
            href={card.href || "/shop"}
            className="category-circle-item"
          >
            <div className="category-circle">
              {card.image_url ? (
                <img
                  src={card.image_url}
                  alt={card.title}
                  loading="lazy"
                  draggable={false}
                />
              ) : (
                <span>✿</span>
              )}
            </div>

            <span>{card.title}</span>
          </a>
        ))}
      </div>
    </section>
  );
}
