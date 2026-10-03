export default function GlobalStorefrontFooter() {
  return (
    <footer className="shop-footer">
      <div className="footer-brand">
        <h3>PRAKRITI MAITRI</h3>
        <p>
          Thoughtful products for a more sustainable
          everyday.
        </p>
      </div>

      <div>
        <h4>Shop</h4>
        <a href="/shop">All Products</a>
        <a href="/shop?category=hand-bags">Hand Bags</a>
        <a href="/shop?category=packaging-bags">
          Packaging Bags
        </a>
        <a href="/shop?category=sample-kits">
          Sample Kits
        </a>
      </div>

      <div>
        <h4>Explore</h4>
        <a href="/our-story">Our Story</a>
        <a href="/reviews">Reviews</a>
        <a href="/contact">Contact</a>
      </div>

      <div>
        <h4>Customer Care</h4>
        <a href="/cart">Cart</a>
        <a href="/account">My Account</a>
        <a href="/shipping">Shipping</a>
      </div>
    </footer>
  );
}
