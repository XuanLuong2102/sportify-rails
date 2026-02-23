# frozen_string_literal: true

module BookingsHelper
  def booking_status_color(status)
    case status
    when 'pending' then 'warning'
    when 'approved' then 'success'
    when 'completed' then 'primary'
    when 'cancelled', 'rejected' then 'danger'
    else 'secondary'
    end
  end
end
