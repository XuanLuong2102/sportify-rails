class Product < ApplicationRecord
  include Localizable

  belongs_to :brand, class_name: 'ProductBrand', optional: true
  belongs_to :category, class_name: 'ProductCategory', optional: true

  has_many :product_variants, dependent: :destroy
  has_many :product_colors, through: :product_variants
  has_many :product_sizes, through: :product_variants

  has_many :product_images, dependent: :destroy
  has_many :product_listings, dependent: :destroy
  has_many :places, through: :product_listings
  has_many :product_reviews, -> { distinct }, through: :product_listings

  has_one_attached :thumbnail do |attachable|
    attachable.variant :thumbnail_50, resize_to_limit: [50, 50]
    attachable.variant :thumbnail_300, resize_to_limit: [300, 300]
  end

  localize_attr :name, :description

  TRANSLATABLE_FIELDS = %w[name description].freeze

  after_commit :schedule_translation, on: [:create, :update]

  scope :active, -> { where(is_active: true) }

  ransacker :name do |parent|
    Arel.sql("CONCAT(name_en, ' ', name_vi)")
  end

  def self.ransackable_attributes(auth_object = nil)
    ['name_en', 'name_vi', 'name']
  end

  def self.ransackable_associations(auth_object = nil)
    ['brand', 'category', 'product_variants', 'product_colors', 'product_sizes', 'product_listings', 'places']
  end
  
  private

  def schedule_translation
    AutoTranslationJob.perform_now(self.class.name, self.id)
  end
end
