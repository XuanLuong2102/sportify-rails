module Api
  module V1
    class PlacesController < Api::ApiController
      skip_before_action :authenticate_user!

      before_action -> { validate_query_fields!(Place) }, only: [:index]
      before_action :set_place, only: [:show]

      def index
        places = Place.includes(place_sports: :sportfield)
        places = places.ransack(params[:q]).result(distinct: true) if params[:q].present?
        places = places.paginate(page: params[:page], per_page: params[:per_page])

        render_success(serialize_resource(places), message: I18n.t('api.places.fetched_places_success'))
      end

      def show
        render_success(serialize_resource(@place), message: I18n.t('api.places.fetched_place_success'))
      end

      private

      def set_place
        @place = Place.includes(place_sports: :sportfield).find(params[:id])
      end

      def serialize_resource(resource)
        options = { include: included_associations }
        
        if resource.respond_to?(:each)
          options[:each_serializer] = PlaceSerializer
        else
          options[:serializer] = PlaceSerializer
        end

        ActiveModelSerializers::SerializableResource.new(resource, options).as_json
      end

      def included_associations
        ['place_sports', 'place_sports.sportfield']
      end
    end
  end
end
