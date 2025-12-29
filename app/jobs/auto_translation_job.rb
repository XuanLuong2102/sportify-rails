class AutoTranslationJob < ApplicationJob
  queue_as :default

  def perform(class_name, record_id)
    model_class = class_name.constantize

    record = model_class.find_by(model_class.primary_key => record_id)
    return unless record

    return unless model_class.const_defined?(:TRANSLATABLE_FIELDS)
    fields = model_class::TRANSLATABLE_FIELDS

    translator = TranslationService.new
    updates = {}

    fields.each do |field|
      col_vi = "#{field}_vi"
      col_en = "#{field}_en"
      
      if record.send(col_vi).present?
        translated = translator.translate(record.send(col_vi), 'English')
        if translated.present?
          updates[col_en] = translated
        end
      end
    end

    if updates.any?
      record.update_columns(updates)
    end
  end
end
