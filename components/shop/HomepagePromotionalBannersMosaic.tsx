"use client";

import { useEffect, useState } from "react";
import styles from "./HomepagePromotionalBannersMosaic.module.css";
import type { DiwaliSaleMosaicConfig } from "@/lib/shop/diwali-sale-mosaic";

type PromotionalBanner = {
  id: string;
  slot: number;
  image_url: string;
  alt_text: string | null;
  destination_url: string | null;
  is_active: boolean;
};

type Slot = 1 | 2 | 3 | 4;

type Props = {
  banners: PromotionalBanner[];
  config: DiwaliSaleMosaicConfig;
};

type Countdown = {
  days: number;
  hours: number;
  minutes: number;
  seconds: number;
  expired: boolean;
};

const slots: Slot[] = [1, 2, 3, 4];

const slotClasses: Record<Slot, string> = {
  1: "slotHero",
  2: "slotCenter",
  3: "slotUpperRight",
  4: "slotLowerRight",
};

function DiyaIcon() {
  return (
    <svg className={styles.diya} viewBox="0 0 48 48" aria-hidden="true">
      <path d="M24 3c-5 6-5 10 0 13 5-3 5-7 0-13Z" fill="#1F6B67" />
      <path d="M24 9c-2 4-2 7 0 9 2-2 2-5 0-9Z" fill="#F4D58A" />
      <path d="M9 28c4 7 10 10 15 10s11-3 15-10H9Z" fill="#8B5A2B" />
      <path d="M6 27h36c-2 9-9 15-18 15S8 36 6 27Z" fill="#4E3320" />
      <path d="M13 31c6 3 16 3 22 0" fill="none" stroke="#E5D6BC" strokeWidth="1.5" strokeLinecap="round" />
      <path d="M24 20v5" stroke="#8B5A2B" strokeWidth="2" strokeLinecap="round" />
    </svg>
  );
}

function safeDestination(value: string | null): string | null {
  const candidate = value?.trim();
  if (!candidate) return null;
  if (candidate.startsWith("/") && !candidate.startsWith("//")) return candidate;
  if (/^https?:\/\//i.test(candidate)) return candidate;
  return null;
}

export default function HomepagePromotionalBannersMosaic({ banners, config }: Props) {
  const [countdown, setCountdown] = useState<Countdown | null>(null);
  const endTime = new Date(config.saleEnd).getTime();

  useEffect(() => {
    const tick = () => {
      const difference = endTime - Date.now();
      if (!Number.isFinite(endTime) || difference <= 0) {
        setCountdown({ days: 0, hours: 0, minutes: 0, seconds: 0, expired: true });
        return;
      }

      const totalSeconds = Math.floor(difference / 1000);
      setCountdown({
        days: Math.floor(totalSeconds / 86400),
        hours: Math.floor((totalSeconds % 86400) / 3600),
        minutes: Math.floor((totalSeconds % 3600) / 60),
        seconds: totalSeconds % 60,
        expired: false,
      });
    };

    tick();
    const timer = window.setInterval(tick, 1000);
    return () => window.clearInterval(timer);
  }, [endTime]);
  const bySlot = new Map<Slot, PromotionalBanner>();

  for (const banner of banners) {
    if (
      banner.is_active !== true ||
      !banner.image_url?.trim() ||
      ![1, 2, 3, 4].includes(banner.slot)
    ) continue;

    const slot = banner.slot as Slot;
    if (!bySlot.has(slot)) bySlot.set(slot, banner);
  }

  if (!config.enabled || bySlot.size === 0) return null;

  return (
    <section className={styles.section} aria-label="Homepage promotional banners">
      <div className={styles.inner}>
        <div className={styles.header}>
          <div className={styles.heading}>
            <DiyaIcon />
            <div>
              <span className={styles.eyebrow}>{config.eyebrow}</span>
              <h2 className={styles.title}>{config.title}</h2>
            </div>
          </div>

          <div className={styles.timerWrap}>
            {!(config.hideAfterEnd && countdown?.expired) && (
              <div className={styles.timer} aria-label="Time remaining in the Diwali sale">
                {[
                  { key: "days", label: "DAYS", value: countdown?.days },
                  { key: "hours", label: "HRS", value: countdown?.hours },
                  { key: "minutes", label: "MIN", value: countdown?.minutes },
                  { key: "seconds", label: "SEC", value: countdown?.seconds },
                ].map((unit) => (
                  <span className={styles.timerCell} key={unit.key}>
                    <b>{unit.value === undefined ? "--" : String(unit.value).padStart(2, "0")}</b>
                    <small>{unit.label}</small>
                  </span>
                ))}
              </div>
            )}
            <span className={styles.ends}>{config.endsText}</span>
          </div>
        </div>

        <div className={styles.grid}>
          {slots.map((slot) => {
            const banner = bySlot.get(slot);
            if (!banner) return null;

            const href = safeDestination(banner.destination_url);
            const className = styles.tile + " " + styles[slotClasses[slot]];
            const alt = banner.alt_text?.trim() || "";
            const image = (
              <img
                className={styles.image}
                src={banner.image_url}
                alt={alt}
                loading={slot === 1 ? "eager" : "lazy"}
                decoding="async"
              />
            );

            return href ? (
              <a
                key={banner.id}
                className={className + " " + styles.link}
                href={href}
                aria-label={alt || "View promotion " + slot}
              >
                {image}
              </a>
            ) : (
              <div key={banner.id} className={className}>
                {image}
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
