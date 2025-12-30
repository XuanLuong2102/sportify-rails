class Admin::PlaceSportsController < Admin::AdminController
  include PaginatableConcern

  before_action :set_place
  before_action :set_place_sport, only: %i[edit update destroy soft_delete restore]
  before_action :load_sport_fields, only: %i[new edit create update]
  before_action :per_page_default, only: [:index]

  def index
    @place_sports = @place.place_sports.includes(:sportfield)
                          .paginate(page: params[:page], per_page: params[:per_page])
  end

  def new
    @place_sport = @place.place_sports.new
  end

  def create
    @place_sport = @place.place_sports.new(place_sport_params)
    if @place_sport.save
      redirect_to admin_place_place_sports_path(@place), notice: 'Created'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @place_sport.update(place_sport_params)
      redirect_to admin_place_place_sports_path(@place), notice: 'Updated'
    else
      render :edit
    end
  end

  def soft_delete
    if @place_sport.update(is_close: true)
      redirect_to admin_place_place_sports_path(@place), notice: 'Closed'
    else
      redirect_to admin_place_place_sports_path(@place), alert: 'Failed to close'
    end
  end

  def restore
    if @place_sport.update(is_close: false)
      redirect_to admin_place_place_sports_path(@place), notice: 'Restored'
    else
      redirect_to admin_place_place_sports_path(@place), alert: 'Failed to restore'
    end
  end

  private

  def set_place
    @place = Place.find(params[:place_id])
  end

  def set_place_sport
    @place_sport = @place.place_sports.find(params[:id])
  end

  def load_sport_fields
    @sportfields = Sportfield.all
  end

  def per_page_default
    params[:per_page] = 5
  end

  def place_sport_params
    params.require(:place_sport).permit(
      :sportfield_id,
      :price_per_hour_usd,
      :price_per_hour_vnd,
      :is_close,
      :maintenance_sport
    )
  end
end
