module ApplicationHelper
  def format_datetime(datetime)
    datetime.strftime('%d/%m/%Y %H:%M') if datetime.present?
  end

  def param_role_name_eq?(role_name)
    params.dig(:q, :role_name_eq) == role_name
  end
end
