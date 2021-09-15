# frozen_string_literal: true

class SubjectsController < ApplicationController
  before_action :set_subject, only: :show

  def index
    @subjects = Subject.all.order(:title)
  end

  def show
    @books = Book.where("subjects LIKE ?", "%#{params[:id]}%")
                  .where(status: show_status)
                  .order(:sort_title)
                  .page params[:page]
    @brochures = @subject.brochures
  end

  private
    def set_subject
      @subject = Subject.find_by(code: params[:id])
    end
end
