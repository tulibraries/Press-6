# frozen_string_literal: true

class SeriesController < ApplicationController
  before_action :set_series, only: :show

  def index
    @series = Series.all.order(:title)
  end

  def show
    @books = @series.books
                    .where(status: show_status)
                    .order(:sort_title)
                    .page params[:page]
  end

  private
    def set_series
      @series = Series.find_by(code: params[:id])
    end
end
