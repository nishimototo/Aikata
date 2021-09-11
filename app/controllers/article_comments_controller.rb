class ArticleCommentsController < ApplicationController
  def create
    @article = Article.find(params[:article_id])
    @article_comment = current_user.article_comments.new(article_comment_params)
    @article_comment.article_id = @article.id
    if @article_comment.save
      @article.create_notification_comment!(current_user, @article_comment.id) #コメントしたら通知を作成。article.rbで定義
    else
      render "articles/show"
    end

  end

  def destroy
    @article = Article.find(params[:article_id])
    @article_comment = ArticleComment.find(params[:id])
    @article_comment.destroy
  end

  private
    def article_comment_params
      params.require(:article_comment).permit(:comment)
    end
end
