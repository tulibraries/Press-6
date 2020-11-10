# frozen_string_literal: true

class WebpagesController < ApplicationController
  before_action :set_webpage, only: [:show, :edit, :update, :destroy]

  # GET /webpages
  # GET /webpages.json
  def index
    @webpages = Webpage.all
  end

  # GET /webpages/1
  # GET /webpages/1.json
  def show
  end

  # GET /webpages/new
  def new
    @webpage = Webpage.new
  end

  # GET /webpages/1/edit
  def edit
  end

  # POST /webpages
  # POST /webpages.json
  def create
    @webpage = Webpage.new(webpage_params)

    respond_to do |format|
      if @webpage.save
        format.html { redirect_to @webpage, notice: "Webpage was successfully created." }
        format.json { render :show, status: :created, location: @webpage }
      else
        format.html { render :new }
        format.json { render json: @webpage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /webpages/1
  # PATCH/PUT /webpages/1.json
  def update
    respond_to do |format|
      if @webpage.update(webpage_params)
        format.html { redirect_to @webpage, notice: "Webpage was successfully updated." }
        format.json { render :show, status: :ok, location: @webpage }
      else
        format.html { render :edit }
        format.json { render json: @webpage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /webpages/1
  # DELETE /webpages/1.json
  def destroy
    @webpage.destroy
    respond_to do |format|
      format.html { redirect_to webpages_url, notice: "Webpage was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_webpage
      @webpage = Webpage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def webpage_params
      params.fetch(:webpage, {})
    end
end
