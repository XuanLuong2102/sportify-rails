module Api
  module V1
    class BookingsController < ApplicationController
      # include ApiAuthenticable
      # protect_from_forgery with: :null_session

      def create
        booking = Booking.new(booking_params)
        booking.status = 'pending'
        if booking.save
          render json: { success: true, booking_id: booking.id }, status: :created
        else
          render json: { success: false, errors: booking.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def booking_params
        params.require(:booking).permit(:user_id, :place_sport_id, :schedule_id, :total_price, :status)
      end
    end
  end
end
