# frozen_string_literal: true

class AuthorsController < ApplicationController
  before_action :set_author, only: :show
  include SetInstance

  def index
    @selected = params[:id] || "a"
    @authors = Author.where(suppress: false)
                     .where("last_name ILIKE ?", "#{@selected}%")
                     .order(%i[last_name first_name])
                     .page params[:page]
  end

  def show
    @books = Book.displayable
                 .order(:sort_title)
                 .select { |b| b.author_ids.include?("\"#{@author.author_id}\"") }
  end

  private

    def set_author
      @author = find_instance
    end
end
