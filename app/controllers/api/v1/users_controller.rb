class Api::V1::UsersController < Api::ApiController
  before_action :set_user, only: [:show, :update]

  def show
    render_success(
      serialize_resource(@user, serializer: UserDetailSerializer),
      message: I18n.t('api.users.fetched_user_success')
    )
  end

  def update
    if @user.update(user_params)
      render_success(
        serialize_resource(@user, serializer: UserDetailSerializer),
        message: I18n.t('api.users.updated_user_success')
      )
    else
      render_unprocessable_entity(errors: @user.errors.full_messages)
    end
  end

  private

  def set_user
    @user = current_user_with_associations
  end

  def current_user_with_associations
    User.includes(:role).find(current_user.user_id)
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :middle_name,
      :last_name,
      :phone,
      :gender
    )
  end
end
