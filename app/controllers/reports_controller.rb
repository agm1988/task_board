# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy mark_as_reported]

  after_action :verify_authorized, except: :add_report
  after_action :verify_policy_scoped, only: :index

  has_scope :by_search, default: '', allow_blank: true, only: :index
  has_scope :by_user, only: :index

  def index
    authorize Report
    @reports = apply_scopes(policy_scope(Report), params).page(params[:page])
  end

  def show
    authorize @report
    @commentable = @report
    @comment = Comment.new
  end

  def new
    authorize Report

    @report = Report.new
    @report.tasks.build
  end

  def edit
    authorize @report
  end

  def create
    authorize Report

    @report = Report.new(permitted_attributes(Report))

    if @report.save
      Publish::ReportService.run(@report)
      redirect_to @report, notice: 'Report was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize @report

    if @report.update(permitted_attributes(@report))
      redirect_to @report, notice: 'Report was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @report

    @report.destroy
    redirect_to reports_url, notice: 'Report was successfully destroyed.'
  end

  def mark_as_reported
    authorize @report
    Notifications::ReportReportedJob.perform_async(@report.id)
    if @report.may_report? && @report.report!
      flash[:success] = 'Reported successfully'
    else
      flash[:error] = 'Could not be reported'
    end

    redirect_to @report
  end

  # TODO: use react
  def add_report
    @report = Report.find(params[:report_id])
  end

  private

  def set_report
    @report = Report.includes(tasks: [:tags], comments: [:user, :commentable]).find(params[:id])
  end
end
