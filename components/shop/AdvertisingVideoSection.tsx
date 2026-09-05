"use client";

import { useRef } from "react";
import type { StorefrontVideo } from "@/lib/shop/media";

type Props = {
  videos: StorefrontVideo[];
};

export default function AdvertisingVideoSection({
  videos,
}: Props) {
  const videoRefs = useRef<Record<string, HTMLVideoElement | null>>(
    {}
  );

  if (videos.length === 0) {
    return null;
  }

  function playVideo(id: string) {
    const video = videoRefs.current[id];

    if (!video) return;

    video.muted = true;
    video.play().catch(() => {
      // Browser may block autoplay in some circumstances.
    });
  }

  function stopVideo(id: string) {
    const video = videoRefs.current[id];

    if (!video) return;

    video.pause();
    video.currentTime = 0;
  }

  function toggleMobileVideo(id: string) {
    const video = videoRefs.current[id];

    if (!video) return;

    if (video.paused) {
      video.muted = true;
      video.play().catch(() => {});
    } else {
      video.pause();
    }
  }

  function scrollVideos(direction: "left" | "right") {
    const container = document.querySelector(
      ".advertising-video-track-container"
    );

    if (!container) return;

    const amount =
      container.clientWidth *
      (window.innerWidth <= 768 ? 0.82 : 0.92);

    container.scrollBy({
      left: direction === "left" ? -amount : amount,
      behavior: "smooth",
    });
  }

  return (
    <section className="advertising-video-section">
      <div className="section-heading advertising-video-heading">
        <span className="section-eyebrow">
          FROM OUR WORLD
        </span>

        <h2>See what we’re creating</h2>

        <p>
          Discover our latest stories, campaigns and
          sustainable ideas.
        </p>
      </div>

      <div className="advertising-video-carousel">
        <button
          type="button"
          className="advertising-video-arrow advertising-video-arrow-left"
          aria-label="Previous videos"
          onClick={() => scrollVideos("left")}
        >
          ‹
        </button>

        <div className="advertising-video-track-container">
          <div className="advertising-video-track">
            {videos.map((video) => (
              <article
                className="advertising-video-card"
                key={video.id}
              >
                <div
                  className="advertising-video-wrapper"
                  onMouseEnter={() => playVideo(video.id)}
                  onMouseLeave={() => stopVideo(video.id)}
                  onClick={() => toggleMobileVideo(video.id)}
                >
                  <video
                    ref={(element) => {
                      videoRefs.current[video.id] = element;
                    }}
                    src={video.file_url}
                    poster={video.thumbnail_url || undefined}
                    playsInline
                    muted
                    loop
                    preload="metadata"
                    aria-label={
                      video.alt_text || video.title
                    }
                  />
                </div>

                <div className="advertising-video-content">
                  <h3>{video.title}</h3>
                </div>
              </article>
            ))}
          </div>
        </div>

        <button
          type="button"
          className="advertising-video-arrow advertising-video-arrow-right"
          aria-label="Next videos"
          onClick={() => scrollVideos("right")}
        >
          ›
        </button>
      </div>
    </section>
  );
}
