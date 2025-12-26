module ApplicationHelper
  def format_datetime(datetime)
    datetime.strftime('%d/%m/%Y %H:%M') if datetime.present?
  end

  def param_role_name_eq?(role_name)
    params.dig(:q, :role_name_eq) == role_name
  end

  def back_to_list(default = admin_users_path)
    params[:return_to] || default
  end
end
