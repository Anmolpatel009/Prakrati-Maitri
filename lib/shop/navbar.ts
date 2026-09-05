import { createClient } from "@/lib/supabase/server";

export async function getShopNavbarData() {
  const supabase = await createClient();

  const [
    { data: categories, error: categoriesError },
    { data: subcategories, error: subcategoriesError },
  ] = await Promise.all([
    supabase
      .from("categories")
      .select(`
        id,
        name,
        slug,
        is_active
      `)
      .eq("is_active", true)
      .order("name", { ascending: true }),

    supabase
      .from("subcategories")
      .select(`
        id,
        category_id,
        name,
        slug,
        is_active,
        display_order
      `)
      .eq("is_active", true)
      .order("display_order", { ascending: true })
      .order("name", { ascending: true }),
  ]);

  if (categoriesError) {
    throw new Error(
      `Failed to load navbar categories: ${categoriesError.message}`
    );
  }

  if (subcategoriesError) {
    throw new Error(
      `Failed to load navbar subcategories: ${subcategoriesError.message}`
    );
  }

  return {
    categories: categories ?? [],
    subcategories: subcategories ?? [],
  };
}
