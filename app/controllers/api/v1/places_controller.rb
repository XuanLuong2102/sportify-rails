module Api
  module V1
    class PlacesController < ApplicationController
      # include ApiAuthenticable

      def index
        places = Place.all
        places = places.where('city_en ILIKE ? OR city_vi ILIKE ?', "%#{params[:city]}%", "%#{params[:city]}%") if params[:city].present?
        places = places.where('name_en ILIKE ? OR name_vi ILIKE ?', "%#{params[:query]}%", "%#{params[:query]}%") if params[:query].present?

        render json: places.map { |p| place_json(p) }
      end

      def show
        place = Place.find(params[:id])
        render json: place_json(place)
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Place not found' }, status: :not_found
      end

      private

      def place_json(p)
        {
          place_id: p.place_id,
          name_en: p.name_en,
          name_vi: p.name_vi,
          address_en: p.address_en,
          address_vi: p.address_vi,
          city_en: p.city_en,
          city_vi: p.city_vi,
          open_time: p.open_time,
          close_time: p.close_time,
          is_close: p.is_close,
          maintenance_place: p.maintenance_place,
          description_en: p.description_en,
          description_vi: p.description_vi,
          place_sports: p.place_sports.map do |ps|
            {
              id: ps.id,
              sportfield_id: ps.sportfield_id,
              sport_name: ps.sportfield&.name_en,
              price_per_hour_usd: ps.price_per_hour_usd,
              price_per_hour_vnd: ps.price_per_hour_vnd,
              is_close: ps.is_close,
              maintenance_sport: ps.maintenance_sport
            }
          end
        }
      end
    end
  end
end
