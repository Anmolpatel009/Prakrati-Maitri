"use client";

import {
  useEffect,
  useRef,
  useState,
} from "react";
import type { TouchEvent } from "react";
import type { StorefrontVideo } from "@/lib/shop/media";

type Props = {
  videos: StorefrontVideo[];
};

export default function AdvertisingVideoSection({
  videos,
}: Props) {
  const [activeIndex, setActiveIndex] = useState(0);
  const [lightboxOpen, setLightboxOpen] = useState(false);
  const [isPaused, setIsPaused] = useState(false);

  const inlineVideoRef =
    useRef<HTMLVideoElement | null>(null);

  const lightboxVideoRef =
    useRef<HTMLVideoElement | null>(null);

  const touchStartRef =
    useRef<{ x: number; y: number } | null>(null);

  const activeVideo =
    videos[activeIndex] ?? null;

  function posterFor(video: StorefrontVideo): string {
    return (
      video.thumbnail_url ||
      `/storefront-video-posters/${video.id}.jpg`
    );
  }

  useEffect(() => {
    const video = inlineVideoRef.current;

    if (!video || !activeVideo || lightboxOpen) {
      return;
    }

    video.muted = true;
    video.currentTime = 0;

    const promise = video.play();

    if (promise) {
      promise
        .then(() => setIsPaused(false))
        .catch(() => setIsPaused(true));
    }
  }, [
    activeIndex,
    activeVideo,
    lightboxOpen,
  ]);

  useEffect(() => {
    if (!lightboxOpen) {
      return;
    }

    const video = lightboxVideoRef.current;

    if (!video) {
      return;
    }

    video.currentTime = 0;
    video.muted = false;

    const promise = video.play();

    if (promise) {
      promise.catch(() => {
        video.muted = true;
        video.play().catch(() => {});
      });
    }
  }, [
    activeIndex,
    lightboxOpen,
  ]);

  useEffect(() => {
    if (!lightboxOpen) {
      return;
    }

    const previousOverflow =
      document.body.style.overflow;

    document.body.style.overflow = "hidden";

    return () => {
      document.body.style.overflow =
        previousOverflow;
    };
  }, [lightboxOpen]);

  useEffect(() => {
    if (!lightboxOpen) {
      return;
    }

    const handleKeyDown = (
      event: KeyboardEvent
    ) => {
      if (event.key === "Escape") {
        setLightboxOpen(false);
        return;
      }

      if (event.key === "ArrowLeft") {
        setActiveIndex((current) =>
          videos.length
            ? (current - 1 + videos.length) %
              videos.length
            : 0
        );
      }

      if (event.key === "ArrowRight") {
        setActiveIndex((current) =>
          videos.length
            ? (current + 1) % videos.length
            : 0
        );
      }
    };

    document.addEventListener(
      "keydown",
      handleKeyDown
    );

    return () => {
      document.removeEventListener(
        "keydown",
        handleKeyDown
      );
    };
  }, [lightboxOpen, videos.length]);

  if (videos.length === 0) {
    return null;
  }

  function goTo(index: number) {
    setActiveIndex(
      (index + videos.length) % videos.length
    );
    setIsPaused(false);
  }

  function previous() {
    goTo(activeIndex - 1);
  }

  function next() {
    goTo(activeIndex + 1);
  }

  function openLightbox() {
    inlineVideoRef.current?.pause();
    setLightboxOpen(true);
  }

  function closeLightbox() {
    lightboxVideoRef.current?.pause();
    setLightboxOpen(false);
  }

  function handleTouchStart(
    event: TouchEvent<HTMLDivElement>
  ) {
    const touch = event.touches[0];

    if (!touch) {
      return;
    }

    touchStartRef.current = {
      x: touch.clientX,
      y: touch.clientY,
    };
  }

  function handleTouchEnd(
    event: TouchEvent<HTMLDivElement>
  ) {
    const start = touchStartRef.current;
    const touch = event.changedTouches[0];

    touchStartRef.current = null;

    if (!start || !touch) {
      return;
    }

    const dx = touch.clientX - start.x;
    const dy = touch.clientY - start.y;

    if (
      Math.abs(dx) > 40 &&
      Math.abs(dx) > Math.abs(dy)
    ) {
      if (dx < 0) {
        next();
      } else {
        previous();
      }
    }
  }

  function getOffset(index: number) {
    let offset =
      ((index - activeIndex) % videos.length) +
      videos.length;

    offset %= videos.length;

    if (offset > videos.length / 2) {
      offset -= videos.length;
    }

    return offset;
  }

  return (
    <section className="advertising-video-section pm-vid-redesign">
      <div className="advertising-video-heading section-heading">
        <span className="section-eyebrow">
          WATCH &amp; SHOP
        </span>

        <h2>See our bags in action</h2>

        <p>
          Short clips from our factory and from real
          orders. Tap a video to see the bag and ask
          for a bulk quote.
        </p>

        <a
          className="pm-vid-instagram"
          href="https://www.instagram.com/prakritimaitri/"
          target="_blank"
          rel="noopener noreferrer"
        >
          <span className="pm-vid-instagram-icon">
            ◎
          </span>

          <span>
            <strong>
              @prakritimaitri
            </strong>

            <small>
              Follow us on Instagram
            </small>
          </span>
        </a>
      </div>

      <div
        className="pm-vid-stage"
        onTouchStart={handleTouchStart}
        onTouchEnd={handleTouchEnd}
      >
        <button
          type="button"
          className="pm-vid-carousel-arrow pm-vid-carousel-arrow-prev"
          aria-label="Previous video"
          onClick={previous}
        >
          ‹
        </button>

        <div className="pm-vid-track">
          {videos.map((video, index) => {
            const offset = getOffset(index);
            const distance = Math.abs(offset);

            const scale =
              distance === 0
                ? 1
                : distance === 1
                  ? 0.78
                  : 0.6;

            const translate =
              offset *
              (distance === 2
                ? 220
                : 250);

            const opacity =
              distance === 0
                ? 1
                : distance === 1
                  ? 0.8
                  : distance === 2
                    ? 0.45
                    : 0;

            const isCenter =
              offset === 0;

            return (
              <article
                key={video.id}
                className={`pm-vid-item ${
                  isCenter
                    ? "is-center"
                    : ""
                }`}
                style={{
                  transform:
                    `translate(-50%, -50%) ` +
                    `translateX(${translate}px) ` +
                    `scale(${scale})`,
                  opacity,
                  pointerEvents:
                    distance <= 2
                      ? "auto"
                      : "none",
                  zIndex:
                    10 - distance,
                  filter:
                    distance === 0
                      ? "none"
                      : "saturate(.7)",
                }}
                aria-hidden={
                  distance > 2
                }
              >
                <button
                  type="button"
                  className="pm-vid-card"
                  aria-label={
                    isCenter
                      ? `Open video: ${video.title}`
                      : `Select video: ${video.title}`
                  }
                  onClick={() => {
                    if (isCenter) {
                      openLightbox();
                    } else {
                      goTo(index);
                    }
                  }}
                >
                  {isCenter ? (
                    <video
                      ref={inlineVideoRef}
                      key={`${video.id}-${activeIndex}`}
                      src={video.file_url}
                      poster={posterFor(video)}
                      muted
                      loop
                      playsInline
                      preload="none"
                      onPlaying={() =>
                        setIsPaused(false)
                      }
                      onPause={() =>
                        setIsPaused(true)
                      }
                      aria-label={
                        video.alt_text ||
                        video.title
                      }
                    />
                  ) : (
                    <img
                      src={posterFor(video)}
                      alt=""
                      width={432}
                      height={768}
                      loading="lazy"
                      decoding="async"
                      draggable={false}
                      aria-hidden="true"
                    />
                  )}

                  <span className="pm-vid-tag">
                    {video.title}
                  </span>

                  <span className="pm-vid-duration">
                    ▶
                  </span>

                  {isCenter &&
                    isPaused && (
                      <span className="pm-vid-play-overlay">
                        <span>▶</span>
                      </span>
                    )}
                </button>
              </article>
            );
          })}
        </div>

        <button
          type="button"
          className="pm-vid-carousel-arrow pm-vid-carousel-arrow-next"
          aria-label="Next video"
          onClick={next}
        >
          ›
        </button>
      </div>

      <div
        className="pm-vid-dots"
        role="group"
        aria-label="Choose a video"
      >
        {videos.map((video, index) => (
          <button
            key={video.id}
            type="button"
            className={
              index === activeIndex
                ? "pm-vid-dot is-active"
                : "pm-vid-dot"
            }
            aria-label={`Video ${
              index + 1
            }: ${video.title}`}
            aria-current={
              index === activeIndex
                ? "true"
                : undefined
            }
            onClick={() =>
              goTo(index)
            }
          />
        ))}
      </div>

      <div
        className="pm-vid-info"
        aria-live="polite"
      >
        <h3>
          {activeVideo?.title}
        </h3>

        <a
          className="pm-vid-btn pm-vid-btn-dark"
          href={`/bulk-order?interest=${encodeURIComponent(
            activeVideo?.title || ""
          )}`}
        >
          Get a bulk quote →
        </a>
      </div>

      {lightboxOpen &&
        activeVideo && (
          <div
            className="pm-vid-lightbox"
            role="presentation"
            onMouseDown={(event) => {
              if (
                event.target ===
                event.currentTarget
              ) {
                closeLightbox();
              }
            }}
          >
            <div
              className="pm-vid-lightbox-panel"
              role="dialog"
              aria-modal="true"
              aria-labelledby="pm-vid-lightbox-title"
            >
              <button
                type="button"
                className="pm-vid-lightbox-close"
                aria-label="Close video"
                onClick={closeLightbox}
              >
                ×
              </button>

              <div className="pm-vid-lightbox-video">
                <video
                  ref={lightboxVideoRef}
                  key={`lightbox-${activeVideo.id}`}
                  src={activeVideo.file_url}
                  poster={posterFor(activeVideo)}
                  controls
                  playsInline
                  loop
                />

                <button
                  type="button"
                  className="pm-vid-lightbox-nav pm-vid-lightbox-prev"
                  aria-label="Previous video"
                  onClick={previous}
                >
                  ‹
                </button>

                <button
                  type="button"
                  className="pm-vid-lightbox-nav pm-vid-lightbox-next"
                  aria-label="Next video"
                  onClick={next}
                >
                  ›
                </button>
              </div>

              <div className="pm-vid-lightbox-details">
                <span className="pm-vid-lightbox-eyebrow">
                  WATCH &amp; SHOP
                </span>

                <h3 id="pm-vid-lightbox-title">
                  {activeVideo.title}
                </h3>

                <div className="pm-vid-lightbox-actions">
                  <a
                    className="pm-vid-btn pm-vid-btn-dark"
                    href={`/bulk-order?interest=${encodeURIComponent(
                      activeVideo.title
                    )}`}
                  >
                    Get a bulk quote →
                  </a>

                  {process.env
                    .NEXT_PUBLIC_WHATSAPP_NUMBER && (
                    <a
                      className="pm-vid-btn pm-vid-btn-whatsapp"
                      href={`https://wa.me/${process.env.NEXT_PUBLIC_WHATSAPP_NUMBER.replace(
                        /\D/g,
                        ""
                      )}?text=${encodeURIComponent(
                        `Hi Prakriti Maitri, I saw your video "${activeVideo.title}" on your website.`
                      )}`}
                      target="_blank"
                      rel="noopener noreferrer"
                    >
                      Ask on WhatsApp
                    </a>
                  )}
                </div>

                <a
                  className="pm-vid-lightbox-instagram"
                  href="https://www.instagram.com/prakritimaitri/"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  ◎ Watch more on Instagram
                </a>
              </div>
            </div>
          </div>
        )}
    </section>
  );
}
