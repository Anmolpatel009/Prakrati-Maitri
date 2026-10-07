"use client";

import { FormEvent, useEffect, useMemo, useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";

type Category = {
  id: string;
  name: string;
};

type Product = {
  id: string;
  name: string;
  slug: string;
  category_id: string | null;
};

type Props = {
  categories: Category[];
  products: Product[];
};

const TIMELINE_OPTIONS = [
  {
    value: "urgent",
    title: "Urgent",
    subtitle: "as soon as possible",
  },
  {
    value: "within_7_days",
    title: "Within a week",
    subtitle: "7 days",
  },
  {
    value: "within_15_days",
    title: "Within 15 days",
    subtitle: "2 weeks",
  },
  {
    value: "flexible",
    title: "Flexible",
    subtitle: "more than 15 days",
  },
] as const;

const PLANNING_OPTIONS = [
  "Tote Bags",
  "Printed Tote Bags",
  "Conference Bags & Kits",
  "Customize Bags",
  "Hamper Bags",
  "Hand Bags",
  "Packaging Bags",
  "Not sure yet",
] as const;

const PURPOSE_OPTIONS = [
  "Corporate gifting",
  "Business use",
  "Events",
  "Event or conference",
  "Retail or shop packaging",
  "Promotion or branding",
  "Wedding or festive",
  "Other",
];

function makeInitialForm() {
  return {
    name: "",
    mobile: "",
    email: "",
    businessName: "",
    categoryId: "",
    productId: "",
    quantity: "",
    purpose: "",
    message: "",
    bagSize: "",
    deliveryPincode: "",
    deliveryTimeline: "",
  };
}

export default function BulkOrderForm({ categories, products }: Props) {
  const router = useRouter();
  const searchParams = useSearchParams();
  const preselectedProductId = searchParams.get("product");

  const [form, setForm] = useState(makeInitialForm);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [success, setSuccess] = useState(false);
  const [referenceImage, setReferenceImage] = useState<File | null>(null);
  const [moreOpen, setMoreOpen] = useState(false);

  useEffect(() => {
    if (!preselectedProductId) return;

    const product = products.find(
      (item) => item.id === preselectedProductId
    );

    if (!product) return;

    setForm((current) => ({
      ...current,
      categoryId: product.category_id ?? "",
      productId: product.id,
    }));

    setMoreOpen(true);
  }, [preselectedProductId, products]);

  const filteredProducts = useMemo(() => {
    if (!form.categoryId) return products;

    return products.filter(
      (product) => product.category_id === form.categoryId
    );
  }, [products, form.categoryId]);

  function updateField(
    field: Exclude<keyof typeof form, "planning">,
    value: string
  ) {
    setForm((current) => ({
      ...current,
      [field]: value,
    }));
  }

  const [notSureSelected, setNotSureSelected] = useState(false);

  function handleNotSureSelection() {
    setNotSureSelected((current) => !current);
    setForm((current) => ({
      ...current,
      categoryId: "",
      productId: "",
    }));
    setMoreOpen(true);

    window.setTimeout(() => {
      document.getElementById("bulk-category")?.focus();
    }, 0);
  }

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setError("");

    if (!form.name.trim()) {
      setError("Please enter your name.");
      return;
    }

    const mobileDigits = form.mobile.replace(/\D/g, "");
    if (!/^[6-9]\d{9}$/.test(mobileDigits)) {
      setError("Please enter a valid 10-digit mobile number.");
      return;
    }

    if (!form.quantity || Number(form.quantity) <= 0) {
      setError("Please enter the expected quantity.");
      return;
    }

    if (!form.categoryId && !form.productId) {
      setError(
        "Please select a category or product in Add more details for an accurate quote."
      );
      setMoreOpen(true);
      return;
    }

    if (!form.purpose.trim()) {
      setError("Please tell us the purpose of your bulk purchase.");
      setMoreOpen(true);
      return;
    }

    if (
      form.deliveryPincode.trim() &&
      !/^\d{6}$/.test(form.deliveryPincode.trim())
    ) {
      setError("Please enter a valid 6-digit delivery pincode.");
      setMoreOpen(true);
      return;
    }

    if (
      form.email.trim() &&
      !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email.trim())
    ) {
      setError("Please enter a valid email address.");
      setMoreOpen(true);
      return;
    }

    if (referenceImage) {
      const allowedTypes = [
        "image/jpeg",
        "image/png",
        "image/webp",
      ];

      if (!allowedTypes.includes(referenceImage.type)) {
        setError("Reference image must be JPG, PNG or WebP.");
        setMoreOpen(true);
        return;
      }

      if (referenceImage.size > 5 * 1024 * 1024) {
        setError("Reference image must be smaller than 5MB.");
        setMoreOpen(true);
        return;
      }
    }

    setLoading(true);

    try {
      let referenceImagePath: string | null = null;

      if (referenceImage) {
        const extensionByType: Record<string, string> = {
          "image/jpeg": "jpg",
          "image/png": "png",
          "image/webp": "webp",
        };

        const extension = extensionByType[referenceImage.type];

        referenceImagePath =
          `bulk-orders/${crypto.randomUUID()}.${extension}`;

        const uploadResponse = await fetch(
          "/api/bulk-order/reference-upload",
          {
            method: "POST",
            headers: {
              "Content-Type": referenceImage.type,
              "x-file-path": referenceImagePath,
            },
            body: referenceImage,
          }
        );

        const uploadResult = await uploadResponse.json();

        if (!uploadResponse.ok) {
          throw new Error(
            uploadResult.error || "Unable to upload reference image."
          );
        }

        referenceImagePath =
          uploadResult.path || referenceImagePath;
      }

      const response = await fetch("/api/bulk-order", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          ...form,
          mobile: `+91${mobileDigits}`,
          message: form.message.trim() || null,
          referenceImagePath,
        }),
      });

      const result = await response.json();

      if (!response.ok) {
        throw new Error(
          result.error || "Unable to submit enquiry."
        );
      }

      setSuccess(true);
      router.refresh();
    } catch (submitError) {
      setError(
        submitError instanceof Error
          ? submitError.message
          : "Unable to submit enquiry."
      );
    } finally {
      setLoading(false);
    }
  }

  function resetForm() {
    setForm(makeInitialForm());
    setReferenceImage(null);
    setError("");
    setSuccess(false);
    setMoreOpen(false);
    setNotSureSelected(false);
  }

  const whatsappText = encodeURIComponent(
    [
      "Hi Prakriti Maitri, I would like a bulk quote.",
      form.name && `Name: ${form.name}`,
      form.mobile && `Mobile: +91 ${form.mobile.replace(/\D/g, "")}`,
      form.quantity && `Quantity: ${form.quantity}`,
      form.bagSize && `Bag size: ${form.bagSize}`,
      form.deliveryPincode && `Pincode: ${form.deliveryPincode}`,
      form.deliveryTimeline &&
        `Needed: ${
          TIMELINE_OPTIONS.find(
            (item) => item.value === form.deliveryTimeline
          )?.title ?? form.deliveryTimeline
        }`,
      form.purpose && `Purpose: ${form.purpose}`,
      form.businessName && `Business: ${form.businessName}`,
      form.message && `Notes: ${form.message}`,
    ]
      .filter(Boolean)
      .join("\n")
  );

  const whatsappHref = `https://wa.me/919232040020?text=${whatsappText}`;

  if (success) {
    return (
      <div className="bulk-order-reference-form-state">
        <div className="bulk-order-reference-success-icon" aria-hidden="true">
          ✓
        </div>
        <h2>Thank you{form.name ? `, ${form.name.split(/\s+/)[0]}` : ""}</h2>
        <p>
          Your bulk enquiry is in. Our team will connect with you on call or
          WhatsApp.
        </p>

        <a
          href={whatsappHref}
          target="_blank"
          rel="noopener noreferrer"
          className="bulk-order-reference-whatsapp"
        >
          Chat with us on WhatsApp
        </a>

        <button
          type="button"
          className="bulk-order-reference-link"
          onClick={resetForm}
        >
          Send another enquiry
        </button>
      </div>
    );
  }

  return (
    <form
      className="bulk-order-reference-form"
      onSubmit={handleSubmit}
      noValidate
    >
      <div className="bulk-order-reference-form-heading">
        <h2 id="bulk-order-quote-title">Get a bulk quote</h2>
        <p>Three quick details. Our team will connect with you.</p>
      </div>

      <fieldset>
        <legend className="bulk-order-reference-label">
          What are you planning? <span>optional</span>
        </legend>

        <div className="bulk-order-reference-tiles">
          {PLANNING_OPTIONS.map((option) => {
            const isNotSure = option === "Not sure yet";
            const checked = isNotSure
              ? notSureSelected
              : false;

            return (
              <label
                key={option}
                className={`bulk-order-reference-tile${
                  checked ? " is-selected" : ""
                }`}
              >
                <input
                  type="checkbox"
                  checked={checked}
                  onChange={() => {
                    if (isNotSure) {
                      handleNotSureSelection();
                    }
                  }}
                />
                <span
                  className="bulk-order-reference-tile-icon"
                  aria-hidden="true"
                >
                  {isNotSure ? "?" : "◇"}
                </span>
                <span>{option}</span>
              </label>
            );
          })}
        </div>
      </fieldset>

      <div className="bulk-order-reference-row2 first">
        <div className="bulk-order-reference-field">
          <label htmlFor="bulk-name">Full Name <span>*</span></label>
          <input
            id="bulk-name"
            value={form.name}
            onChange={(event) => updateField("name", event.target.value)}
            placeholder="Ravi Sharma"
            autoComplete="name"
          />
        </div>

        <div className="bulk-order-reference-field">
          <label htmlFor="bulk-mobile">Mobile Number <span>*</span></label>
          <div className="bulk-order-reference-phone">
            <span aria-hidden="true">+91</span>
            <input
              id="bulk-mobile"
              value={form.mobile}
              onChange={(event) =>
                updateField(
                  "mobile",
                  event.target.value.replace(/\D/g, "").slice(0, 10)
                )
              }
              placeholder="98765 43210"
              inputMode="numeric"
              autoComplete="tel-national"
              maxLength={10}
            />
          </div>
        </div>
      </div>

      <fieldset>
        <legend className="bulk-order-reference-label">
          Expected quantity <span>*</span>
        </legend>

        <div className="bulk-order-reference-pills">
          {[
            ["100", "100–499"],
            ["500", "500–999"],
            ["1000", "1,000–4,999"],
            ["5000", "5,000+"],
          ].map(([value, label]) => (
            <label
              key={value}
              className={`bulk-order-reference-pill${
                form.quantity === value ? " is-selected" : ""
              }`}
            >
              <input
                type="radio"
                name="quantity"
                value={value}
                checked={form.quantity === value}
                onChange={(event) =>
                  updateField("quantity", event.target.value)
                }
              />
              <span>{label}</span>
            </label>
          ))}
        </div>
      </fieldset>

      <div
        className={`bulk-order-reference-more${
          moreOpen ? " is-open" : ""
        }`}
      >
        <button
          type="button"
          className="bulk-order-reference-more-head"
          aria-expanded={moreOpen}
          onClick={() => setMoreOpen((open) => !open)}
        >
          <span className="bulk-order-reference-more-icon" aria-hidden="true">
            ⊕
          </span>

          <span>
            <span className="bulk-order-reference-more-title">
              Add more details
              <span className="bulk-order-reference-badge">Faster quote</span>
            </span>
            <span className="bulk-order-reference-more-sub">
              Bag size, delivery pincode, when you need it, purpose, reference image
            </span>
          </span>

          <span className="bulk-order-reference-toggle" aria-hidden="true">
            {moreOpen ? "−" : "+"}
          </span>
        </button>

        {moreOpen && (
          <div className="bulk-order-reference-more-body">
            <div className="bulk-order-reference-row2">
              <div className="bulk-order-reference-field">
                <label htmlFor="bulk-size">Expected bag size</label>
                <input
                  id="bulk-size"
                  value={form.bagSize}
                  onChange={(event) =>
                    updateField("bagSize", event.target.value)
                  }
                  placeholder="e.g. 14 x 16 inch"
                />
              </div>

              <div className="bulk-order-reference-field">
                <label htmlFor="bulk-pincode">Delivery pincode</label>
                <input
                  id="bulk-pincode"
                  value={form.deliveryPincode}
                  onChange={(event) =>
                    updateField(
                      "deliveryPincode",
                      event.target.value.replace(/\D/g, "").slice(0, 6)
                    )
                  }
                  placeholder="462016"
                  inputMode="numeric"
                  autoComplete="postal-code"
                  maxLength={6}
                />
              </div>
            </div>

            <fieldset className="bulk-order-reference-field">
              <legend>When do you need the bags?</legend>

              <div className="bulk-order-reference-when">
                {TIMELINE_OPTIONS.map((option) => (
                  <label
                    key={option.value}
                    className={`bulk-order-reference-when-card${
                      form.deliveryTimeline === option.value
                        ? " is-selected"
                        : ""
                    }`}
                  >
                    <input
                      type="radio"
                      name="deliveryTimeline"
                      value={option.value}
                      checked={form.deliveryTimeline === option.value}
                      onChange={(event) =>
                        updateField(
                          "deliveryTimeline",
                          event.target.value
                        )
                      }
                    />
                    <span>
                      <strong>{option.title}</strong>
                      <small>{option.subtitle}</small>
                    </span>
                  </label>
                ))}
              </div>
            </fieldset>

            <div className="bulk-order-reference-field">
              <label htmlFor="bulk-purpose">Purpose of purchase</label>
              <select
                id="bulk-purpose"
                value={form.purpose}
                onChange={(event) =>
                  updateField("purpose", event.target.value)
                }
              >
                <option value="">Select purpose</option>
                {PURPOSE_OPTIONS.map((option) => (
                  <option key={option} value={option}>
                    {option}
                  </option>
                ))}
              </select>
            </div>

            <div className="bulk-order-reference-row2">
              <div className="bulk-order-reference-field">
                <label htmlFor="bulk-category">Interested Category</label>
                <select
                  id="bulk-category"
                  value={form.categoryId}
                  onChange={(event) => {
                    updateField("categoryId", event.target.value);
                    updateField("productId", "");
                    setNotSureSelected(false);
                  }}
                >
                  <option value="">Select a category</option>
                  {categories.map((category) => (
                    <option key={category.id} value={category.id}>
                      {category.name}
                    </option>
                  ))}
                </select>
              </div>

              <div className="bulk-order-reference-field">
                <label htmlFor="bulk-product">Interested Product</label>
                <select
                  id="bulk-product"
                  value={form.productId}
                  onChange={(event) => {
                    updateField("productId", event.target.value);
                    setNotSureSelected(false);
                  }}
                >
                  <option value="">Select a product</option>
                  {filteredProducts.map((product) => (
                    <option key={product.id} value={product.id}>
                      {product.name}
                    </option>
                  ))}
                </select>
              </div>
            </div>

            <div className="bulk-order-reference-field" id="bulk-reference-file-field">
              <span className="bulk-order-reference-field-label">
                Reference image
              </span>

              <label
                htmlFor="bulk-reference-image"
                className="bulk-order-reference-drop"
              >
                <span className="bulk-order-reference-drop-icon" aria-hidden="true">
                  ⇧
                </span>
                <strong>Upload a reference image or your logo</strong>
                <small>JPG, PNG or WebP, up to 5MB</small>
              </label>

              <input
                id="bulk-reference-image"
                type="file"
                accept="image/jpeg,image/png,image/webp"
                className="bulk-order-reference-file-input"
                onChange={(event) =>
                  setReferenceImage(event.target.files?.[0] ?? null)
                }
              />

              {referenceImage && (
                <div className="bulk-order-reference-file-selected">
                  <span>{referenceImage.name}</span>
                  <button
                    type="button"
                    onClick={() => setReferenceImage(null)}
                    aria-label="Remove reference image"
                  >
                    ×
                  </button>
                </div>
              )}
            </div>

            <div className="bulk-order-reference-row2">
              <div className="bulk-order-reference-field">
                <label htmlFor="bulk-email">Email</label>
                <input
                  id="bulk-email"
                  type="email"
                  value={form.email}
                  onChange={(event) =>
                    updateField("email", event.target.value)
                  }
                  placeholder="name@company.com"
                  autoComplete="email"
                />
              </div>

              <div className="bulk-order-reference-field">
                <label htmlFor="bulk-business">Business Name</label>
                <input
                  id="bulk-business"
                  value={form.businessName}
                  onChange={(event) =>
                    updateField("businessName", event.target.value)
                  }
                  placeholder="Acme Pvt Ltd"
                  autoComplete="organization"
                />
              </div>
            </div>

            <div className="bulk-order-reference-field">
              <label htmlFor="bulk-message">Additional requirements</label>
              <textarea
                id="bulk-message"
                value={form.message}
                onChange={(event) =>
                  updateField("message", event.target.value)
                }
                placeholder="Colour, logo printing, packaging..."
                rows={4}
              />
            </div>
          </div>
        )}
      </div>

      {error && (
        <div className="bulk-order-reference-error" role="alert">
          {error}
        </div>
      )}

      <button
        type="submit"
        disabled={loading}
        className="bulk-order-reference-submit"
      >
        {loading ? "Submitting..." : "Get my bulk quote"}{" "}
        <span aria-hidden="true">→</span>
      </button>

      <div className="bulk-order-reference-or" aria-hidden="true">
        <span>or</span>
      </div>

      <a
        href={whatsappHref}
        target="_blank"
        rel="noopener noreferrer"
        className="bulk-order-reference-whatsapp"
      >
        <span aria-hidden="true">◔</span>
        Chat with us on WhatsApp
      </a>

      <p className="bulk-order-reference-note">
        This is an enquiry only. No payment or purchase is made through this form.
      </p>
    </form>
  );
}
