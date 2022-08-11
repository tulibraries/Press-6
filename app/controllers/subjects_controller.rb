# frozen_string_literal: true

class SubjectsController < ApplicationController
  before_action :set_subject, only: :show
  include SetInstance

  def index
    @subjects = Subject.all.order(:title)
  end

  def show
    sort = params[:sort]
    @books =  if sort.present? && sort == "year"
                Book.displayable
                    .where("subjects LIKE ?", "%#{@subject.code}%")
                    .order("sort_year DESC")
                    .page params[:page]
              else
                Book.displayable
                    .where("subjects LIKE ?", "%#{@subject.code}%")
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
