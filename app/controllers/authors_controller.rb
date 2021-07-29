# frozen_string_literal: true

class AuthorsController < ApplicationController
  before_action :set_author, only: :show

  def index
    @authors = Author.all
  end

  def show
    @books = Book.where(author_ids: [@author.id])
  end

  private
    def set_author
      @author = Author.find(params[:id])
    end
end
