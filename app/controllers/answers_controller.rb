class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @theme = Theme.find(params[:theme_id])
    answers =   if params[:sort] == "old"
                  @theme.answers.includes(:user).order(created_at: :ASC)
                elsif params[:sort] == "rate"
                  Answer.includes(:theme, :user).left_joins(:rates).where(theme_id: @theme.id).group(:id).order("SUM(rates.rate) DESC")
                else
                  @theme.answers.includes(:user).order(created_at: :DESC)
                end
    @answers = answers.page(params[:page]).per(5)


  end

  def show
    @theme = Theme.find(params[:theme_id])
    @answer = Answer.find(params[:id])
    @comment = Comment.new
    @rate = Rate.new
    @all_rate = @answer.rates.sum(:rate).round
  end

  def new
    @theme = Theme.find(params[:theme_id])
    @answer = Answer.new
  end

  def create
    @theme = Theme.find(params[:theme_id])
    @answer = current_user.answers.new(answer_params)
    @answer.theme_id = @theme.id
    if @answer.save
      redirect_to theme_answers_path(@theme)
    else
      render :new
    end
  end

  def answer_all
    answers = if params[:sort] == "old"
                Answer.includes(:theme).order(created_at: :ASC)
              elsif params[:sort] == "rate"
                Answer.includes(:theme).left_joins(:rates).group(:id).order("SUM(rates.rate) DESC")
              else
                Answer.includes(:theme).order(created_at: :DESC)
              end
    @answers = answers.page(params[:page]).per(5)
  end

  private

  def answer_params
    params.require(:answer).permit(:content)
  end
end
