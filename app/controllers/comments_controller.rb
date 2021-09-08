class CommentsController < ApplicationController
  def create
    @answer = Answer.find(params[:answer_id])
    @comment = current_user.comments.new(comment_params)
    @comment.answer_id = @answer.id
    if @comment.save
      #redirect_to request.referer
    else
      @theme = Theme.find(params[:theme_id])
      render "answers/show"
    end
  end

  def destroy
    @answer = Answer.find(params[:answer_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    #redirect_to request.referer
  end

  private
    def comment_params
      params.require(:comment).permit(:comment, :rate)
    end
end
