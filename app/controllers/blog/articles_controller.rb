class Blog::ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  def index
    @articles = Article.all
  end

  def show
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to [:blog, @article]
    else
      render :new
    end
  end

  def update
    if @article.update(article_params)
      redirect_to [:blog, @article]
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to blog_articles_url
  end

  private

    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :body)
    end
end
