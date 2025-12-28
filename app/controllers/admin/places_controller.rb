class Admin::PlacesController < Admin::AdminController
  include PaginatableConcern
  include ListHistoryConcern

  before_action :set_place, only: %i[show edit update soft_delete restore]
  before_action :ensure_active_place, only: %i[edit update]

  def index
    @q = Place.where(is_close: false).ransack(params[:q])
    @places = @q.result(distinct: true)
    @places = @places.paginate(page: params[:page], per_page: params[:per_page])
  end

  def deleted
    @q = Place.where(is_close: true).ransack(params[:q])
    @places = @q.result(distinct: true)
    @places = @places.paginate(page: params[:page], per_page: params[:per_page])
  end

  def show; end

  def new
    @place = Place.new
  end

  def create
    @place = Place.new(place_params)

    if @place.save
      redirect_to admin_places_path, notice: 'Place created successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @place.update(place_params)
      redirect_to helpers.back_to_list(admin_places_path), notice: 'Place updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def soft_delete
    if @place.update(is_close: true)
      redirect_to helpers.back_to_list(admin_places_path), notice: 'Place closed.'
    else
      redirect_to helpers.back_to_list(admin_places_path), alert: 'Failed to close place.'
    end
  end

  def restore
    if @place.update(is_close: false)
      redirect_to deleted_admin_places_path, notice: 'Place restored.'
    else
      redirect_to helpers.back_to_list(deleted_admin_places_path), alert: 'Failed to restore place.'
    end
  end

  private

  def set_place
    @place = Place.find(params[:id])
  end

  def ensure_active_place
    return if !@place.is_close?

    redirect_to helpers.back_to_list(admin_places_path), alert: 'Cannot edit a closed place.'
  end

  def place_params
    params.require(:place).permit(
      :name_en, :name_vi,
      :address_en, :address_vi,
      :city_en, :city_vi,
      :district_en, :district_vi,
      :open_time, :close_time,
      :description_en, :description_vi,
      :maintenance_place
    )
  end
end
