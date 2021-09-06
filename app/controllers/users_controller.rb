class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @articles = @user.articles.page(params[:page]).per(5)
  end

  def edit

  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "プロフィールを更新しました"
    else
      render :new
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :profile_image, :introduction)
    end

    def ensure_correct_user
      @user = User.find(params[:id])
      if @user != current_user
        redirect_to user_path(@user)
      end
    end
end
