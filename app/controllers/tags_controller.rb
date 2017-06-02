class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  # GET /tags
  # GET /tags.json
  def index
    authorize Tag
    @tags = policy_scope(Tag)
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
    authorize @tag
  end

  # GET /tags/new
  def new
    authorize Tag
    @tag = Tag.new
  end

  # GET /tags/1/edit
  def edit
    authorize @tag
  end

  # POST /tags
  # POST /tags.json
  def create
    authorize Tag
    @tag = Tag.new(permitted_attributes(Tag))

    respond_to do |format|
      if @tag.save
        format.html { redirect_to @tag, notice: 'Tag was successfully created.' }
        format.json { render :show, status: :created, location: @tag }
      else
        format.html { render :new }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tags/1
  # PATCH/PUT /tags/1.json
  def update
    authorize @tag
    respond_to do |format|
      if @tag.update(permitted_attributes(@tag))
        format.html { redirect_to @tag, notice: 'Tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    authorize @tag
    @tag.destroy
    respond_to do |format|
      format.html { redirect_to tags_url, notice: 'Tag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_tag
    @tag = Tag.find(params[:id])
  end
end
