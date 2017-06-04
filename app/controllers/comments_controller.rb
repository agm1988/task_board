class CommentsController < ApplicationController
  before_action :find_commentable, only: [:create, :destroy]

  after_action :verify_authorized

  def create
    authorize Comment
    result = CommentService.run(commentable: @commentable,
                                author: current_user,
                                comment: params[:comment][:body])

    @comment = result.value
    if result.some?
      redirect_to @commentable
    else
      instance_variable_for_error_render
      render commentable_partial_path
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    authorize comment
    comment.destroy

    redirect_to @commentable
  end

  private

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
