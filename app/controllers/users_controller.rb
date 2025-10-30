class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user, :ensure_correct_user, only: [:show]

  def show
    redirect_to user_path(current_user) unless check_current_user?
  end

  private

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
