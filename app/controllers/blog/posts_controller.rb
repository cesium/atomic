class Blog::PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all
  end

  def show
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to [:blog, @post]
    else
      render :new
    end
  end

  def update
    if @post.update(post_params)
      redirect_to [:blog, @post]
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to blog_posts_url
  end

  private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body)
    end
end
