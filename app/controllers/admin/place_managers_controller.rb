class Admin::PlaceManagersController < Admin::AdminController
  include PaginatableConcern
  include ListHistoryConcern

  before_action :set_place_manager, only: %i[show edit update destroy]

  def index
    @q = PlaceManager.includes(:place, :user).ransack(params[:q])
    @place_managers = @q.result(distinct: true)
    @place_managers = @place_managers.paginate(page: params[:page], per_page: params[:per_page])
  end

  def show; end

  def new
    @place_manager = PlaceManager.new
    load_collections
  end

  def create
    @place_manager = PlaceManager.new(place_manager_params)
    if @place_manager.save
      redirect_to admin_place_managers_path, notice: t('admin.place_managers.notices.created')
    else
      load_collections
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    load_collections
  end

  def update
    if @place_manager.update(place_manager_params)
      redirect_to helpers.back_to_list(admin_place_managers_path), notice: t('admin.place_managers.notices.updated')
    else
      load_collections
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @place_manager.destroy
    redirect_to helpers.back_to_list(admin_place_managers_path), notice: t('admin.place_managers.notices.deleted')
  end

  private

  def set_place_manager
    @place_manager = PlaceManager.find(params[:id])
  end

  def place_manager_params
    params.require(:place_manager).permit(:place_id, :user_id)
  end

  def load_collections
    @places = Place.order(:name_en)
    @users = User.by_role_agency.order(:first_name, :last_name)
  end
end
