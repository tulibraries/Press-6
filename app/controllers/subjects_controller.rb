# frozen_string_literal: true

class SubjectsController < ApplicationController
  before_action :set_subject, only: :show
  include SetInstance

  def index
    @subjects = Subject.all.order(:title)
  end

  def show
    sort = params[:sort]
    @books = if sort.present? && sort == "year"
      Book.where("subjects LIKE ?", "%#{@subject.code}%")
          .where(status: show_status)
          .order("sort_year DESC")
          .page params[:page]
             else
               Book.where("subjects LIKE ?", "%#{@subject.code}%")
                   .where(status: show_status)
                   .order(:sort_title)
                   .page params[:page]
    end
    @brochures = @subject.brochures
  end

  private

    def set_subject
      @subject = find_instance
    end
end
