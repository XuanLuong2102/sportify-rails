class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user, :ensure_correct_user, only: [:show, :edit, :update]

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: t('messages.users.update.success')
    else
      flash.now[:alert] = t('messages.users.update.failed')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :first_name,
      :middle_name,
      :last_name,
      :email,
      :phone,
      :gender
    )
  end

  def load_user
    @user = User.find_by(user_id: params[:id])
  end

  def ensure_correct_user
    redirect_to user_path(current_user) unless check_current_user?
  end

  def check_current_user?
    current_user == @user
  end
end
