# frozen_string_literal: true

class OabooksController < ApplicationController
  before_action :set_oabook, only: [:show]

  def show
  end

  def north_broad_press
    @oabooks = Oabook.where(collection: "North Broad Press").order(:title)
    @page = Webpage.find_by(title: "North Broad Press Intro")
  end

  def labor_studies
    @oabooks = Oabook.where(collection: "Labor Studies & Work").order(:title)
    @page = Webpage.find_by(title: "Labor Studies & Work Intro")
  end

  private
    def set_oabook
      @oabook = find_instance
    end
end
