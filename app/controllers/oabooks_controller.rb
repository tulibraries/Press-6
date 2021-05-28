# frozen_string_literal: true

class OabooksController < ApplicationController
  before_action :set_oabook, only: [:show, :download_epub, :download_pdf, :download_mobi]

  def show
  end

  def north_broad_press
    @oabooks = Oabook.where(collection: "North Broad Press").order(:title)
    @total = @oabooks.count
    if @total.odd? || @total == 0
      @column_1 = @oabooks[0, ((@total / 2).floor + 1)]
    else
      @column_1 = @oabooks[0, (@total / 2).floor]
    end
    @column_2 = @oabooks.reverse[0, (@total / 2).floor]
    @page = Webpage.find_by(title: "North Broad Press Intro")
  end

  def labor_studies
    @oabooks = Oabook.where(collection: "Labor Studies & Work").order(:title)
    @total = @oabooks.count
    if @total.odd? || @total == 0
      @column_1 = @oabooks[0, ((@total / 2).floor + 1)]
    else
      @column_1 = @oabooks[0, (@total / 2).floor]
    end
    @column_2 = @oabooks.reverse[0, (@total / 2).floor]
    @page = Webpage.find_by(title: "Labor Studies & Work Intro")
  end

  private
    def set_oabook
      @oabook = Oabook.find_by(id: params[:id])
    end
end
