class Place < ApplicationRecord
  include Localizable

  self.primary_key = 'place_id'

  has_many :place_sports
  has_many :place_managers

  localize_attr :name, :address, :city, :district, :description

  TRANSLATABLE_FIELDS = %w[name address city district description].freeze

  after_commit :schedule_translation, on: [:create, :update]

  scope :active, -> { where(is_close: false) }
  scope :closed, -> { where(is_close: true) }

  def full_address
    [address, district, city].compact_blank.join(', ')
  end

  def opening_hours
    return '-' if open_time.blank? || close_time.blank?
  
    "#{open_time.strftime('%-I:%M %p')} - #{close_time.strftime('%-I:%M %p')}"
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
    %w[name address city district is_close maintenance_place location place_id]
  end

  def self.ransackable_associations(auth_object = nil)
    ['place_sports', 'place_managers']
  end

  private

  def schedule_translation
    AutoTranslationJob.perform_now(self.class.name, self.place_id)
  end
end
