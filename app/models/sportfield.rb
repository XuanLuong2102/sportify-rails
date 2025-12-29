class Sportfield < ApplicationRecord
  include Localizable

  self.primary_key = "sportfield_id"

  has_many :place_sports

  localize_attr :name, :description

  TRANSLATABLE_FIELDS = %w[name description].freeze

  after_commit :schedule_translation, on: [:create, :update]

  ransacker :name do |parent|
    Arel.sql("CONCAT(name_en, ' ', name_vi)")
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name created_at updated_at]
  end

  private

  def schedule_translation
    AutoTranslationJob.perform_now(self.class.name, self.sportfield_id)
  end
end
