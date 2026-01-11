# frozen_string_literal: true

module Agency
  class PlaceSportsController < Agency::AgencyController
    include PaginatableConcern

    before_action :set_place_sport, only: [:show, :edit, :update, :destroy, :soft_delete, :restore, :toggle_maintenance]
    before_action :load_available_places, only: [:new, :create, :edit, :update]

    def index
      @q = agency_place_sports.ransack(params[:q])
      @place_sports = @q.result(distinct: true)
                        .includes(:place, :sportfield, :bookings)
                        .order(created_at: :desc)
                        .paginate(page: params[:page], per_page: params[:per_page])
      @available_places = current_agency_places
    end

    def show
      # Will show place sport details with upcoming bookings
    end

    def new
      @place_sport = PlaceSport.new
      @sportfields = Sportfield.all
    end

    def create
      @place_sport = PlaceSport.new(place_sport_params)

      # Validate that the place belongs to the agency
      unless current_agency_place_ids.include?(@place_sport.place_id)
        redirect_to new_agency_place_sport_path, alert: I18n.t('agency.place_sports.invalid_place')
        return
      end

      if @place_sport.save
        redirect_to agency_place_sport_path(@place_sport), 
                    notice: I18n.t('agency.place_sports.created_successfully', default: 'Sport field created successfully.')
      else
        @sportfields = Sportfield.all
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @sportfields = Sportfield.all
    end

    def update
      # Validate that the place belongs to the agency
      if place_sport_params[:place_id].present? && !current_agency_place_ids.include?(place_sport_params[:place_id].to_i)
        redirect_to edit_agency_place_sport_path(@place_sport), alert: I18n.t('agency.place_sports.invalid_place')
        return
      end

      if @place_sport.update(place_sport_params)
        redirect_to agency_place_sport_path(@place_sport), 
                    notice: I18n.t('agency.place_sports.updated_successfully', default: 'Sport field updated successfully.')
      else
        @sportfields = Sportfield.all
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @place_sport.destroy
        redirect_to agency_place_sports_path, 
                    notice: I18n.t('agency.place_sports.deleted_successfully', default: 'Sport field deleted successfully.')
      else
        redirect_to agency_place_sport_path(@place_sport), 
                    alert: I18n.t('agency.place_sports.delete_failed', default: 'Failed to delete sport field.')
      end
    end

    def soft_delete
      if @place_sport.update(is_close: true)
        redirect_to agency_place_sports_path, 
                    notice: I18n.t('agency.place_sports.deleted_successfully', default: 'Sport field closed successfully.')
      else
        redirect_to agency_place_sport_path(@place_sport), 
                    alert: I18n.t('agency.place_sports.delete_failed', default: 'Failed to close sport field.')
      end
    end

    def restore
      if @place_sport.update(is_close: false)
        redirect_to agency_place_sport_path(@place_sport), 
                    notice: I18n.t('agency.place_sports.restored_successfully', default: 'Sport field opened successfully.')
      else
        redirect_to agency_place_sport_path(@place_sport), 
                    alert: I18n.t('agency.place_sports.restore_failed', default: 'Failed to open sport field.')
      end
    end

    def toggle_maintenance
      new_maintenance_status = !@place_sport.maintenance_sport
      
      if @place_sport.update(maintenance_sport: new_maintenance_status)
        message = new_maintenance_status ? 
                  I18n.t('agency.place_sports.maintenance_enabled', default: 'Maintenance mode enabled.') :
                  I18n.t('agency.place_sports.maintenance_disabled', default: 'Maintenance mode disabled.')
        redirect_to agency_place_sport_path(@place_sport), notice: message
      else
        redirect_to agency_place_sport_path(@place_sport), 
                    alert: I18n.t('agency.place_sports.maintenance_toggle_failed', default: 'Failed to toggle maintenance mode.')
      end
    end

    private

    def agency_place_sports
      PlaceSport.where(place_id: current_agency_place_ids)
    end

    def set_place_sport
      @place_sport = agency_place_sports.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to agency_place_sports_path, alert: I18n.t('agency.place_sports.not_found', default: 'Sport field not found.')
    end

    def load_available_places
      @available_places = current_agency_places
    end

    def place_sport_params
      params.require(:place_sport).permit(
        :place_id,
        :sportfield_id,
        :price_per_hour_vnd,
        :price_per_hour_usd,
        :is_close,
        :maintenance_sport
      )
    end
  end
end
