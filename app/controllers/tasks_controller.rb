class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  def index
    authorize Task
    @tasks = policy_scope(Task)
  end

  def show
    authorize @task
    @commentable = @task
    @comment = Comment.new
  end

  def edit
    authorize @task
  end

  def update
    authorize @task
    if @task.update(permitted_attributes(@task))
      redirect_to @task, notice: 'Task was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @task
    @report = @task.report
    @task.destroy

    redirect_to @report, notice: 'User was successfully destroyed.'
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end
end
