class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = Answer.find(params[:answer_id])
    @comment = current_user.comments.new(comment_params)
    @comment.answer_id = @answer.id
    if @comment.save
      render "create.js.erb" # Rspec用にrender先を明示
    else
      @rate = Rate.new
      @theme = Theme.find(params[:theme_id])
      render "answers/show"
    end
  end

  def destroy
    @answer = Answer.find(params[:answer_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    render "destroy.js.erb" # Rspec用にrender先を明示
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
