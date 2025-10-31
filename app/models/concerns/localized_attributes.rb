module LocalizedAttributes
  extend ActiveSupport::Concern

  class_methods do
    # localized_attr :title, :content, fallback: [:vi, :en]
    def localized_attr(*attrs, fallback: nil)
      attrs.each do |attr_name|
        define_method(attr_name) do
          # normalize locale symbol
          loc = I18n.locale.to_s.presence || I18n.default_locale.to_s
          col = "#{attr_name}_#{loc}"

          # if column exists and value present, return it
          if respond_to?(col) && (val = public_send(col)).present?
            val
          else
            # fallback order: provided fallback array -> default locale -> first available *_en/*_vi
            fb = Array(fallback || [I18n.default_locale.to_s, 'en', 'vi']).map(&:to_s)

            fb.each do |fb_loc|
              fb_col = "#{attr_name}_#{fb_loc}"
              return public_send(fb_col) if respond_to?(fb_col) && public_send(fb_col).present?
            end

            # last resort: try any column matching pattern (title_*)
            column_prefix = attribute_names.select { |c| c.start_with?("#{attr_name}_") }.sort
            column_prefix.each do |c|
              val = public_send(c)
              return val if val.present?
            end

            nil
          end
        end
      end
    end
  end
end
