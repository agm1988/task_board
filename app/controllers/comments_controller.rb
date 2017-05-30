class CommentsController < ApplicationController
  before_action :find_commentable, only: [:create, :destroy]

  def create
    @comment = @commentable.comments.new(comment_params)

    if @comment.save
      redirect_to @commentable
    else
      instance_variable_for_error_render
      render commentable_partial_path
    end
  end

  def destroy
    Comment.find(params[:id]).destroy

    redirect_to @commentable
  end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :body)
  end

  def find_commentable
    klass = [Task, Report].detect { |c| params["#{c.name.underscore}_id"] }

    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

  def instance_variable_for_error_render
    instance_variable_set("@#{@commentable.class.name.downcase}", @commentable)
  end

  def commentable_partial_path
    "#{@commentable.class.name.downcase.pluralize}/show"
  end
end
