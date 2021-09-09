class SearchesController < ApplicationController
  def search
    @area = params[:area]
    @category = params[:category]
    if @category.present? && @area.present?
      @articles = Article.where("area LIKE? AND category LIKE?", "#{@area}", "#{@category}")
    elsif @category.present?
      @articles = Article.where("category LIKE?",  "#{@category}")
    elsif @area.present?
      @articles = Article.where("area LIKE?",  "#{@area}")
    else
      @articles = Article.all
    end
  end
end

