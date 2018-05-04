class ArticlesController < ApplicationController
  load_and_authorize_resource

  def index
    @articles = Article.all
      .order("created_at DESC")
      .paginate(page: params[:page], per_page: 5)
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article
    else
      render :new
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      redirect_to @article
    else
      render :edit
    end
  end

  def destroy
    Article.find(params[:id]).try(:destroy)
    redirect_to articles_path
  end

  private

  def article_params
    params.require(:article).permit(:name, :text, :poster)
  end
end
