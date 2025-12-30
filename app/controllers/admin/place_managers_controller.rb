class Admin::PlaceManagersController < Admin::AdminController
  include PaginatableConcern
  include ListHistoryConcern

  before_action :set_place
  before_action :set_place_manager, only: %i[edit update destroy]

  def index
    @q = @place.place_managers.includes(:user).ransack(params[:q])
    @place_managers = @q.result(distinct: true)
    @place_managers = @place_managers.paginate(page: params[:page], per_page: params[:per_page])
  end

  def new
    @place_manager = @place.place_managers.new
    load_collections
  end

  def create
    @place_manager = @place.place_managers.new(place_manager_params)

    if @place_manager.save
      redirect_to admin_place_place_managers_path(@place), notice: t('admin.place_managers.notices.created')
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
      redirect_to helpers.back_to_list(admin_place_place_managers_path(@place)), notice: t('admin.place_managers.notices.updated')
    else
      load_collections
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @place_manager.destroy
    redirect_to helpers.back_to_list(admin_place_place_managers_path(@place)), notice: t('admin.place_managers.notices.deleted')
  end

  private

  def set_place
    @place = Place.find(params[:place_id])
  end

  def set_place_manager
    @place_manager = @place.place_managers.find(params[:id])
  end

  def place_manager_params
    params.require(:place_manager).permit(:place_id, :user_id)
  end

  def load_collections
    @users = User.by_role_agency.active.order(:first_name, :last_name)
  end
end
