# frozen_string_literal: true

class Admin::DashboardController < Admin::AdminController
  def index
    @date_range = parse_date_range
    @revenue_data = calculate_revenue_data
    @cost_data = calculate_cost_data
    @profit_data = calculate_profit_data
    @monthly_revenue_chart = monthly_revenue_chart_data
    @revenue_by_type_chart = revenue_by_type_chart_data
    @places_summary = places_summary_data
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
      .where(created_at: @date_range)
      .where.not(status: ['cancelled', 'rejected'])
      .sum(:total_price) || 0
  end

  def order_revenue
    @order_revenue ||= Order
      .where(created_at: @date_range)
      .where.not(status: ['cancelled', 'returned'])
      .sum(:total_amount_vnd) || 0
  end

  def calculate_cost_data
    {
      operating_costs: operating_costs,
      stock_inbound_costs: stock_inbound_costs,
      total_costs: operating_costs + stock_inbound_costs
    }
  end

  def operating_costs
    @operating_costs ||= Expense
      .where(expense_date: @date_range)
      .sum(:amount_vnd) || 0
  end

  def stock_inbound_costs
    @stock_inbound_costs ||= StockInbound
      .where(received_at: @date_range)
      .sum('cost_price_vnd * quantity') || 0
  end

  def calculate_profit_data
    revenue = @revenue_data[:total_revenue]
    costs = @cost_data[:total_costs]
    {
      total_profit: revenue - costs,
      profit_margin: revenue.zero? ? 0 : ((revenue - costs) / revenue.to_f * 100).round(2)
    }
  end

  def monthly_revenue_chart_data
    booking_data = Booking
      .where(created_at: @date_range)
      .where.not(status: ['cancelled', 'rejected'])
      .group("DATE_FORMAT(bookings.created_at, '%Y-%m')")
      .sum(:total_price)

    order_data = Order
      .where(created_at: @date_range)
      .where.not(status: ['cancelled', 'returned'])
      .group("DATE_FORMAT(orders.created_at, '%Y-%m')")
      .sum(:total_amount_vnd)

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

  def places_summary_data
    # Get top 10 places by revenue using SQL queries
    places = Place.limit(10).to_a
    
    places.map do |place|
      # Calculate booking revenue for this place
      booking_revenue = Booking
        .joins(place_sport: :place)
        .where(places: { place_id: place.place_id })
        .where(created_at: @date_range)
        .where.not(status: ['cancelled', 'rejected'])
        .sum(:total_price) || 0
      
      # Calculate order revenue for this place
      order_revenue = Order
        .where(place_id: place.place_id)
        .where(created_at: @date_range)
        .where.not(status: ['cancelled', 'returned'])
        .sum(:total_amount_vnd) || 0

      {
        place: place,
        booking_revenue: booking_revenue,
        order_revenue: order_revenue,
        total_revenue: booking_revenue + order_revenue
      }
    end.sort_by { |p| -p[:total_revenue] }.first(10)
  end
end
