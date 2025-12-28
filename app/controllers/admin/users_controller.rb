class Admin::UsersController < Admin::AdminController
  include PaginatableConcern
  include ListHistoryConcern

  before_action :set_default_role_params, only: :index
  before_action :set_user, only: %i[show edit update destroy update_role soft_delete restore]
  before_action :prevent_self_role_change, only: %i[update_role soft_delete]
  before_action :load_roles, only: %i[new create show update_role]

  def index
    @q = User.includes(:role).active.ransack(params[:q])
    @users = @q.result(distinct: true)
    @users = @users.paginate(page: params[:page], per_page: params[:per_page])
  end

  def deleted
    @q = User.includes(:role).deleted.ransack(params[:q])
    @users = @q.result(distinct: true)
    @users = @users.paginate(page: params[:page], per_page: params[:per_page])
  end

  

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: t('admin.users.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update_role
    if @user.update(role_params)
      redirect_to admin_user_path(@user), notice: t('admin.users.role_updated')
    else
      redirect_to admin_user_path(@user), alert: @user.errors.full_messages.first
    end
  end

  def soft_delete
    if @user.update(is_locked: true)
      redirect_to helpers.back_to_list(admin_users_path), 
                  notice: t('admin.users.deleted')
    else
      redirect_to helpers.back_to_list(admin_users_path),
                  alert: t('admin.users.delete_failed')
    end
  end

  def restore
    if @user.update(is_locked: false)
      redirect_to deleted_admin_users_path, notice: t('admin.users.restored')
    else
      redirect_to helpers.back_to_list(deleted_admin_users_path),
                  alert: t('admin.users.restore_failed')
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def load_roles
    @roles = Role.all.pluck(:name, :role_id)
  end

  def set_default_role_params
    params[:q] ||= {}
    params[:q][:role_name_eq] ||= 'user'
  end

  def user_params
    params.require(:user).permit(
      :email,
      :username,
      :phone,
      :role_id,
      :password,
      :password_confirmation
    )
  end

  def role_params
    params.require(:user).permit(:role_id)
  end

  def prevent_self_role_change
    if @user == current_user
      redirect_to admin_user_path(@user), alert: t('admin.users.cannot_change_own_role')
    end
  end
end
