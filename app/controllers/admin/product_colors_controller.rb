class Admin::ProductColorsController < Admin::AdminController
  include PaginatableConcern

  before_action :set_product_color, only: [:edit, :update, :soft_delete, :restore]

  def index
    @q = ProductColor.active.ransack(params[:q])
    @colors = @q.result(distinct: true).paginate(page: params[:page], per_page: params[:per_page])
  end

  def new
    @color = ProductColor.new
  end

  def create
    @color = ProductColor.new(product_color_params)
    if @color.save
      redirect_to admin_product_colors_path, notice: 'Color created successfully.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @color.update(product_color_params)
      redirect_to admin_product_colors_path, notice: 'Color updated successfully.'
    else
      render :edit
    end
  end

  def soft_delete
    @color.soft_delete
    redirect_to admin_product_colors_path, notice: 'Color deleted successfully.'
  end

  def restore
    @color.restore
    redirect_to admin_product_colors_path, notice: 'Color restored successfully.'
  end

  def deleted
    @q = ProductColor.deleted.ransack(params[:q])
    @colors = @q.result(distinct: true).page(params[:page]).per(10)
    render :index
  end

  private

  def set_product_color
    @color = ProductColor.find(params[:id])
  end

  def product_color_params
    params.require(:product_color).permit(:name, :code_rgb)
  end
end
