class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @theme = Theme.find(params[:theme_id])
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
