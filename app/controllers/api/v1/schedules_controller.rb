module Api
  module V1
    class SchedulesController < ApplicationController
      # include ApiAuthenticable

      def index
        if params[:place_sport_id].blank? || params[:date].blank?
          render json: { error: 'place_sport_id and date required' }, status: :bad_request and return
        end

        schedules = FieldSchedule.where(place_sport_id: params[:place_sport_id], date: params[:date])
                                 .where(is_available: true, is_close: false)
                                 .order(:start_time)

        render json: schedules.map { |s| { id: s.id, start_time: s.start_time.strftime("%H:%M"), end_time: s.end_time.strftime("%H:%M") } }
      end
    end
  end
end
