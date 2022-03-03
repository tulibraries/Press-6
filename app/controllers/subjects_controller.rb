# frozen_string_literal: true

class SubjectsController < ApplicationController
  before_action :set_subject, only: :show
  include SetInstance

  def index
    @subjects = Subject.all.order(:title)
  end

  def show
    sort = params[:sort]
    @books = Book.where("subjects LIKE ?", "%#{@subject.code}%")
                .where(status: show_status)
                .order(:sort_title)
                .page params[:page]
    # @books.sort_by(bindings_as_tuples.first[:pub_date])
    @brochures = @subject.brochures
  end

  private
    def set_subject
      @subject = find_instance
    end

end
