# frozen_string_literal: true

class WebpagesController < ApplicationController
  before_action :set_webpage, only: %i[show]

  def index
  end

  def show
  end


  private
    def set_webpage
      @page = Webpage.find(params[:id])
    end
end
