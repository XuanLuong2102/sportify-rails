require 'faraday'
require 'json'
require 'uri'

class TranslationService
  GOOGLE_TRANSLATE_URL = "https://translate.googleapis.com/translate_a/single"

  def translate(text, target_lang = 'en')
    return if text.blank?

    begin
      conn = Faraday.new(url: GOOGLE_TRANSLATE_URL)
      
      response = conn.get do |req|
        req.params['client'] = 'gtx'
        req.params['sl'] = 'vi'
        req.params['tl'] = target_lang
        req.params['dt'] = 't'
        req.params['q'] = text 
      end

      if response.success?
        data = JSON.parse(response.body)
        data[0].map { |s| s[0] }.join
      else
        Rails.logger.error "Google Translate API Error: #{response.status}"
        nil
      end
    rescue StandardError => e
      Rails.logger.error "Translation Connection Error: #{e.message}"
      nil
    end
  end
end
