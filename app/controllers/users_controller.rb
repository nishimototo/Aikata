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

  def my_chart
    @user = User.find(params[:id])
    @score = Answer.joins(:rates, :user).group(:user_id).where(user_id: @user.id).select('answers.user_id, users.name as user_name, sum(rates.rate) as sum_rate')
    if Rails.env.development?
      counts =  Answer.joins(:rates).where(user_id: @user.id).select("answers.user_id, STRFTIME('%Y-%m-%d', rates.created_at) as rate_created_at, sum(rates.rate) as sum_rate").group_by_day(:rate_created_at)
    else
      counts =  Answer.joins(:rates).where(user_id: @user.id).select("answers.user_id, DATE_FORMAT(rates.created_at, '%Y-%m-%d') as rate_created_at, sum(rates.rate) as sum_rate").group_by_day(:rate_created_at)
    end

    @counts = []
    counts.each do |count|
      @counts.push([count.rate_created_at, count.sum_rate])
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
