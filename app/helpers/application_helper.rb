module ApplicationHelper
  def format_datetime(datetime)
    datetime.strftime('%d/%m/%Y %H:%M') if datetime.present?
  end

  def param_role_name_eq?(role_name)
    params.dig(:q, :role_name_eq) == role_name
  end

  def back_to_list(default_path = root_path)
    history_key = "#{controller_name}_return_path"
    
    session[history_key] || request.referer || default_path
  end
end
