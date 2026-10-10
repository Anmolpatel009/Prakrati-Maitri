export default function OurStoryPage() {
  return (
    <main className="simple-content-page pm-story-page">
      <header className="pm-story-intro">
        <p className="simple-content-eyebrow">OUR STORY</p>
        <h1>More than a bag.<br />A choice for tomorrow.</h1>
        <p>
          We believe everyday products can be beautiful, useful and kinder to
          the world around us.
        </p>
        <p>
          Prakriti Maitri brings thoughtful, sustainable products into everyday
          moments &mdash; from shopping and gifting to celebrations and businesses.
        </p>
      </header>

      <section
        className="pm-story-founder-letter"
        aria-labelledby="pm-story-founder-title"
      >
        <div className="pm-story-letter-top">
          <span className="pm-story-letter-label">A NOTE FROM OUR FOUNDER</span>
          <span className="pm-story-year">EST. 2019</span>
        </div>

        <h2 id="pm-story-founder-title">Dear friend,</h2>

        <div className="pm-story-letter-copy">
          <p>
            I&rsquo;m Sajal Jain. I knew I wanted to build a business when I was
            in Class 8.
          </p>

          <p>
            In 2019, just before the lockdown, with the blessings of my Gurus,
            Acharya Bhagwan Shri 108 Vidyasagar Ji Maharaj and Shri 108
            Sudhasagar Ji Maharaj, I started Prakriti Maitri as a small startup.
          </p>

          <p>
            Step by step, we built our website, sold our bags in shops across
            different cities and registered our brand. One promise has stayed
            the same: every bag we make should be kept and used again, not
            thrown away.
          </p>

          <p>
            Whether you need 50 bags or 5,000, you speak to us directly.
          </p>
        </div>

        <div className="pm-story-signoff">
          <span className="pm-story-signature">&mdash; Sajal Jain</span>
          <span className="pm-story-founder-role">Founder, Prakriti Maitri</span>
        </div>
      </section>
    </main>
  );
}