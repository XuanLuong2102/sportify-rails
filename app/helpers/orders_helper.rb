module OrdersHelper
  def order_status_color(status)
    case status
    when 'pending'
      'secondary'
    when 'confirmed', 'approved'
      'primary'
    when 'shipping'
      'info'
    when 'completed', 'delivered'
      'success'
    when 'cancelled', 'rejected'
      'danger'
    when 'returned'
      'warning'
    else
      'secondary'
    end
  end
end
