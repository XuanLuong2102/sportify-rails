module Seeds
  module Constants
    USD_RATE = 26_342.0

    APPAREL_CATEGORIES = %w[T-Shirts Shorts Pants Jackets].freeze
    SHOE_CATEGORIES = %w[Shoes].freeze
    ACCESSORY_CATEGORIES = %w[Balls Rackets Nets Bags Socks Caps Gloves Water\ Bottles].freeze

    APPAREL_SIZES = %w[S M L XL].freeze
    SHOE_SIZES = %w[40 41 42 43].freeze
    FREE_SIZE = %w[F].freeze

    COLORS_BASIC = %w[Black White].freeze

    DEFAULT_STOCK_QUANTITY = 100

    CATEGORY_PRICES = {
      'Jackets' => 699_000,
      'Pants' => 399_000,
      'Shorts' => 249_000,
      'T-Shirts' => 199_000,
      'Shoes' => 1_299_000,
      'Bags' => 599_000,
      'Rackets' => 499_000
    }.freeze

    def self.usd_price(vnd)
      (vnd / USD_RATE).round(2)
    end
  end
end
