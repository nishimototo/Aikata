class SearchesController < ApplicationController
  def search
    @area = params[:area]
    @category = params[:category]
    if @category.present? && @area.present?
      @articles = Article.where("area LIKE? AND category LIKE?", "#{@area}", "#{@category}").page(params[:page]).per(5).order(created_at: :DESC)
    elsif @category.present?
      @articles = Article.where("category LIKE?", "#{@category}").page(params[:page]).per(5).order(created_at: :DESC)
    elsif @area.present?
      @articles = Article.where("area LIKE?",  "#{@area}").page(params[:page]).per(5).order(created_at: :DESC)
    else
      @articles = Article.page(params[:page]).per(5).order(created_at: :DESC)
    end
  end
end
