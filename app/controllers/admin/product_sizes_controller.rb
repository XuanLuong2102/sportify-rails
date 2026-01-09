class Admin::ProductSizesController < Admin::AdminController
  include PaginatableConcern

  before_action :set_product_size, only: [:edit, :update, :soft_delete, :restore]

  def index
    @q = ProductSize.active.ransack(params[:q])
    @sizes = @q.result(distinct: true).paginate(page: params[:page], per_page: params[:per_page])
  end

  def new
    @size = ProductSize.new
  end

  def create
    @size = ProductSize.new(product_size_params)
    if @size.save
      redirect_to admin_product_sizes_path, notice: 'Size created successfully.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @size.update(product_size_params)
      redirect_to admin_product_sizes_path, notice: 'Size updated successfully.'
    else
      render :edit
    end
  end

  def soft_delete
    @size.soft_delete
    redirect_to admin_product_sizes_path, notice: 'Size deleted successfully.'
  end

  def restore
    @size.restore
    redirect_to admin_product_sizes_path, notice: 'Size restored successfully.'
  end

  def deleted
    @q = ProductSize.deleted.ransack(params[:q])
    @sizes = @q.result(distinct: true).page(params[:page]).per(10)
    render :index
  end

  private

  def set_product_size
    @size = ProductSize.find(params[:id])
  end

  def product_size_params
    params.require(:product_size).permit(:name)
  end
end
