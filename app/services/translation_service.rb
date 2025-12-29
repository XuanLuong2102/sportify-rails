require 'gemini-ai'

class TranslationService
  def initialize
    @client = GoogleGenerativeAI::Client.new(api_key: Rails.application.credentials.dig(:gemini, :api_key))
    @model = 'gemini-1.5-flash'
  end

  def translate(text, target_language = 'English')
    return if text.blank?

    prompt = "Translate the following text to #{target_language}. 
              Important: Return ONLY the translated term directly. 
              Do not include quotes, explanations, or extra words.
              Input: \n\n #{text}"

    response = @client.generate_content(model: @model, contents: [{ role: "user", parts: [{ text: prompt }] }])
    
    response.dig("candidates", 0, "content", "parts", 0, "text")&.strip
  rescue StandardError => e
    Rails.logger.error "Gemini Translation Error: #{e.message}"
    nil
  end
end