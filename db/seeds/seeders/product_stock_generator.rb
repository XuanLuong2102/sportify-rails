module Seeds
  module Seeders
    class ProductStockGenerator
      include Constants

      def self.generate_all
        new.generate_all
      end

      def generate_all
        ProductListing
          .includes(product: :product_variants)
          .find_each do |listing|
            generate_stocks_for(listing)
          end
      end

      private

      def generate_stocks_for(listing)
        listing.product.product_variants.each do |variant|
          create_stock(listing, variant)
        end
      end

      def create_stock(listing, variant)
        ProductStock.find_or_create_by!(
          product_listing: listing,
          product_variant: variant
        ) do |stock|
          stock.stock_quantity = DEFAULT_STOCK_QUANTITY
        end
      end
    end
  end
end
