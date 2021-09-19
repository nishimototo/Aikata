class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @theme = Theme.find(params[:theme_id])
    if params[:sort] == "old"
      @answers = @theme.answers.order(created_at: :ASC).page(params[:page]).per(5)
    elsif params[:sort] == "rate"
      @answers = Answer.left_joins(:rates).where(theme_id: @theme.id).group(:id).order("SUM(rates.rate) DESC").page(params[:page]).per(5)
    else
      @answers = @theme.answers.order(created_at: :DESC).page(params[:page]).per(5)
    end
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

  private

  def answer_params
    params.require(:answer).permit(:content)
  end
end
