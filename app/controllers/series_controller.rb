# frozen_string_literal: true

class SeriesController < ApplicationController
  before_action :set_series, only: :show
  include SetInstance

  def index
    @series = Series.all.order(:title)
  end

  def show
    @books = @series.books
                    .displayable
                    .order(:sort_title)
                    .page params[:page]
  end

  private

    def set_series
      @series = find_instance
    end
end
