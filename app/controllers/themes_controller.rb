class ThemesController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @themes = Theme.page(params[:page]).per(5).order(created_at: :DESC)
  end

  def new
    @theme = Theme.new
  end

  def create
    @theme = current_user.themes.new(theme_params)
    if @theme.save
      redirect_to themes_path
    else
      render :new
    end
  end



  private
    def theme_params
      params.require(:theme).permit(:content, :image)
    end
end
