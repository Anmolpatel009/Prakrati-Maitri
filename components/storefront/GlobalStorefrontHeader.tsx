import TwoDoorsHeader from "@/components/storefront/TwoDoorsHeader";
import type { NavbarCustomizationConfig } from "@/lib/shop/navbar-customization";

type Category = {
  id: string;
  name: string;
  slug: string;
  image_url: string | null;
  is_active: boolean;
};

type Subcategory = {
  id: string;
  category_id: string;
  name: string;
  slug: string;
  is_active: boolean;
  display_order: number;
};

type Props = {
  navbarData: { categories: Category[]; subcategories: Subcategory[] };
  customization: NavbarCustomizationConfig;
};

export default function GlobalStorefrontHeader(props: Props) {
  return <TwoDoorsHeader {...props} />;
}