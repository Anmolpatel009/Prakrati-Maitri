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
    let lastTime = performance.now();

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

    /*
     * Desktop behavior:
     * hovering the rail pauses automatic movement.
     */
    const handleMouseEnter = () => {
      pausedRef.current = true;
    };

    const handleMouseLeave = () => {
      pausedRef.current = false;
      lastTime = performance.now();
    };

    const initialFrame = requestAnimationFrame(() => {
      startAtMiddle();
      lastTime = performance.now();
      animationFrame = requestAnimationFrame(animate);
    });

    rail.addEventListener("pointerdown", handlePointerDown);
    rail.addEventListener("pointerup", handlePointerUp);
    rail.addEventListener("pointercancel", handlePointerCancel);

    rail.addEventListener("mouseenter", handleMouseEnter);
    rail.addEventListener("mouseleave", handleMouseLeave);

    return () => {
      cancelAnimationFrame(initialFrame);
      cancelAnimationFrame(animationFrame);

      rail.removeEventListener("pointerdown", handlePointerDown);
      rail.removeEventListener("pointerup", handlePointerUp);
      rail.removeEventListener("pointercancel", handlePointerCancel);

      rail.removeEventListener("mouseenter", handleMouseEnter);
      rail.removeEventListener("mouseleave", handleMouseLeave);
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
