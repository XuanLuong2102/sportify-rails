# frozen_string_literal: true

module Agency
  class DashboardController < Agency::AgencyController
    def index
      @date_range = parse_date_range
      @revenue_data = calculate_revenue_data
      @cost_data = calculate_cost_data
      @profit_data = calculate_profit_data
      @monthly_revenue_chart = monthly_revenue_chart_data
      @revenue_by_type_chart = revenue_by_type_chart_data
    end

    private

    def parse_date_range
      start_date = params[:start_date]&.to_date || 1.year.ago.beginning_of_month
      end_date = params[:end_date]&.to_date || Date.current.end_of_month
      start_date..end_date
    end

    def calculate_revenue_data
      {
        booking_revenue: booking_revenue,
        order_revenue: order_revenue,
        total_revenue: booking_revenue + order_revenue
      }
    end

    def booking_revenue
      @booking_revenue ||= Booking
        .joins(place_sport: :place)
        .where(places: { place_id: current_agency_place_ids })
        .where(created_at: @date_range)
        .where.not(status: ['cancelled', 'rejected'])
        .sum(:total_price) || 0
    end

    def order_revenue
      @order_revenue ||= Order
        .where(place_id: current_agency_place_ids)
        .where(created_at: @date_range)
        .where.not(status: ['cancelled', 'returned'])
        .sum(:total_amount_vnd) || 0
    end

    def calculate_cost_data
      {
        operating_costs: operating_costs,
        maintenance_costs: maintenance_costs,
        total_costs: operating_costs + maintenance_costs
      }
    end

    def operating_costs
      @operating_costs ||= Expense
        .where(owner_id: current_agency_place_ids)
        .where(created_at: @date_range)
        .where(owner_type: 'agency')
        .sum(:amount_vnd) || 0
    end

    def maintenance_costs
      # Calculate maintenance costs if tracked separately
      # For now, returning 0 as placeholder
      0
    end

    def calculate_profit_data
      revenue = @revenue_data[:total_revenue]
      costs = @cost_data[:total_costs]
      {
        total_profit: revenue - costs,
        profit_margin: costs.zero? ? 0 : ((revenue - costs) / revenue.to_f * 100).round(2)
      }
    end

    def monthly_revenue_chart_data
      # Group by month for the date range
      booking_data = Booking
        .joins(place_sport: :place)
        .where(places: { place_id: current_agency_place_ids })
        .where(created_at: @date_range)
        .where.not(status: ['cancelled', 'rejected'])
        .group("DATE_FORMAT(bookings.created_at, '%Y-%m')")
        .sum(:total_price)

      order_data = Order
        .where(place_id: current_agency_place_ids)
        .where(created_at: @date_range)
        .where.not(status: ['cancelled', 'returned'])
        .group("DATE_FORMAT(orders.created_at, '%Y-%m')")
        .sum(:total_amount_vnd)

      # Merge the two datasets
      all_months = (booking_data.keys + order_data.keys).uniq.sort
      
      all_months.map do |month|
        date = Date.parse("#{month}-01")
        {
          month: date.strftime('%B %Y'),
          bookings: booking_data[month] || 0,
          orders: order_data[month] || 0,
          total: (booking_data[month] || 0) + (order_data[month] || 0)
        }
      end
    end

    def revenue_by_type_chart_data
      [
        ['Bookings', booking_revenue],
        ['Orders', order_revenue]
      ]
    end
  end
end
