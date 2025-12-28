class Admin::SuppliersController < Admin::AdminController
  include PaginatableConcern
  include ListHistoryConcern

  before_action :set_supplier, only: %i[edit update soft_delete restore]
  before_action :ensure_active_supplier, only: [:edit, :update]

  def index
    @q = Supplier.active.ransack(params[:q])
    @suppliers = @q.result(distinct: true)
    @suppliers = @suppliers.paginate(page:params[:page], per_page: params[:per_page])
  end

  def deleted
    @q = Supplier.inactive.ransack(params[:q])
    @suppliers = @q.result(distinct: true)
    @suppliers = @suppliers.paginate(
      page: params[:page],
      per_page: params[:per_page]
    )
  end

  def new
    @supplier = Supplier.new
  end

  def create
    @supplier = Supplier.new(supplier_params)

    if @supplier.save
      redirect_to admin_suppliers_path, notice: "Supplier created successfully."
    else
      @suppliers = Supplier.order(:name)
      render :index, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @supplier.update(supplier_params)
      redirect_to helpers.back_to_list(admin_suppliers_path),
                  notice: t('admin.suppliers.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def soft_delete
    if @supplier.soft_delete!
      redirect_to helpers.back_to_list(admin_suppliers_path),
                  notice: t('admin.suppliers.deleted')
    else
      redirect_to helpers.back_to_list(admin_suppliers_path),
                  alert: t('admin.suppliers.delete_failed')
    end
  end

  def restore
    if @supplier.restore!
      redirect_to helpers.back_to_list(admin_suppliers_path),
                  notice: t('admin.suppliers.restored')
    else
      redirect_to helpers.back_to_list(admin_suppliers_path),
                  alert: t('admin.suppliers.restore_failed')
    end
  end

  private

  def set_supplier
    @supplier = Supplier.find(params[:id])
  end

  def ensure_active_supplier
    return if @supplier.is_active?

    redirect_to helpers.back_to_list(admin_suppliers_path),
                alert: t('admin.suppliers.inactive_cannot_edit')
  end

  def supplier_params
    params.require(:supplier).permit(
      :name,
      :code,
      :contact_name,
      :phone,
      :email,
      :address,
      :note
    )
  end
end
