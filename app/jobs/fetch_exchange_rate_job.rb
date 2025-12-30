class FetchExchangeRateJob < ApplicationJob
  queue_as :default

  def perform
    response = Faraday.get('https://open.er-api.com/v6/latest/USD')
    data = JSON.parse(response.body)

    rate = data.dig('rates', 'VND')

    unless rate
      Rails.logger.error("[ExchangeRate] VND rate missing: #{data}")
      return
    end

    
    binding.pry
    
    Rails.cache.write(
      'usd_vnd_rate',
      rate,
      expires_in: 12.hours
    )

    Rails.logger.info("[ExchangeRate] USD/VND updated: #{rate}")
  rescue => e
    Rails.logger.error("[ExchangeRate] ERROR: #{e.message}")
    raise e
  end
end
