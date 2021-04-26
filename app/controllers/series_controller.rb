# frozen_string_literal: true

class SeriesController < ApplicationController
  before_action :set_series, only: %i[:show]

  def index
    @series = Series.all
  end

  def show
  end

  private
    def set_series
      @series = Series.find(params[:id])
    end
end
