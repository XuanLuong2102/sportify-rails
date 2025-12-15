  module Api
    module V1
      class PlacesController < Api::ApiController
        skip_before_action :authenticate_user!

        before_action -> { validate_query_fields!(Place) }, only: [:index]
        before_action :set_place, only: [:show, :update, :destroy]

        def index
          places = Place.includes(place_sports: :sportfield)
          places = places.ransack(params[:q]).result(distinct: true) if params[:q].present?
          places = places.paginate(page: params[:page], per_page: params[:per_page])

          render_success(
            serialize_resource(
              places,
              serializer: PlaceSerializer,
              include: included_associations
            ),
            message: I18n.t('api.places.fetched_places_success'),
            meta: pagination_meta(places)
          )
        end

        def show
          render_success(
            serialize_resource(
              @place,
              serializer: PlaceSerializer,
              include: included_associations
            ),
            message: I18n.t('api.places.fetched_place_success')
          )
        end

        def update
          if @place.update(place_params)
            render_success(
              serialize_resource(
                @place,
                serializer: PlaceSerializer,
                include: included_associations
              ),
              message: I18n.t('api.places.updated')
            )
          else
            render_error(
              @place.errors.full_messages,
              status: :unprocessable_entity
            )
          end
        end

        def destroy
          @place.destroy
          render_success(
            {},
            message: I18n.t('api.places.deleted')
          )
        end

        private

        def set_place
          @place = Place.includes(place_sports: :sportfield).find(params[:id])
        end

        def place_params
          params.require(:place).permit(
            :name_en,
            :name_vi,
            :address_en,
            :address_vi,
            :district_en,
            :district_vi,
            :city_en,
            :city_vi,
            :open_time,
            :close_time,
            :description_en,
            :description_vi,
            :maintenance_place,
            :is_close
          )
        end

        def included_associations
          ['place_sports', 'place_sports.sportfield']
        end
      end
    end
  end
