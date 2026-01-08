module Admin::AdminHelper
  def controller_products_relate?
    %w[products sizes colors].include?(controller_name)
  end
end
