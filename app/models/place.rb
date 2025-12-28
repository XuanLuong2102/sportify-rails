class Place < ApplicationRecord
  include Localizable

  self.primary_key = 'place_id'

  has_many :place_sports
  has_many :place_managers

  localize_attr :name, :address, :city, :district, :description

  TRANSLATABLE_FIELDS = %w[name address city district description].freeze

  after_commit :schedule_translation, on: [:create, :update]

  def full_address
    [address, district, city].compact_blank.join(', ')
  end

  def agency
    place_managers.first&.user
  end

  ransacker :name do |parent|
    Arel.sql("CONCAT(name_en, ' ', name_vi)")
  end
  ransacker :location do |parent|
     Arel.sql("CONCAT(city_en, ' ', city_vi, ' ', district_en, ' ', district_vi, ' ', address_en, ' ', address_vi)")
  end
  ransacker :address do |parent|
    Arel.sql("CONCAT(address_en, ' ', address_vi)")
  end
  ransacker :city do |parent|
    Arel.sql("CONCAT(city_en, ' ', city_vi)")
  end
  ransacker :district do |parent|
    Arel.sql("CONCAT(district_en, ' ', district_vi)")
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name address city district is_close maintenance_place name location place_id]
  end

  def self.ransackable_associations(auth_object = nil)
    ['place_sports', 'place_managers']
  end

  private

  def schedule_translation
    should_translate = TRANSLATABLE_FIELDS.any? do |field|
      saved_change_to_attribute?("#{field}_vi") || send("#{field}_en").blank?
    end

    if should_translate
      TranslatePlaceJob.perform_later(self.id)
    end
  end
end
