class Admin::SportfieldsController < Admin::AdminController
  include PaginatableConcern
  include ListHistoryConcern

  before_action :set_sportfield, only: %i[show edit update]

  def index
    @q = Sportfield.ransack(params[:q])
    @sportfields = @q.result(distinct: true)
    @sportfields = @sportfields.paginate(page: params[:page], per_page: params[:per_page])
  end

  def new
    @sportfield = Sportfield.new
  end

  def create
    @sportfield = Sportfield.new(sportfield_params)

    if @sportfield.save
      redirect_to admin_sportfields_path, notice: t('admin.sportfields.notices.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @sportfield.update(sportfield_params)
      redirect_to helpers.back_to_list(admin_sportfields_path), notice: t('admin.sportfields.notices.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_sportfield
    @sportfield = Sportfield.find(params[:id])
  end

  def sportfield_params
    params.require(:sportfield).permit(:name_en, :name_vi, :description_en, :description_vi)
  end
end
