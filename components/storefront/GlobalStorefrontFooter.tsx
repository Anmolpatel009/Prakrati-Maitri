export default function GlobalStorefrontFooter() {
  return (
    <footer className="shop-footer pm-shop-footer" id="site-footer">
      <svg
        className="pm-foot-arch"
        viewBox="0 0 1440 60"
        preserveAspectRatio="none"
        aria-hidden="true"
      >
        <path d="M0 60 C 360 0, 1080 0, 1440 60 Z" fill="currentColor" />
      </svg>

      <div className="pm-foot-in">
        <div className="pm-foot-top">
          <div className="pm-foot-say">
            <span className="pm-foot-eyebrow">Friend of nature</span>
            <p className="pm-foot-line">
              Bags people keep, with your name on them.
            </p>

            <div className="pm-foot-news">
              <input
                type="email"
                placeholder="Your email"
                aria-label="Your email"
              />
              <button type="button">Subscribe</button>
            </div>
          </div>

          <nav className="pm-foot-col" aria-label="Shop">
            <h3>Shop</h3>
            <a href="/cotton-tote-bags">Tote bags</a>
            <a href="/printed-tote-bags">Printed totes · ₹249</a>
            <a href="/plain-jute-bags">Jute bags</a>
            <a href="/packaging-bags">Packaging bags</a>
            <a href="/cotton-drawstring-bags">Drawstring bags</a>
            <a href="/room-hamper-bags">Room hampers</a>
            <a href="/all-categories">All categories</a>
          </nav>

          <nav className="pm-foot-col" aria-label="Corporate and bulk">
            <h3>Corporate &amp; bulk</h3>
            <a href="/corporate-gifting">Corporate gifting</a>
            <a href="/wedding-return-gifts">Wedding return gifts</a>
            <a href="/conference-kits">Conference kits</a>
            <a href="/prabhavana-bags">Prabhavana &amp; mandir bags</a>
            <a href="/government-orders">Government &amp; GeM orders</a>
            <a href="/bulk-order">Custom bags</a>
          </nav>

          <nav className="pm-foot-col" aria-label="Company">
            <h3>Company</h3>
            <a href="/our-story">Our story</a>
            <a href="/our-factory">Our factory</a>
            <a href="/blog">Blog</a>
            <a href="/careers">Careers</a>
            <a href="/contact">Contact us</a>
          </nav>

          <div className="pm-foot-col">
            <h3>Visit or call</h3>

            <ul className="pm-foot-contact">
              <li>
                <svg className="pm-ic" viewBox="0 0 24 24" aria-hidden="true">
                  <path
                    d="M6.6 3.8 9 3l2.2 4.7-2 1.7a15.7 15.7 0 0 0 5.4 5.4l1.7-2 4.7 2.2-.8 2.4c-.4 1.2-1.6 1.9-2.8 1.7C10.1 17.9 6.1 13.9 4.9 7.6c-.2-1.2.5-2.4 1.7-2.8Z"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="1.5"
                  />
                </svg>
                <span>
                  <small>Call / WhatsApp</small>
                  <span>+91 XXXXX XXXXX</span>
                </span>
              </li>

              <li>
                <svg className="pm-ic" viewBox="0 0 24 24" aria-hidden="true">
                  <rect
                    x="3.5"
                    y="5.5"
                    width="17"
                    height="13"
                    rx="1.5"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="1.5"
                  />
                  <path
                    d="m4.5 7 7.5 5.5L19.5 7"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="1.5"
                  />
                </svg>
                <span>
                  <small>Email</small>
                  <a href="mailto:hello@prakritimaitri.com">
                    hello@prakritimaitri.com
                  </a>
                </span>
              </li>

              <li>
                <svg className="pm-ic" viewBox="0 0 24 24" aria-hidden="true">
                  <path
                    d="M12 21s6-6.1 6-11A6 6 0 0 0 6 10c0 4.9 6 11 6 11Z"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="1.5"
                  />
                  <circle
                    cx="12"
                    cy="10"
                    r="2"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="1.5"
                  />
                </svg>
                <span>
                  <small>Factory</small>
                  <span>[Address, City – PIN]</span>
                </span>
              </li>
            </ul>

            <div className="pm-foot-social" aria-label="Social links">
              <a href="https://www.instagram.com/prakritimaitri/" aria-label="Instagram">◎</a>
              <a href="#" aria-label="Facebook">f</a>
              <a href="#" aria-label="LinkedIn">in</a>
              <a href="#" aria-label="YouTube">▶</a>
              <a href="#" aria-label="WhatsApp">◔</a>
            </div>
          </div>
        </div>

        <p className="pm-foot-word" lang="hi">
          प्रकृति मैत्री
        </p>

        <p className="pm-foot-en">
          Prakriti Maitri · friend of nature
        </p>

        <div className="pm-foot-bottom">
          <span>© 2026 Prakriti Maitri · GSTIN [GSTIN]</span>

          <nav className="pm-foot-legal" aria-label="Policies">
            <a href="/privacy-policy">Privacy policy</a>
            <a href="/terms">Terms</a>
            <a href="/refund-policy">Refund policy</a>
            <a href="/shipping-policy">Shipping policy</a>
          </nav>

          <ul className="pm-foot-pay" aria-label="Payment methods">
            <li>UPI</li>
            <li>RuPay</li>
            <li>Visa</li>
            <li>Mastercard</li>
            <li>Net banking</li>
          </ul>
        </div>
      </div>
    </footer>
  );
}
