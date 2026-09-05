import type { StorefrontVideo } from "@/lib/shop/media";

type Props = {
  videos: StorefrontVideo[];
};

export default function AdvertisingVideoSection({
  videos,
}: Props) {
  if (videos.length === 0) {
    return null;
  }

  return (
    <section className="advertising-video-section">
      <div className="section-heading">
        <span className="section-eyebrow">
          FROM OUR WORLD
        </span>

        <h2>See what we’re creating</h2>

        <p>
          Discover our latest stories, campaigns and
          sustainable ideas.
        </p>
      </div>

      <div className="advertising-video-grid">
        {videos.map((video) => (
          <article
            className="advertising-video-card"
            key={video.id}
          >
            <div className="advertising-video-wrapper">
              <video
                src={video.file_url}
                poster={video.thumbnail_url || undefined}
                controls
                playsInline
                preload="metadata"
                aria-label={video.alt_text || video.title}
              />
            </div>

            <div className="advertising-video-content">
              <h3>{video.title}</h3>
            </div>
          </article>
        ))}
      </div>
    </section>
  );
}
