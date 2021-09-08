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

  def unsubscribe
    @user = User.find(params[:id])
  end

  def withdraw
    @user = User.find(params[:id])
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会が完了しました。またのご利用を心よりお待ちしております。"
    redirect_to root_path
  end

  def follows
    @user = User.find(params[:id])
    @users = @user.followings
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers
  end

  def my_answer
    @user = User.find(params[:id])
    @answers = Answer.where(user_id: @user.id)
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
