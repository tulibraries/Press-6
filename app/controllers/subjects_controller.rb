# frozen_string_literal: true

class SubjectsController < ApplicationController
  before_action :set_subject, only: %i[show]

  def index
    @subjects = Subject.all.order(:title)
  end

  def show
  end

  private
    def set_subject
      @subject = Subject.find(params[:id])
    end
end
