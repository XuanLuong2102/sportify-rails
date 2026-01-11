class Admin::ProductsController < Admin::AdminController
  include PaginatableConcern
  include ListHistoryConcern

  before_action :set_product, only: %i[edit update soft_delete restore destroy show]
  before_action :ensure_active_product, only: [:edit, :update]

  def index
    @q = Product.active.ransack(params[:q])
    @products = @q.result(distinct: true)
                  .includes(:product_brand, :category)
                  .includes(product_variants: :product_stocks)
                  .with_attached_thumbnail
                  .paginate(page: params[:page], per_page: params[:per_page])
  end

  def deleted
    @q = Product.where(is_active: false).ransack(params[:q])
    @products = @q.result(distinct: true).includes(:product_brand, :category)
    @products = @products.paginate(page: params[:page], per_page: params[:per_page])
  end

  def show
    @product = Product.includes(:product_brand, :category, 
                                product_variants: [:product_color, :product_size, :product_stocks])
                      .find(params[:id])
  end

  def new
    @product = Product.new
    load_brands_and_categories
    @colors = ProductColor.all
    @sizes = ProductSize.all
  end

  def create
    @product = Product.new(product_params)
    
    if @product.save
      # Create variants for selected sizes and colors
      create_variants_for_selection
      flash[:notice] = t('admin.products.created')
      redirect_to admin_products_path
    else
      load_brands_and_categories
      @colors = ProductColor.all
      @sizes = ProductSize.all
      flash.now[:alert] = t('admin.products.create_fail')
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    load_brands_and_categories
    @colors = ProductColor.all.pluck(:name, :id)
    @sizes = ProductSize.all.pluck(:name, :id)
  end

  def update
    if @product.update(product_params)
      flash[:notice] = t('admin.products.updated')
      redirect_to helpers.back_to_list(admin_products_path)
    else
      load_brands_and_categories
      flash.now[:alert] = t('admin.products.update_fail')
      render :edit, status: :unprocessable_entity
    end
  end

  def soft_delete
    if @product.update(is_active: false)
      flash[:notice] = t('admin.products.deleted')
      redirect_to helpers.back_to_list(admin_products_path)
    else
      flash[:alert] = t('admin.products.delete_failed')
      redirect_to helpers.back_to_list(admin_products_path)
    end
  end

  def restore
    if @product.update(is_active: true)
      flash[:alert] = t('admin.products.restored')
      redirect_to deleted_admin_products_path
    else
      flash[:alert] = t('admin.products.restore_failed')
      redirect_to helpers.back_to_list(deleted_admin_products_path)
    end
  end

  def destroy
    if @product.destroy
      flash[:notice] = t('admin.products.permanent_deleted')
      redirect_to deleted_admin_products_path
    else
      flash[:alert] = t('admin.products.destroy_failed')
      redirect_to deleted_admin_products_path
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def ensure_active_product
    return if @product.is_active?

    redirect_to helpers.back_to_list(admin_products_path),
                alert: t('admin.products.inactive_cannot_edit')
  end

  def load_brands_and_categories
    @brands = ProductBrand.all.pluck(:name, :id)
    @categories = ProductCategory.all.pluck(:name_en, :id)
  end

  def product_params
    params.require(:product).permit(
      :name_en, :name_vi, :brand_id, :category_id, :description_en, :description_vi, :thumbnail,
      product_variants_attributes: [:id, :product_color_id, :product_size_id, :price_vnd, :sku, :_destroy],
      product_images_attributes: [:id, :product_color_id, :image, :sort_order, :_destroy]
    )
  end

  def create_variants_for_selection
    selected_sizes = params[:selected_sizes].to_s.split(',').map(&:to_i).reject(&:zero?)
    selected_colors = params[:selected_colors].to_s.split(',').map(&:to_i).reject(&:zero?)
    base_price = params.dig(:product, :base_price).to_f

    selected_colors.each do |color_id|
      selected_sizes.each do |size_id|
        @product.product_variants.create(
          product_color_id: color_id,
          product_size_id: size_id,
          price_vnd: base_price,
          is_active: true
        )
      end
    end
  end
end
