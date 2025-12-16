module Seeds
  module Seeders
    class ProductVariantGenerator
      include Constants

      def self.generate_all
        new.generate_all
      end

      def generate_all
        Product.includes(:category, :product_variants).find_each do |product|
          generate_variants_for(product)
        end
      end

      private

      def generate_variants_for(product)
        config = variant_config(product.category.name_en)
        return unless config

        create_variants(product, config)
      end

      def variant_config(category_name)
        case category_name
        when *APPAREL_CATEGORIES
          apparel_config(category_name)
        when *SHOE_CATEGORIES
          shoe_config
        when *ACCESSORY_CATEGORIES
          accessory_config(category_name)
        end
      end

      def apparel_config(category)
        {
          sizes: APPAREL_SIZES,
          colors: COLORS_BASIC,
          price_vnd: CATEGORY_PRICES.fetch(category, 199_000)
        }
      end

      def shoe_config
        {
          sizes: SHOE_SIZES,
          colors: COLORS_BASIC,
          price_vnd: CATEGORY_PRICES['Shoes']
        }
      end

      def accessory_config(category)
        {
          sizes: FREE_SIZE,
          colors: [COLORS_BASIC.sample],
          price_vnd: CATEGORY_PRICES.fetch(category, 299_000)
        }
      end

      def create_variants(product, config)
        config[:sizes].each do |size_name|
          size = ProductSize.find_by!(name: size_name)

          config[:colors].each do |color_name|
            color = ProductColor.find_by!(name: color_name)
            create_variant(product, size, color, config[:price_vnd])
          end
        end
      end

      def create_variant(product, size, color, price_vnd)
        ProductVariant.find_or_create_by!(
          product: product,
          product_size: size,
          product_color: color
        ) do |variant|
          variant.price_vnd = price_vnd
          variant.price_usd = Constants.usd_price(price_vnd)
          variant.is_active = true
        end
      end
    end
  end
end
