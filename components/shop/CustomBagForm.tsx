"use client";

import { ChangeEvent, FormEvent, useRef, useState } from "react";
import { useRouter } from "next/navigation";

const BAG_TYPES = [
  "Tote Bag",
  "Jute Bag",
  "Cotton Bag",
  "Drawstring Bag",
  "Gift / Hamper Bag",
  "Packaging Bag",
  "Other Custom Bag",
];

const PRICE_RANGES = [
  "₹50 – ₹100",
  "₹100 – ₹200",
  "₹200 – ₹500",
  "₹500 – ₹1,000",
  "₹1,000+",
  "Not sure yet",
];

export default function CustomBagForm() {
  const router = useRouter();
  const fileInputRef = useRef<HTMLInputElement>(null);

  const [mobile, setMobile] = useState("");
  const [bagType, setBagType] = useState("");
  const [description, setDescription] = useState("");
  const [priceRange, setPriceRange] = useState("");
  const [referenceImage, setReferenceImage] = useState<File | null>(null);
  const [previewUrl, setPreviewUrl] = useState("");
  const [loading, setLoading] = useState(false);
  const [uploading, setUploading] = useState(false);
  const [error, setError] = useState("");
  const [success, setSuccess] = useState(false);

  function handleImageChange(event: ChangeEvent<HTMLInputElement>) {
    const file = event.target.files?.[0];

    if (!file) {
      return;
    }

    const allowedTypes = [
      "image/jpeg",
      "image/png",
      "image/webp",
    ];

    if (!allowedTypes.includes(file.type)) {
      setError("Please upload a JPG, PNG or WebP image.");
      return;
    }

    if (file.size > 5 * 1024 * 1024) {
      setError("Reference image must be smaller than 5MB.");
      return;
    }

    setError("");
    setReferenceImage(file);

    if (previewUrl) {
      URL.revokeObjectURL(previewUrl);
    }

    setPreviewUrl(URL.createObjectURL(file));
  }

  async function uploadReferenceImage() {
    if (!referenceImage) {
      return null;
    }

    setUploading(true);

    try {
      const extension =
        referenceImage.name.split(".").pop()?.toLowerCase() || "jpg";

      const path =
        `custom-bags/${crypto.randomUUID()}.${extension}`;

      const response = await fetch(
        "/api/custom-bags/upload",
        {
          method: "POST",
          headers: {
            "Content-Type": referenceImage.type,
            "X-File-Path": path,
          },
          body: referenceImage,
        }
      );

      const result = await response.json();

      if (!response.ok) {
        throw new Error(
          result.error || "Unable to upload reference image."
        );
      }

      return result.url as string;
    } finally {
      setUploading(false);
    }
  }

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setError("");

    const normalizedMobile = mobile.replace(/\D/g, "");

    if (normalizedMobile.length < 10) {
      setError("Please enter a valid contact number.");
      return;
    }

    if (!bagType) {
      setError("Please select the type of bag you want.");
      return;
    }

    if (description.trim().length < 10) {
      setError("Please tell us a little more about your idea.");
      return;
    }

    setLoading(true);

    try {
      const referenceImageUrl = await uploadReferenceImage();

      const response = await fetch("/api/custom-bags", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          mobile: normalizedMobile,
          bagType,
          description: description.trim(),
          referenceImageUrl,
          expectedPriceRange: priceRange || null,
        }),
      });

      const result = await response.json();

      if (!response.ok) {
        throw new Error(
          result.error || "Unable to submit your request."
        );
      }

      setSuccess(true);
    } catch (err) {
      setError(
        err instanceof Error
          ? err.message
          : "Unable to submit your request."
      );
    } finally {
      setLoading(false);
    }
  }

  if (success) {
    return (
      <div className="custom-bag-success">
        <span className="custom-bag-eyebrow">REQUEST RECEIVED</span>

        <h2>Your idea is on its way.</h2>

        <p>
          Thank you for sharing your custom bag requirement.
          Our team will review it and contact you on the number
          you provided.
        </p>

        <button
          type="button"
          className="custom-bag-submit"
          onClick={() => router.push("/shop")}
        >
          Continue Exploring →
        </button>
      </div>
    );
  }

  return (
    <form
      className="custom-bag-form"
      onSubmit={handleSubmit}
    >
      <div className="custom-bag-form-heading">
        <span className="custom-bag-eyebrow">
          YOUR IDEA, YOUR BAG
        </span>

        <h2>Tell us what you&apos;re imagining.</h2>

        <p>
          Share your idea, show us a reference and we&apos;ll
          help turn it into a bag made for you.
        </p>
      </div>

      <div className="custom-bag-form-grid">
        <label className="custom-bag-field">
          Contact Number *
          <input
            type="tel"
            inputMode="tel"
            value={mobile}
            onChange={(event) => setMobile(event.target.value)}
            placeholder="10-digit mobile number"
            maxLength={15}
          />
        </label>

        <label className="custom-bag-field">
          What kind of bag? *
          <select
            value={bagType}
            onChange={(event) => setBagType(event.target.value)}
          >
            <option value="">Choose a bag type</option>

            {BAG_TYPES.map((type) => (
              <option key={type} value={type}>
                {type}
              </option>
            ))}
          </select>
        </label>

        <label className="custom-bag-field">
          Expected Price Range
          <select
            value={priceRange}
            onChange={(event) => setPriceRange(event.target.value)}
          >
            <option value="">Select a range</option>

            {PRICE_RANGES.map((range) => (
              <option key={range} value={range}>
                {range}
              </option>
            ))}
          </select>
        </label>
      </div>

      <label className="custom-bag-field custom-bag-full-field">
        Tell us about your bag *
        <textarea
          value={description}
          onChange={(event) =>
            setDescription(event.target.value)
          }
          placeholder="What should it look like? What will you use it for? Tell us anything important about the size, material, colour, printing or finish..."
          rows={7}
        />
      </label>

      <div className="custom-bag-upload">
        <div>
          <span className="custom-bag-upload-title">
            Reference Image
          </span>

          <span className="custom-bag-upload-help">
            Have a picture of something you like? Upload it here.
          </span>
        </div>

        <input
          ref={fileInputRef}
          type="file"
          accept="image/jpeg,image/png,image/webp"
          onChange={handleImageChange}
          hidden
        />

        <button
          type="button"
          className="custom-bag-upload-button"
          onClick={() => fileInputRef.current?.click()}
        >
          {referenceImage ? "Change Image" : "Upload Reference"}
        </button>

        {previewUrl && (
          <div className="custom-bag-image-preview">
            <img
              src={previewUrl}
              alt="Reference preview"
            />

            <button
              type="button"
              onClick={() => {
                setReferenceImage(null);
                URL.revokeObjectURL(previewUrl);
                setPreviewUrl("");

                if (fileInputRef.current) {
                  fileInputRef.current.value = "";
                }
              }}
            >
              Remove
            </button>
          </div>
        )}
      </div>

      {error && (
        <div className="custom-bag-error">
          {error}
        </div>
      )}

      <button
        type="submit"
        className="custom-bag-submit"
        disabled={loading || uploading}
      >
        {uploading
          ? "Uploading image..."
          : loading
            ? "Sending your idea..."
            : "Send My Custom Bag Idea →"}
      </button>

      <p className="custom-bag-note">
        No payment is required. We&apos;ll contact you to discuss
        your requirement.
      </p>
    </form>
  );
}
