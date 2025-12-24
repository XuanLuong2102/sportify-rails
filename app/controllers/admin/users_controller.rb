class Admin::UsersController < Admin::AdminController
  include PaginatableConcern

  before_action :set_user, only: %i[show edit update destroy]
  before_action :set_default_role_params, only: :index

  def index
    @q = User.includes(:role).active.ransack(params[:q])
    @users = @q.result(distinct: true)
    @users = @users.paginate(page: params[:page], per_page: params[:per_page])
  end

  def show
  end

  def new
    @user = User.new
    @roles = Role.all.pluck(:name, :role_id)
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: t('admin.users.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_default_role_params
    params[:q] ||= {}
    params[:q][:role_name_eq] ||= 'user'
  end

  def user_params
    params.require(:user).permit(
      :email,
      :username,
      :first_name,
      :middle_name,
      :last_name,
      :phone,
      :role_id,
      :password,
      :password_confirmation
    )
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
