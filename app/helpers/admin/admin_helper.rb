module Admin::AdminHelper
  def controller_place_relate?
    %w[places place_managers place_sports].include?(controller_name)
  end
end
