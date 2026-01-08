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

  def hex_contrast_color(hex_color)
    return '#000000' if hex_color.blank?
    
    # Remove # if present
    hex = hex_color.gsub('#', '')
    
    # Convert hex to RGB
    r = hex[0..1].to_i(16)
    g = hex[2..3].to_i(16)
    b = hex[4..5].to_i(16)
    
    # Calculate luminance
    luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255
    
    # Return white text for dark colors, black for light colors
    luminance > 0.5 ? '#000000' : '#FFFFFF'
  rescue
    '#000000'
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    
    # Render partial _product_variant_fields.html.erb
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    
    # Tạo nút bấm gọi Javascript
    link_to(name, '#', class: "btn btn-outline-primary btn-sm add_fields", 
      data: { id: id, fields: fields.gsub("\n", "") })
  end
end
