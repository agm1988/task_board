# frozen_string_literal: true

class TagsController < ApplicationController
  before_action :set_tag, only: %i[show edit update destroy]

  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  has_scope :by_name, default: '', allow_blank: true, only: :index

  respond_to :json, :html
  def index
    authorize Tag
    @tags = apply_scopes(policy_scope(Tag), params).page(params[:page])

    respond_with(@tags)
  end

  def show
    authorize @tag
  end

  def new
    authorize Tag
    @tag = Tag.new
  end

  def edit
    authorize @tag
  end

  def create
    authorize Tag
    @tag = Tag.new(permitted_attributes(Tag))

    if @tag.save
      redirect_to @tag, notice: 'Tag was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize @tag

    if @tag.update(permitted_attributes(@tag))
      redirect_to @tag, notice: 'Tag was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @tag
    @tag.destroy

    redirect_to tags_url, notice: 'Tag was successfully destroyed.'
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end
end
