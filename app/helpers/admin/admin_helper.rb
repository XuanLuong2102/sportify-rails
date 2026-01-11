module Admin::AdminHelper
  def controller_products_relate?
    %w[products product_sizes product_colors stock_inbounds].include?(controller_name)
  end
end
