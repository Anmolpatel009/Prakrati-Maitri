import PDFDocument from "pdfkit";

export type InvoiceOrderItem = {
  product_name: string;
  product_sku: string | null;
  quantity: number;
  unit_price: number;
  line_total: number;
};

export type InvoiceOrder = {
  id: string;
  created_at: string;
  subtotal: number;
  shipping_fee: number;
  total: number;
  shipping_first_name: string | null;
  shipping_last_name: string | null;
  shipping_phone: string | null;
  shipping_address: string | null;
  shipping_city: string | null;
  shipping_state: string | null;
  shipping_country: string | null;
  shipping_postal_code: string | null;
  order_items: InvoiceOrderItem[];
};

function currency(value: number) {
  return `Rs. ${value.toLocaleString("en-IN", {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  })}`;
}

function safeText(value: string | null | undefined) {
  return value?.trim() || "—";
}

export function generateInvoicePdf(
  order: InvoiceOrder,
  customerEmail?: string | null,
) {
  return new Promise<Buffer>((resolve, reject) => {
    const doc = new PDFDocument({
      size: "A4",
      margin: 48,
      info: {
        Title: `Prakriti Maitri GST Invoice ${order.id.slice(0, 8)}`,
        Author: "Prakriti Maitri",
        Subject: "Order Invoice",
      },
    });

    const chunks: Buffer[] = [];

    doc.on("data", (chunk) => {
      chunks.push(Buffer.from(chunk));
    });

    doc.on("end", () => {
      resolve(Buffer.concat(chunks));
    });

    doc.on("error", reject);

    const pageWidth = 595.28;
    const left = 48;
    const right = pageWidth - 48;
    const contentWidth = right - left;

    const bark = "#4E3320";
    const jute = "#8B5A2B";
    const espresso = "#2E2118";
    const muted = "#666666";
    const burlap = "#C8A26B";
    const cream = "#F8F3EA";
    const line = "#E5D6BC";

    const sellerGstin =
      process.env.INVOICE_GSTIN?.trim() ||
      "GSTIN not configured";
    const sellerAddress =
      process.env.INVOICE_SELLER_ADDRESS?.trim() ||
      "India";

    const invoiceNumber =
      `PM-${order.id.slice(0, 8).toUpperCase()}`;

    const orderDate = new Date(order.created_at).toLocaleDateString(
      "en-IN",
      {
        day: "2-digit",
        month: "short",
        year: "numeric",
      },
    );

    doc.fillColor(bark).font("Helvetica-Bold").fontSize(22)
      .text("PRAKRITI MAITRI", left, 48);

    doc.fillColor(jute).font("Helvetica-Bold").fontSize(10)
      .text("GST INVOICE", left, 77);

    doc.fillColor(muted).font("Helvetica").fontSize(9)
      .text("support@prakritimaitri.com", left, 94)
      .text(sellerAddress, left, 108)
      .text(`GSTIN: ${sellerGstin}`, left, 122);

    doc.fillColor(bark).font("Helvetica-Bold").fontSize(10)
      .text("Invoice No.", 375, 58);

    doc.fillColor(espresso).font("Helvetica").fontSize(10)
      .text(invoiceNumber, 440, 58);

    doc.fillColor(bark).font("Helvetica-Bold").fontSize(10)
      .text("Order ID", 375, 78);

    doc.fillColor(espresso).font("Helvetica").fontSize(9)
      .text(order.id, 420, 78, {
        width: 127,
        align: "right",
      });

    doc.fillColor(bark).font("Helvetica-Bold").fontSize(10)
      .text("Invoice Date", 375, 98);

    doc.fillColor(espresso).font("Helvetica").fontSize(10)
      .text(orderDate, 440, 98);

    doc.moveTo(left, 146)
      .lineTo(right, 146)
      .lineWidth(1)
      .strokeColor(line)
      .stroke();

    doc.fillColor(jute).font("Helvetica-Bold").fontSize(9)
      .text("BILLED TO", left, 165);

    const customerName = [
      order.shipping_first_name,
      order.shipping_last_name,
    ]
      .filter(Boolean)
      .join(" ") || "Customer";

    const addressLines = [
      customerName,
      order.shipping_address,
      [
        order.shipping_city,
        order.shipping_state,
        order.shipping_postal_code,
      ]
        .filter(Boolean)
        .join(", "),
      order.shipping_country,
      order.shipping_phone
        ? `Phone: ${order.shipping_phone}`
        : "",
      customerEmail
        ? `Email: ${customerEmail}`
        : "",
    ].filter(Boolean);

    doc.fillColor(espresso).font("Helvetica").fontSize(10)
      .text(addressLines.join("\n"), left, 183, {
        width: 240,
        lineGap: 2,
      });

    let y = 275;

    const colItem = left;
    const colSku = 310;
    const colQty = 390;
    const colUnit = 430;
    const colAmount = 505;

    doc.roundedRect(left, y, contentWidth, 25, 4)
      .fillColor(cream)
      .fill();

    doc.fillColor(jute).font("Helvetica-Bold").fontSize(8)
      .text("ITEM", colItem + 8, y + 8)
      .text("SKU", colSku, y + 8)
      .text("QTY", colQty, y + 8)
      .text("UNIT", colUnit, y + 8)
      .text("AMOUNT", colAmount, y + 8);

    y += 34;

    for (const item of order.order_items ?? []) {
      const itemName = safeText(item.product_name);
      const itemHeight = Math.max(
        28,
        doc.heightOfString(itemName, {
          width: 245,
          lineGap: 2,
        }) + 8,
      );

      if (y + itemHeight > 700) {
        doc.addPage();
        y = 55;
      }

      doc.fillColor(espresso).font("Helvetica").fontSize(9)
        .text(itemName, colItem + 8, y, {
          width: 245,
          lineGap: 2,
        });

      doc.fillColor(muted).fontSize(8)
        .text(safeText(item.product_sku), colSku, y);

      doc.fillColor(espresso).fontSize(9)
        .text(String(item.quantity), colQty, y)
        .text(currency(Number(item.unit_price)), colUnit, y, {
          width: 65,
          align: "right",
        })
        .text(currency(Number(item.line_total)), colAmount, y, {
          width: 42,
          align: "right",
        });

      y += itemHeight;

      doc.moveTo(left, y)
        .lineTo(right, y)
        .lineWidth(0.5)
        .strokeColor(line)
        .stroke();

      y += 10;
    }

    y += 10;

    const totalsX = 360;

    doc.fillColor(muted).font("Helvetica").fontSize(10)
      .text("Subtotal", totalsX, y);

    doc.fillColor(espresso)
      .text(currency(Number(order.subtotal)), 490, y, {
        width: 57,
        align: "right",
      });

    y += 22;

    doc.fillColor(muted)
      .text("Shipping", totalsX, y);

    doc.fillColor(espresso)
      .text(
        Number(order.shipping_fee) === 0
          ? "Free"
          : currency(Number(order.shipping_fee)),
        490,
        y,
        {
          width: 57,
          align: "right",
        },
      );

    y += 25;

    doc.moveTo(totalsX, y)
      .lineTo(right, y)
      .lineWidth(1)
      .strokeColor(line)
      .stroke();

    y += 13;

    doc.fillColor(bark).font("Helvetica-Bold").fontSize(13)
      .text("TOTAL PAID", totalsX, y);

    doc.fillColor(bark)
      .text(currency(Number(order.total)), 470, y, {
        width: 77,
        align: "right",
      });

    y += 48;

    doc.roundedRect(left, y, contentWidth, 64, 6)
      .fillColor(cream)
      .fill();

    doc.fillColor(jute).font("Helvetica-Bold").fontSize(9)
      .text("INVOICE NOTE", left + 14, y + 13);

    doc.fillColor(muted).font("Helvetica").fontSize(8.5)
      .text(
        "This invoice is generated from the order information recorded by Prakriti Maitri.",
        left + 14,
        y + 30,
        {
          width: contentWidth - 28,
          lineGap: 2,
        },
      );

    y += 92;

    doc.fillColor(muted).font("Helvetica").fontSize(8)
      .text(
        "Thank you for choosing Prakriti Maitri.",
        left,
        y,
        {
          width: contentWidth,
          align: "center",
        },
      );

    doc.end();
  });
}
