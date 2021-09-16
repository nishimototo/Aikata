class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @article = Article.find(params[:article_id])
    @favorite = current_user.favorites.new(article_id: @article.id)
    @favorite.save
    @article.create_notification_favorite!(current_user) #いいねをした後通知を作成。article.rbで定義
  end

  def destroy
    @article = Article.find(params[:article_id])
    @favorite = current_user.favorites.find_by(article_id: @article.id)
    @favorite.destroy

  end
end
