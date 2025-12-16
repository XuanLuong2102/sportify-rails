module Seeds
  module Cleaners
    class DatabaseCleaner
      PRODUCT_TABLES = [
        ProductStock,
        ProductListing,
        ProductVariant,
        Product,
        ProductColor,
        ProductSize,
        ProductBrand,
        ProductCategory
      ].freeze

      PLACE_TABLES = [
        PlaceManager,
        PlaceSport,
        Place,
        Sportfield
      ].freeze

      USER_TABLES = [User, Role].freeze

      def self.clean_all
        new.clean_all
      end

      def clean_all
        clean_products
        clean_places
        clean_users
      end

      private

      def clean_products
        PRODUCT_TABLES.each(&:delete_all)
      end

      def clean_places
        PLACE_TABLES.each(&:delete_all)
      end

      def clean_users
        USER_TABLES.each(&:delete_all)
      end
    end
  end
end
