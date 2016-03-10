class Blog::CommentsController < ApplicationController
  before_action :set_publication, only: [:create, :destroy, :update]

  def create
    @comment = @publication.comments
      .create(comment_params.merge(user_id: current_user.id))
    redirect_to [:blog, @publication]
  end

  def destroy
    @comment = Comment.find(params[:id]).destroy
    redirect_to [:blog, @publication]
  end

  private
    def set_publication
      @publication = Publication.find(publication_id)
    end

    def comment_params
      params.require(:comment).permit(:body)
    end

    def publication_id
      params[:post_id] || params[:article_id]
    end
end
