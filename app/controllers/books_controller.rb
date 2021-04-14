# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :set_book, only: [:show]

  def index
    @books = Book.where.not(title: "")
  end

  def show
    @reviews = Review.where(book_id: @book.xml_id)
    @series = Series.find_by(code: @book.series_id)
  end

  private
    def set_book
      @book = Book.find_by(xml_id: params[:id])
      @book = Book.find_by xml_id: params[:id]
    end
end
