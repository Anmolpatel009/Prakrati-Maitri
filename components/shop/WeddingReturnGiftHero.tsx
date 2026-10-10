"use client";

import { useState, type FormEvent } from "react";
import styles from "./WeddingReturnGiftHero.module.css";

type WeddingReturnGiftHeroProps = {
  imageUrl?: string | null;
  collectionHref?: string;
};

const DEFAULT_BRIDE = "Ananya";
const DEFAULT_GROOM = "Rohan";
const DEFAULT_DATE_LABEL = "12 \u00B7 12 \u00B7 2026";

const GUEST_RANGES = ["50\u2013100", "100\u2013300", "300\u2013700", "700+"];
const RETURN_GIFTS = [
  "Jute hamper bag",
  "Potli bag",
  "Saree cover",
  "Printed jute tote",
  "Help me choose",
];

function formatTagDate(value: string) {
  if (!value) return DEFAULT_DATE_LABEL;
  const parts = value.split("-");
  if (parts.length !== 3) return DEFAULT_DATE_LABEL;
  return `${parts[2]} \u00B7 ${parts[1]} \u00B7 ${parts[0]}`;
}

export default function WeddingReturnGiftHero({
  imageUrl,
  collectionHref = "/shop/hamper-bags",
}: WeddingReturnGiftHeroProps) {
  const [bride, setBride] = useState("");
  const [groom, setGroom] = useState("");
  const [weddingDate, setWeddingDate] = useState("");
  const [guests, setGuests] = useState("100\u2013300");
  const [gift, setGift] = useState("Jute hamper bag");
  const [formNotice, setFormNotice] = useState("");

  const displayedBride = bride.trim() || DEFAULT_BRIDE;
  const displayedGroom = groom.trim() || DEFAULT_GROOM;

  function handleQuoteClick() {
    document.getElementById("pm-wed-quote")?.scrollIntoView({
      behavior: "smooth",
      block: "center",
    });
    window.setTimeout(() => {
      document.getElementById("pm-wed-bride")?.focus({ preventScroll: true });
    }, 450);
  }

  function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setFormNotice(
      "Your form is ready. Enquiry saving and Admin-panel management will be connected in the next phase; this form does not submit or store data yet.",
    );
  }

  return (
    <section className={styles["pm-wed"]} id="wedding-return-gifts" aria-labelledby="pm-wed-title">
      <svg className={styles["pm-wed-defs"]} aria-hidden="true" focusable="false">
        <defs>
          <clipPath id="pm-wed-arch" clipPathUnits="objectBoundingBox">
            <path d="M0,1 L0,.40 C0,.22 .17,.14 .30,.10 C.41,.065 .47,.035 .5,0 C.53,.035 .59,.065 .70,.10 C.83,.14 1,.22 1,.40 L1,1 Z" />
          </clipPath>
          <pattern id="pm-wed-toran-tile" width="64" height="44" patternUnits="userSpaceOnUse">
            <path d="M0 4 Q16 16 32 4 T64 4" fill="none" stroke="#C9952F" strokeWidth="1.4" />
            <g transform="translate(6 7)">
              <circle cx="10" cy="10" r="9" fill="#E8892B" />
              <circle cx="10" cy="10" r="6.2" fill="#F3A93B" />
              <circle cx="10" cy="10" r="3.4" fill="#F7C04F" />
              <circle cx="10" cy="10" r="1.3" fill="#B5561A" />
            </g>
            <path d="M48 10c-6 9-4 18 0 26 4-8 6-17 0-26z" fill="#5E6B4A" />
            <circle cx="48" cy="38" r="3" fill="#7A1E24" />
          </pattern>
        </defs>
      </svg>

      <svg className={styles["pm-wed-toran"]} aria-hidden="true" focusable="false">
  <defs>
    <pattern id="pm-wed-toran-repeat" width="64" height="44" patternUnits="userSpaceOnUse">
      <path d="M0 4 Q16 16 32 4 T64 4" fill="none" stroke="#C9952F" strokeWidth="1.4" />
      <circle cx="16" cy="16" r="9" fill="#E8892B" />
      <circle cx="16" cy="16" r="6.2" fill="#F3A93B" />
      <circle cx="16" cy="16" r="3.4" fill="#F7C04F" />
      <circle cx="16" cy="16" r="1.3" fill="#B5561A" />
      <path d="M48 10c-6 9-4 18 0 26 4-8 6-17 0-26z" fill="#5E6B4A" />
      <circle cx="48" cy="38" r="3" fill="#7A1E24" />
    </pattern>
  </defs>
  <rect width="100%" height="44" fill="url(#pm-wed-toran-repeat)" />
</svg>

      <div className={styles["pm-wed-in"]}>
        <div className={styles["pm-wed-copy"]}>
          <div className={styles["pm-wed-eyebrow"]}>Wedding season 2026</div>
          <h1 className={styles["pm-wed-h1"]} id="pm-wed-title">
            Our premium <em>Wedding Return Gift</em> collection
          </h1>
          <p className={styles["pm-wed-sub"]}>
            Elegant jute and cotton gift bags your guests will carry home and keep using. Printed with your names, wedding date or monogram.
          </p>
          <div className={styles["pm-wed-ctas"]}>
            <a className={`${styles["pm-wed-btn"]} ${styles["pm-wed-btn--solid"]}`} href={collectionHref}>
              Explore wedding gifts
            </a>
            <button
              className={`${styles["pm-wed-btn"]} ${styles["pm-wed-btn--line"]}`}
              type="button"
              onClick={handleQuoteClick}
            >
              Quote for my guest list
              <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 12h14M13 6l6 6-6 6" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" /></svg>
            </button>
          </div>
          <ul className={styles["pm-wed-points"]}>
            <li><svg viewBox="0 0 24 24" aria-hidden="true"><path d="m4 17 10-10 3 3-10 10-4 1zM13 8l3 3M17 4l3 3" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round" /></svg>Names &amp; date printed</li>
            <li><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 8h18v13H3zM2 5h20v4H2zM12 5v16M12 5C7 5 6 2 8 2c2 0 4 3 4 3zm0 0c5 0 6-3 4-3-2 0-4 3-4 3z" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinejoin="round" /></svg>Orders from 50 pieces</li>
            <li><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M2 6h12v11H2zM14 10h4l4 4v3h-8z" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinejoin="round" /><circle cx="6" cy="19" r="2" fill="none" stroke="currentColor" strokeWidth="1.6" /><circle cx="18" cy="19" r="2" fill="none" stroke="currentColor" strokeWidth="1.6" /></svg>PAN India delivery</li>
          </ul>
        </div>

        <div className={styles["pm-wed-art"]}>
          <div className={styles["pm-wed-mandap"]}>
            <div className={styles["pm-wed-mandap-clip"]}>
              {imageUrl ? (
                // The image comes from the existing active homepage hero media in the CMS.
                // eslint-disable-next-line @next/next/no-img-element
                <img src={imageUrl} alt="Jute wedding return gift bag with decorative folk-art print" />
              ) : (
                <div className={styles["pm-wed-image-fallback"]}>
                  <span>Wedding return gifts</span>
                  <small>Add the high-resolution bag photo in the homepage media settings.</small>
                </div>
              )}
            </div>
            <svg className={styles["pm-wed-rim"]} viewBox="0 0 100 100" preserveAspectRatio="none" aria-hidden="true">
              <path d="M0,100 L0,40 C0,22 17,14 30,10 C41,6.5 47,3.5 50,0 C53,3.5 59,6.5 70,10 C83,14 100,22 100,40 L100,100" fill="none" stroke="currentColor" strokeWidth="1.6" vectorEffect="non-scaling-stroke" />
            </svg>
          </div>
          <div className={styles["pm-wed-badge"]}>
            <span><b>50+</b><small>pieces<br />per order</small></span>
          </div>
          <div className={styles["pm-wed-tag"]} aria-live="polite">
            <small>Your names here</small>
            <b>{displayedBride} &amp; {displayedGroom}</b>
            <i>{formatTagDate(weddingDate)}</i>
          </div>
        </div>
      </div>

      <form className={styles["pm-wed-quote"]} id="pm-wed-quote" onSubmit={handleSubmit}>
        <svg className={`${styles["pm-wed-corner"]} ${styles["pm-wed-corner--l"]}`} viewBox="0 0 64 64" aria-hidden="true"><path d="M4 60V20C4 11 11 4 20 4h40M10 60V24c0-8 6-14 14-14h36" fill="none" stroke="currentColor" strokeWidth="1.4" /><circle cx="12" cy="12" r="3.5" fill="currentColor" /></svg>
        <svg className={`${styles["pm-wed-corner"]} ${styles["pm-wed-corner--r"]}`} viewBox="0 0 64 64" aria-hidden="true"><path d="M4 60V20C4 11 11 4 20 4h40M10 60V24c0-8 6-14 14-14h36" fill="none" stroke="currentColor" strokeWidth="1.4" /><circle cx="12" cy="12" r="3.5" fill="currentColor" /></svg>

        <div className={styles["pm-wed-quote-top"]}>
          <div className={styles["pm-wed-quote-head"]}>
            <h2 className={styles["pm-wed-script"]}>Plan your return gifts</h2>
            <p>Tell us about your wedding. We'll help with pricing, samples and printing options.</p>
          </div>
          <ul className={styles["pm-wed-ticks"]}>
            <li><span aria-hidden="true">&#10003;</span>From 50 pieces</li>
          </ul>
        </div>

        <div className={styles["pm-wed-fields"]}>
          <label className={styles["pm-wed-f-bride"]} htmlFor="pm-wed-bride">Bride's name
            <input id="pm-wed-bride" name="bride" placeholder="Ananya" autoComplete="off" maxLength={24} value={bride} onChange={(event) => { setBride(event.target.value); setFormNotice(""); }} required />
          </label>
          <span className={styles["pm-wed-amp"]} aria-hidden="true">&amp;</span>
          <label className={styles["pm-wed-f-groom"]} htmlFor="pm-wed-groom">Groom's name
            <input id="pm-wed-groom" name="groom" placeholder="Rohan" autoComplete="off" maxLength={24} value={groom} onChange={(event) => { setGroom(event.target.value); setFormNotice(""); }} required />
          </label>
          <label className={styles["pm-wed-f-date"]} htmlFor="pm-wed-date">Wedding date
            <input id="pm-wed-date" name="wedding_date" type="date" value={weddingDate} onChange={(event) => { setWeddingDate(event.target.value); setFormNotice(""); }} />
          </label>
          <label className={styles["pm-wed-f-guests"]} htmlFor="pm-wed-guests">Guests
            <select id="pm-wed-guests" name="guests" value={guests} onChange={(event) => { setGuests(event.target.value); setFormNotice(""); }}>
              {GUEST_RANGES.map((range) => <option key={range}>{range}</option>)}
            </select>
          </label>
          <label className={styles["pm-wed-f-gift"]} htmlFor="pm-wed-gift">Return gift
            <select id="pm-wed-gift" name="gift" value={gift} onChange={(event) => { setGift(event.target.value); setFormNotice(""); }}>
              {RETURN_GIFTS.map((option) => <option key={option}>{option}</option>)}
            </select>
          </label>
          <button className={`${styles["pm-wed-btn"]} ${styles["pm-wed-btn--solid"]} ${styles["pm-wed-go"]}`} type="submit">Get my quote <span aria-hidden="true">&#8594;</span></button>
        </div>
        <p className={styles["pm-wed-hint"]}>Type the couple's names to see them on the tag above.</p>
        {formNotice ? <p className={styles["pm-wed-notice"]} role="status" aria-live="polite">{formNotice}</p> : null}
      </form>
    </section>
  );
}
/* WEDDING TEXT ENCODING REPAIR V2 */
