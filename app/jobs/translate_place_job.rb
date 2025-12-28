class TranslatePlaceJob < ApplicationJob
  queue_as :default

  def perform(place_id)
    place = Place.find_by(id: place_id)
    return unless place

    translator = TranslationService.new
    updated = false

    Place::TRANSLATABLE_FIELDS.each do |field|
      col_vi = "#{field}_vi"
      col_en = "#{field}_en"
      
      if place.send(col_vi).present? && place.send(col_en).blank?
        translated = translator.translate(place.send(col_vi), "English")
        if translated.present?
          place.send("#{col_en}=", translated) 
          updated = true
        end
      end
    end

    place.save(validate: false) if updated
  end
end