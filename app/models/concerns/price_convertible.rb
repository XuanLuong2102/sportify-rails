module PriceConvertible
  extend ActiveSupport::Concern

  included do
    before_validation :sync_usd_price_from_vnd
  end

  class_methods do
    def convert_price(vnd:, usd:)
      @price_vnd_column = vnd
      @price_usd_column = usd
    end

    def price_vnd_column
      @price_vnd_column
    end

    def price_usd_column
      @price_usd_column
    end
  end

  # ======================
  # Exchange rate
  # ======================
  def usd_vnd_rate
    Rails.cache.fetch('usd_vnd_rate', expires_in: 1.hour) do
      ENV.fetch('USD_VND_RATE', 25_000).to_f
    end
  end

  # ======================
  # Sync logic
  # ======================
  def sync_usd_price_from_vnd
    vnd_col = self.class.price_vnd_column
    usd_col = self.class.price_usd_column
    return if vnd_col.blank? || usd_col.blank?

    # chỉ convert khi VND thay đổi hoặc record mới
    return unless will_save_change_to_attribute?(vnd_col)

    vnd_value = send(vnd_col)
    return if vnd_value.blank?

    usd_value = (vnd_value.to_f / usd_vnd_rate).round(2)
    send("#{usd_col}=", usd_value)
  end

  # ======================
  # Display helper
  # ======================
  def display_price
    I18n.locale == :en ?
      send(self.class.price_usd_column) :
      send(self.class.price_vnd_column)
  end
end
