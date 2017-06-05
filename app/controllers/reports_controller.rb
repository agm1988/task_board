# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy mark_as_reported]

  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  # GET /reports
  # GET /reports.json
  def index
    authorize Report
    @reports = policy_scope(Report).eager_load(:user)
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    authorize @report
    @commentable = @report
    @comment = Comment.new
  end

  # GET /reports/new
  def new
    authorize Report

    @report = Report.new
    @report.tasks.build
  end

  # GET /reports/1/edit
  def edit
    authorize @report
  end

  # POST /reports
  # POST /reports.json
  def create
    authorize Report

    @report = Report.new(permitted_attributes(Report))

    respond_to do |format|
      if @report.save
        format.html { redirect_to @report, notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    authorize @report

    respond_to do |format|
      if @report.update(permitted_attributes(@report))
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    authorize @report

    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
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

  private

  def set_report
    @report = Report.includes(tasks: [:tags], comments: [:user, :commentable]).find(params[:id])
  end
end
