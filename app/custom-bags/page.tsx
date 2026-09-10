import CustomBagForm from "@/components/shop/CustomBagForm";
import HomepagePromotionalBannerCarousel from "@/components/shop/HomepagePromotionalBannerCarousel";
import { getHomepageBanners } from "@/lib/shop/homepage-banners";

export const dynamic = "force-dynamic";

export default async function CustomBagsPage() {
  const homepageBanners = await getHomepageBanners();

  return (
    <main className="custom-bag-page">
      <section className="custom-bag-hero">
        <div className="custom-bag-hero-inner">
          <span className="custom-bag-eyebrow">
            MADE A LITTLE MORE YOURS
          </span>

          <h1>
            Your idea.
            <br />
            Your custom bag.
          </h1>

          <p>
            Have something specific in mind?
            Tell us what you&apos;re imagining and
            let&apos;s create a bag around your idea.
          </p>

          <a
            href="#custom-bag-form"
            className="custom-bag-hero-button"
          >
            Start Your Idea ↓
          </a>
        </div>

        <div className="custom-bag-hero-art">
          <HomepagePromotionalBannerCarousel
            banners={homepageBanners}
            variant="hero"
          />
        </div>
      </section>

      <section
        id="custom-bag-form"
        className="custom-bag-form-section"
      >
        <CustomBagForm />
      </section>

      <section className="custom-bag-bottom">
        <span className="custom-bag-eyebrow">
          FROM IDEA TO CREATION
        </span>

        <h2>
          You bring the idea.
          <br />
          We help shape it.
        </h2>

        <p>
          Whether it&apos;s a simple everyday bag, a thoughtful
          gift, a celebration piece or something completely
          your own — start by telling us what you want.
        </p>
      </section>
    </main>
  );
}
