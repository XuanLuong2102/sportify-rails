module Seeds
  module Seeders
    class ProductSeeder < BaseSeeder
      def self.seed_all
        new.seed_all
      end

      def seed_all
        seed_categories
        seed_brands
        seed_sizes
        seed_colors
        seed_products
        seed_variants
        seed_listings
        seed_stocks
      end

      def seed_categories
        CSV.foreach(csv_path('product_categories'), headers: true) do |row|
          ProductCategory.find_or_create_by!(
            name_en: row['name_en'],
            name_vi: row['name_vi'],
            description_en: row['description_en'],
            description_vi: row['description_vi']
          )
        end
      end

      def seed_brands
        CSV.foreach(csv_path('product_brands'), headers: true) do |row|
          ProductBrand.find_or_create_by!(name: row['name'])
        end
      end

      def seed_sizes
        CSV.foreach(csv_path('product_sizes'), headers: true) do |row|
          ProductSize.find_or_create_by!(name: row['name'])
        end
      end

      def seed_colors
        CSV.foreach(csv_path('product_colors'), headers: true) do |row|
          ProductColor.find_or_create_by!(
            name: row['name'],
            code_rgb: row['code_rgb']
          )
        end
      end

      def seed_products
        CSV.foreach(csv_path('products'), headers: true) do |row|
          create_product(row)
        end
      end

      def seed_variants
        ProductVariantGenerator.generate_all
      end

      def seed_listings
        CSV.foreach(csv_path('product_listings'), headers: true) do |row|
          create_listing(row)
        end
      end

      def seed_stocks
        ProductStockGenerator.generate_all
      end

      private

      def create_product(row)
        brand = ProductBrand.find_by!(name: row['brand_name'])
        category = ProductCategory.find_by!(name_en: row['category_name_en'])

        Product.find_or_create_by!(
          name_en: row['name_en'],
          name_vi: row['name_vi']
        ) do |product|
          product.description_en = row['description_en']
          product.description_vi = row['description_vi']
          product.brand = brand
          product.category = category
          product.is_active = parse_boolean(row['is_active'])
        end
      end

      def create_listing(row)
        product = Product.find_by!(name_en: row['product_name_en'])
        place = Place.find_by!(name_en: row['place_name_en'])

        ProductListing.find_or_create_by!(
          product: product,
          place: place
        ) do |listing|
          listing.is_active = parse_boolean(row['is_active'])
          listing.sold_count = row['sold_count'].to_i
        end
      end
    end
  end
end
