class Admins::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.page(params[:page]).per(5).order(created_at: :DESC)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admins_users_path
    else
      render :edit
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :is_deleted)
    end
end
