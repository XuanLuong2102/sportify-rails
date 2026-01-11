# frozen_string_literal: true

module Agency
  class SchedulesController < Agency::AgencyController
    def index
      @selected_date = params[:date]&.to_date || Date.current
      @place_sports = current_agency_places.flat_map(&:place_sports).select { |ps| !ps.is_close }
      @confirmed_bookings = fetch_confirmed_bookings
      @time_slots = generate_time_slots
      @schedule_data = build_schedule_data
    end

    private

    def fetch_confirmed_bookings
      Booking
        .joins(place_sport: :place)
        .includes(:user, :place_sport, :field_schedule, place_sport: [:sportfield, :place])
        .where(places: { place_id: current_agency_place_ids })
        .where(status: ['approved', 'completed'])
        .where(field_schedules: { date: @selected_date })
        .order('field_schedules.start_time')
    end

    def generate_time_slots
      # Generate hourly slots from 6 AM to 11 PM
      slots = []
      (6..22).each do |hour|
        slots << Time.zone.parse("#{hour}:00")
      end
      slots
    end

    def build_schedule_data
      # Group bookings by time slot and place_sport
      # data structure: { time_slot => { place_sport_id => [bookings] } }
      data = {}
      
      @time_slots.each do |time_slot|
        data[time_slot] = {}
        @place_sports.each do |place_sport|
          data[time_slot][place_sport.id] = []
        end
      end

      @confirmed_bookings.each do |booking|
        next unless booking.field_schedule

        schedule = booking.field_schedule
        start_time = schedule.start_time
        
        # Find which time slot this booking belongs to
        @time_slots.each do |time_slot|
          slot_hour = time_slot.hour
          booking_start_hour = start_time.hour
          
          # Check if booking starts within this hour slot
          if booking_start_hour == slot_hour
            place_sport_id = booking.place_sport_id
            if data[time_slot] && data[time_slot][place_sport_id]
              data[time_slot][place_sport_id] << {
                booking: booking,
                schedule: schedule
              }
            end
            break
          end
        end
      end

      data
    end
  end
end
