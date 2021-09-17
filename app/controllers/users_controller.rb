class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update, :unsubscribe, :withdraw]

  def show
    @user = User.find(params[:id])
    @articles = @user.articles.page(params[:page]).per(5).order(created_at: :DESC)
    #@total_rate = Answer.joins(:rates).where(user_id: @user.id).sum(:rate)
  end

  def edit

  end

  def update
    if @user.update(user_params)
      bypass_sign_in(@user)
      redirect_to user_path(@user), notice: "プロフィールを更新しました"
    else
      render :edit
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
    if params[:sort]
      @answers = @user.answers.page(params[:page]).per(5).order(params[:sort])
    else
      @answers = @user.answers.page(params[:page]).per(5).order(created_at: :DESC)
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
