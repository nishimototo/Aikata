class SearchesController < ApplicationController
  def search
    @area = params[:area]
    @category = params[:category]
    if @category.present? && @area.present?
      @articles = Article.includes([:user]).where("area LIKE? AND category LIKE?", "#{@area}", "#{@category}").page(params[:page]).per(5).order(created_at: :DESC)
    elsif @category.present?
      @articles = Article.includes([:user]).where("category LIKE?", "#{@category}").page(params[:page]).per(5).order(created_at: :DESC)
    elsif @area.present?
      @articles = Article.includes([:user]).where("area LIKE?",  "#{@area}").page(params[:page]).per(5).order(created_at: :DESC)
    else
      @articles = Article.includes([:user]).page(params[:page]).per(5).order(created_at: :DESC)
    end
  end
end
