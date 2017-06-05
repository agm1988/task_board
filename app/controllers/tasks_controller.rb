# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[edit update destroy]

  after_action :verify_authorized

  def show
    @task = Task.includes(comments: [:user, :commentable]).find(params[:id])

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
    @task = Task.includes(comments: [:user, :commentable]).find(params[:id])
  end
end
