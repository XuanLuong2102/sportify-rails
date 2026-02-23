# frozen_string_literal: true

class BookingsController < ApplicationController
  layout 'user'
  before_action :authenticate_user!, except: [:select_place, :select_time]
  before_action :set_booking, only: [:show, :confirm, :pay]

  # GET /bookings - List user's bookings
  def index
    @bookings = current_user.bookings
                            .includes(place_sport: [:place, :sportfield], field_schedule: [])
                            .order(created_at: :desc)
                            .page(params[:page])
  end

  # GET /bookings/select_place - Step 1: Select place and field
  def select_place
    @places = Place.where(is_close: false, maintenance_place: false)
                   .includes(place_sports: :sportfield)
    
    if params[:place_id].present?
      @selected_place = @places.find_by(place_id: params[:place_id])
      @place_sports = @selected_place&.place_sports&.where(is_close: false, maintenance_sport: false)
    end
  end

  # GET /bookings/new - Step 2: Schedule view (weekly calendar)
  def new
    unless params[:place_sport_id].present?
      redirect_to select_place_bookings_path, alert: t('user.bookings.select_field_first')
      return
    end

    @place_sport = PlaceSport.includes(:place, :sportfield).find(params[:place_sport_id])
    @booking_mode = params[:mode] || 'single' # single or monthly
    
    # For weekly view
    @selected_date = params[:date].present? ? Date.parse(params[:date]) : Date.current
    @week_start = @selected_date.beginning_of_week
    @week_dates = (0..6).map { |i| @week_start + i.days }
    
    # Get existing bookings for this week
    @bookings_by_date = fetch_bookings_for_week(@place_sport, @week_start)
    
    # Generate time slots
    @time_slots = generate_hourly_slots(@place_sport)
  end

  # POST /bookings/calculate_price - AJAX: Calculate price
  def calculate_price
    place_sport = PlaceSport.find(params[:place_sport_id])
    
    if params[:mode] == 'monthly'
      # Calculate monthly booking price
      dates = params[:dates] # Array of dates
      hours = params[:hours].to_i
      total_bookings = dates.size
      price_per_booking = place_sport.price_per_hour_vnd * hours
      total_price = price_per_booking * total_bookings
      
      render json: {
        bookings_count: total_bookings,
        price_per_booking: price_per_booking,
        total_price: total_price,
        formatted: number_to_currency(total_price, unit: '₫', format: '%n %u')
      }
    else
      # Single booking price
      start_time = Time.parse(params[:start_time])
      end_time = Time.parse(params[:end_time])
      hours = ((end_time - start_time) / 1.hour).ceil
      price_vnd = place_sport.price_per_hour_vnd * hours
      
      render json: {
        hours: hours,
        price_vnd: price_vnd,
        price_vnd_formatted: number_to_currency(price_vnd, unit: '₫', format: '%n %u')
      }
    end
  end

  # POST /bookings - Create booking(s)
  def create
    @place_sport = PlaceSport.find(booking_params[:place_sport_id])
    
    if params[:booking][:mode] == 'monthly'
      create_monthly_bookings
    else
      create_single_booking
    end
  end

  # GET /bookings/:id - Show booking details
  def show
    @booking = current_user.bookings.includes(place_sport: [:place, :sportfield], field_schedule: []).find(params[:id])
  end

  # GET /bookings/:id/confirm - Confirmation page
  def confirm
    # Booking confirmation page before payment
  end

  # POST /bookings/:id/pay - Process payment
  def pay
    payment_method = params[:payment_method]
    
    case payment_method
    when 'cash'
      @booking.update(status: 'approved')
      redirect_to booking_path(@booking), notice: t('user.bookings.booking_confirmed_cash')
    when 'vnpay'
      redirect_to vnpay_payment_url(@booking), allow_other_host: true
    else
      redirect_to confirm_booking_path(@booking), alert: t('user.bookings.select_payment_method')
    end
  end

  private

  def set_booking
    @booking = current_user.bookings.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:place_sport_id, :total_price, :mode)
  end

  def create_single_booking
    @place_sport = PlaceSport.find(booking_params[:place_sport_id]) unless @place_sport
    
    begin
      ActiveRecord::Base.transaction do
        schedule = FieldSchedule.create!(
          place_sport_id: @place_sport.id,
          date: params[:booking][:date],
          start_time: params[:booking][:start_time],
          end_time: params[:booking][:end_time],
          is_available: false
        )
        
        booking = current_user.bookings.build(
          place_sport_id: @place_sport.id,
          total_price: params[:booking][:total_price],
          status: 'pending'
        )
        
        booking.schedule = schedule
        
        if booking.save
          redirect_to confirm_booking_path(booking)
        else
          flash[:alert] = booking.errors.full_messages.join(', ')
          raise ActiveRecord::Rollback
        end
      end
      
      # If we are here and no redirect happened (which means rollback happened and we relied on previous logic, 
      # but wait, redirect inside transaction is fine).
      # Actually, check if performed?
      redirect_back(fallback_location: new_booking_path(place_sport_id: @place_sport.id)) unless performed?
      
    rescue ActiveRecord::RecordInvalid => e
      flash[:alert] = e.message
      redirect_back(fallback_location: new_booking_path(place_sport_id: @place_sport.id))
    end
  end

  def create_monthly_bookings
    booking_dates = params[:booking][:dates] # Array of date strings
    start_time = params[:booking][:start_time]
    end_time = params[:booking][:end_time]
    total_price = params[:booking][:total_price].to_f
    
    success_count = 0
    
    ActiveRecord::Base.transaction do
      booking_dates.each do |date_str|
        schedule = FieldSchedule.create!(
          place_sport_id: @place_sport.id,
          date: Date.parse(date_str),
          start_time: start_time,
          end_time: end_time,
          is_available: false
        )
        
        current_user.bookings.create!(
          place_sport_id: @place_sport.id,
          schedule: schedule,
          total_price: total_price / booking_dates.size,
          status: 'pending'
        )
        
        success_count += 1
      end
    end
    
    redirect_to bookings_path, notice: t('user.bookings.monthly_bookings_created', count: success_count)
  rescue => e
    flash[:alert] = e.message
    redirect_back(fallback_location: new_booking_path(place_sport_id: @place_sport.id))
  end

  def fetch_bookings_for_week(place_sport, week_start)
    week_end = week_start + 6.days
    
    bookings = Booking.where(place_sport_id: place_sport.id)
                      .where(status: ['approved', 'completed', 'pending'])
                      .joins(:field_schedule)
                      .where('field_schedules.date BETWEEN ? AND ?', week_start, week_end)
                      .includes(:field_schedule)
    
    bookings.group_by { |b| b.field_schedule.date }
  end

  def generate_hourly_slots(place_sport)
    place = place_sport.place
    slots = []
    current_time = place.open_time
    
    while current_time < place.close_time
      end_time = current_time + 1.hour
      break if end_time > place.close_time
      
      slots << {
        start_time: current_time.strftime('%H:%M'),
        end_time: end_time.strftime('%H:%M'),
        label: current_time.strftime('%H:%M')
      }
      
      current_time = end_time
    end
    
    slots
  end

  def vnpay_payment_url(booking)
    payments_vnpay_return_path(booking_id: booking.id)
  end
end
