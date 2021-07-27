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

    def get_subjects(tuples)
      @subjects = []
      tuples.each do |subject|
        subject.each do |s|
          @subjects << s
        end
        @subjects.reject(&:blank?)
      end
      @subjects.uniq.sort_by { |h| h[0] }
    end
end
