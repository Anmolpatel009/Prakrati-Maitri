"use client";

import { FormEvent, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import { createClient as createBrowserClient } from "@/lib/supabase/client";

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

export default function BulkOrderForm({
  categories,
  products,
}: Props) {
  const router = useRouter();

  const [form, setForm] = useState({
    name: "",
    mobile: "",
    email: "",
    businessName: "",
    categoryId: "",
    productId: "",
    quantity: "",
    purpose: "",
    message: "",
  });

  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [success, setSuccess] = useState(false);
  const [referenceImage, setReferenceImage] =
    useState<File | null>(null);

  const filteredProducts = useMemo(() => {
    if (!form.categoryId) return products;

    return products.filter(
      (product) => product.category_id === form.categoryId
    );
  }, [products, form.categoryId]);

  function updateField(
    field: keyof typeof form,
    value: string
  ) {
    setForm((current) => ({
      ...current,
      [field]: value,
    }));
  }

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setError("");

    if (!form.name.trim()) {
      setError("Please enter your name.");
      return;
    }

    if (form.mobile.trim().length < 10) {
      setError("Please enter a valid mobile number.");
      return;
    }

    if (!form.quantity || Number(form.quantity) <= 0) {
      setError("Please enter the expected quantity.");
      return;
    }

    if (!form.categoryId && !form.productId) {
      setError(
        "Please select a category or product you're interested in."
      );
      return;
    }

    if (!form.purpose.trim()) {
      setError(
        "Please tell us the purpose of your bulk purchase."
      );
      return;
    }

    if (referenceImage) {
      const allowedTypes = [
        "image/jpeg",
        "image/png",
        "image/webp",
      ];

      if (!allowedTypes.includes(referenceImage.type)) {
        setError(
          "Reference image must be JPG, PNG or WebP."
        );
        return;
      }

      if (referenceImage.size > 5 * 1024 * 1024) {
        setError(
          "Reference image must be smaller than 5MB."
        );
        return;
      }
    }

    setLoading(true);

    try {
      let referenceImagePath: string | null = null;

      if (referenceImage) {
        const uploadInitResponse = await fetch(
          "/api/bulk-order/reference-upload",
          {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify({
              contentType: referenceImage.type,
              size: referenceImage.size,
            }),
          }
        );

        const uploadInitResult =
          await uploadInitResponse.json();

        if (!uploadInitResponse.ok) {
          throw new Error(
            uploadInitResult.error ||
              "Unable to prepare reference image upload."
          );
        }

        const supabase = createBrowserClient();

        const { error: uploadError } =
          await supabase.storage
            .from("bulk-order-references")
            .uploadToSignedUrl(
              uploadInitResult.path,
              uploadInitResult.token,
              referenceImage,
              {
                contentType: referenceImage.type,
              }
            );

        if (uploadError) {
          console.error(
            "Bulk enquiry reference image upload error:",
            uploadError
          );

          throw new Error(
            "Unable to upload reference image right now."
          );
        }

        referenceImagePath = uploadInitResult.path;
      }

      const response = await fetch("/api/bulk-order", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          ...form,
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
    } catch (err) {
      setError(
        err instanceof Error
          ? err.message
          : "Unable to submit enquiry."
      );
    } finally {
      setLoading(false);
    }
  }

  if (success) {
    return (
      <div className="bulk-order-success">
        <span className="bulk-order-eyebrow">THANK YOU</span>

        <h2>Your enquiry has been received.</h2>

        <p>
          We&apos;ve received your bulk order interest. Our team will review
          your requirements and get in touch with you.
        </p>

        <button
          type="button"
          onClick={() => router.push("/shop")}
          className="bulk-order-submit"
        >
          Continue Shopping →
        </button>
      </div>
    );
  }

  return (
    <form className="bulk-order-form" onSubmit={handleSubmit}>
      <div className="bulk-order-form-heading">
        <h2>Tell us what you need</h2>
        <p>
          Share a few details and we&apos;ll take it from there.
        </p>
      </div>

      <div className="bulk-order-form-grid">
        <label>
          Full Name *
          <input
            value={form.name}
            onChange={(e) => updateField("name", e.target.value)}
            placeholder="Your name"
          />
        </label>

        <label>
          Mobile Number *
          <input
            value={form.mobile}
            onChange={(e) => updateField("mobile", e.target.value)}
            placeholder="10-digit mobile number"
            inputMode="tel"
          />
        </label>

        <label>
          Email
          <input
            type="email"
            value={form.email}
            onChange={(e) => updateField("email", e.target.value)}
            placeholder="you@example.com"
          />
        </label>

        <label>
          Business Name
          <input
            value={form.businessName}
            onChange={(e) =>
              updateField("businessName", e.target.value)
            }
            placeholder="Business / organisation name"
          />
        </label>

        <label>
          Interested Category
          <select
            value={form.categoryId}
            onChange={(e) => {
              updateField("categoryId", e.target.value);
              updateField("productId", "");
            }}
          >
            <option value="">Select a category</option>
            {categories.map((category) => (
              <option key={category.id} value={category.id}>
                {category.name}
              </option>
            ))}
          </select>
        </label>

        <label>
          Interested Product
          <select
            value={form.productId}
            onChange={(e) =>
              updateField("productId", e.target.value)
            }
          >
            <option value="">Select a product</option>
            {filteredProducts.map((product) => (
              <option key={product.id} value={product.id}>
                {product.name}
              </option>
            ))}
          </select>
        </label>

        <label>
          Expected Quantity *
          <input
            type="number"
            min="1"
            value={form.quantity}
            onChange={(e) =>
              updateField("quantity", e.target.value)
            }
            placeholder="e.g. 100"
          />
        </label>

        <label>
          Purpose of Purchase *
          <select
            value={form.purpose}
            onChange={(e) =>
              updateField("purpose", e.target.value)
            }
          >
            <option value="">Select purpose</option>
            <option value="Corporate gifting">
              Corporate gifting
            </option>
            <option value="Business use">
              Business use
            </option>
            <option value="Events">
              Events
            </option>
            <option value="Retail / resale">
              Retail / resale
            </option>
            <option value="Wedding / celebration">
              Wedding / celebration
            </option>
            <option value="Personal bulk requirement">
              Personal bulk requirement
            </option>
            <option value="Other">
              Other
            </option>
          </select>
        </label>
      </div>

      <label className="bulk-order-full-field">
        Additional Requirements
        <textarea
          value={form.message}
          onChange={(e) =>
            updateField("message", e.target.value)
          }
          placeholder="Tell us about colours, customisation, delivery timeline, branding or anything else..."
          rows={5}
        />
      </label>

      <label className="bulk-order-full-field">
        Reference Image
        <input
          type="file"
          accept="image/jpeg,image/png,image/webp"
          onChange={(e) =>
            setReferenceImage(e.target.files?.[0] ?? null)
          }
        />
        <span className="bulk-order-file-help">
          Optional. Upload a JPG, PNG or WebP reference image, up to 5MB.
        </span>
        {referenceImage && (
          <span className="bulk-order-file-selected">
            Selected: {referenceImage.name}
          </span>
        )}
      </label>

      {error && (
        <div className="bulk-order-error">
          {error}
        </div>
      )}

      <button
        type="submit"
        disabled={loading}
        className="bulk-order-submit"
      >
        {loading ? "Submitting..." : "Submit Bulk Enquiry →"}
      </button>

      <p className="bulk-order-note">
        This is an enquiry only. No payment or purchase is made through this
        form.
      </p>
    </form>
  );
}
