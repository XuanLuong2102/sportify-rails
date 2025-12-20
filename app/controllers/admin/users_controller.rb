class Admin::UsersController < Admin::AdminController
  include PaginatableConcern

  def index
    @users = User.includes(:role).active
    @users = @users.ransack(params[:q]).result(distinct: true)
    @users = @users.paginate(page: params[:page], per_page: params[:per_page])
  end

  private

  def set_default_role_params
    params[:q][:role_name_eq] ||= 'user'
  end
end
