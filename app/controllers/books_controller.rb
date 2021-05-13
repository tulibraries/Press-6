# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :set_book, only: [:show]

  def index
    @books = Book.all
  end

  def show
    @reviews = Review.where(book_id: @book.xml_id)
    @series = Series.find_by(code: @book.series_id)
    @awards = [@book.award, @book.award2, @book.award3]
    @subjects = [Subject.find_by(code: @book.subject1), Subject.find_by(code: @book.subject2), Subject.find_by(code: @book.subject3)].compact
  end

  private
    def set_book
      @book = Book.find_by(xml_id: params[:id])
    end
end
