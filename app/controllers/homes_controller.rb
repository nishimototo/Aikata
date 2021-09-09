class HomesController < ApplicationController
  def top
    @articles = Article.limit(5).order(created_at: :DESC)
  end
end
