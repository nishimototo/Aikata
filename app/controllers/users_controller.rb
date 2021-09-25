class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update, :unsubscribe, :withdraw]

  def show
    @user = User.find(params[:id])
    @articles = @user.articles.page(params[:page]).per(5).order(created_at: :DESC)
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
    if params[:sort] == "old"
      @answers = @user.answers.order(created_at: :ASC).page(params[:page]).per(5)
    elsif params[:sort] == "rate"
      @answers = Answer.left_joins(:rates).where(user_id: @user.id).group(:id).order("SUM(rates.rate) DESC").page(params[:page]).per(5)
    else
      @answers = @user.answers.order(created_at: :DESC).page(params[:page]).per(5)
    end
  end

  def my_chart
    @user = User.find(params[:id])
    @score = Answer.joins(:rates, :user).group(:user_id).where(user_id: @user.id).select('answers.user_id, sum(rates.rate) as sum_rate')
    if Rails.env.development?
      counts =  Answer.joins(:rates).where(user_id: @user.id).select("answers.user_id, STRFTIME('%Y-%m-%d', rates.created_at) as rate_created_at, sum(rates.rate) as sum_rate").group_by_day('rates.created_at').order('rates.created_at DESC')
    else
      counts =  Answer.joins(:rates).where(user_id: @user.id).select("answers.user_id, DATE_FORMAT(rates.created_at, '%Y-%m-%d') as rate_created_at, sum(rates.rate) as sum_rate").group_by_day('rates.created_at').order('rates.created_at DESC')
    end
    @counts = []
    counts.each do |count|
      @counts.push([count.rate_created_at, count.sum_rate])
      return if @counts.count > 6 #直近7日分の集計.↑でlimit(7)でも一緒か
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
