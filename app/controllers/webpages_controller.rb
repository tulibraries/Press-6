# frozen_string_literal: true

class WebpagesController < ApplicationController
  before_action :set_webpage, only: %i[:show]

  def index
    @webpages = Webpage.all
  end

  def show
  end


  private
    def set_webpage
      @webpage = Webpage.find(params[:id])
    end
end
