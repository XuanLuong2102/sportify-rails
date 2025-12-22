class Admin::UsersController < Admin::AdminController
  include PaginatableConcern

  before_action :set_default_role_params, only: :index

  def index
    @q = User.includes(:role).active.ransack(params[:q])
    @users = @q.result(distinct: true)
    @users = @users.paginate(page: params[:page], per_page: params[:per_page])
  end

  private

  def set_default_role_params
    params[:q] ||= {}
    params[:q][:role_name_eq] ||= 'user'
  end
end
