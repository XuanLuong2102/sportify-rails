class Admin::PlacesController < Admin::AdminController
  include PaginatableConcern
  include ListHistoryConcern

  before_action :set_place, only: %i[show edit update soft_delete restore]
  before_action :ensure_active_place, only: %i[edit update]

  def index
    @q = Place.active.ransack(params[:q])
    @places = @q.result(distinct: true)
    @places = @places.paginate(page: params[:page], per_page: params[:per_page])
  end

  def deleted
    @q = Place.closed.ransack(params[:q])
    @places = @q.result(distinct: true)
    @places = @places.paginate(page: params[:page], per_page: params[:per_page])
  end

  def new
    @place = Place.new
  end

  def create
    @place = Place.new(place_params)

    if @place.save
      redirect_to admin_places_path, notice: t('admin.places.notices.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @place.update(place_params)
      redirect_to helpers.back_to_list(admin_places_path), notice: t('admin.places.notices.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def soft_delete
    if @place.update(is_close: true)
      redirect_to helpers.back_to_list(admin_places_path), notice: t('admin.places.notices.closed')
    else
      redirect_to helpers.back_to_list(admin_places_path), alert: t('admin.places.alerts.failed_to_close')
    end
  end

  def restore
    if @place.update(is_close: false)
      redirect_to deleted_admin_places_path, notice: t('admin.places.notices.restored')
    else
      redirect_to helpers.back_to_list(deleted_admin_places_path), alert: t('admin.places.alerts.failed_to_restore')
    end
  end

  private

  def set_place
    @place = Place.find(params[:id])
  end

  def ensure_active_place
    return unless @place.is_close

    redirect_to helpers.back_to_list(admin_places_path), alert: t('admin.places.alerts.cannot_edit_closed_place')
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
