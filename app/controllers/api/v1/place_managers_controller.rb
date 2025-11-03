module Api
  module V1
    class PlaceManagersController < ApplicationController
      # include ApiAuthenticable

      def index
        if params[:place_id].present?
          managers = PlaceManager.where(place_id: params[:place_id]).includes(:user)
        else
          managers = PlaceManager.all.includes(:user)
        end

        render json: managers.map { |m|
          {
            place_id: m.place_id,
            user_id: m.user_id,
            email: m.user&.email,
            first_name: m.user&.first_name,
            phone: m.user&.phone
          }
        }
      end
    end
  end
end
