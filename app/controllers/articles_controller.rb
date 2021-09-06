class ArticlesController < ApplicationController
  def index
    @articles = Article.page(params[:page]).per(5)
  end

  def show
  end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.new(article_params)
    if @article.save
      redirect_to articles_path, notice: "募集を投稿しました"
    else
      render :new
    end
  end

  def edit
  end

  private
    def article_params
      params.require(:article).permit(:title, :content, :area, :category)
    end
end
