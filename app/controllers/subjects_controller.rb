# frozen_string_literal: true

class SubjectsController < ApplicationController
  before_action :set_subject, only: :show
  include SetInstance

  def index
    @subjects = Subject.all.order(:title)
  end

  def show
    sort = params[:sort]
    if sort.present? && sort == "year"
      @books =  Book.displayable
                    .where("subjects ILIKE ?", "%#{@subject.code}%")
                    .order("sort_year DESC")
                    .page params[:page]
    else
      @books =  Book.displayable
                    .where("subjects ILIKE ?", "%#{@subject.code}%")
                    .order(:sort_title)
                    .page params[:page]
    end
    @brochures = @subject.brochures if @subject.brochures.any?
    @page = params[:page] ? false : true
  end

  private

    def set_subject
      @subject = find_instance
    end
end
