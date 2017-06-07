# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :allow_without_password, only: [:update]

  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  def index
    authorize User
    @users = policy_scope(User).page(params[:page])
  end

  def show
    authorize @user
  end

  def new
    authorize User
    @user = User.new
  end

  def edit
    authorize @user
  end

  def create
    authorize User
    @user = User.new(permitted_attributes(User))

    if @user.save
      @user.skip_notifications!
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize @user

    if @user.update(permitted_attributes(@user))
      @user.skip_notifications!
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @user

    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def allow_without_password
    return unless params[:user][:password].blank? && params[:user][:password_confirmation].blank?

    params[:user].delete(:password)
    params[:user].delete(:password_confirmation)
  end
end
