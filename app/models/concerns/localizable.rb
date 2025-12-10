module Localizable
  extend ActiveSupport::Concern

  class_methods do
    def localize_attr(*attrs)
      attrs.each do |attr|
        define_method(attr) do
          locale = I18n.locale == :vi ? 'vi' : 'en'
          send("#{attr}_#{locale}")
        end
      end
    end
  end
end
