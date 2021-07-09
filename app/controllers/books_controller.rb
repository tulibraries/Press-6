# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :set_book, only: [:show]

  def index
    @selected = params[:id] ? params[:id] : "a"
    unless @selected == "numeric"
      @books = Book.where("sort_title LIKE ?", "#{@selected}%").where(status: show_status)
                                                               .order(:sort_title)
                                                               .page params[:page]
    else
      @books = Book.where("sort_title regexp ?", "^[0-9]+").where(status: show_status)
                                                           .order(:sort_title)
                                                           .page params[:page]
    end
  end

  def show
    @reviews = Review.where(book_id: @book.xml_id)
    @series = Series.find_by(code: @book.series_id)
    @awards = [@book.award, @book.award2, @book.award3]
    @subjects = [Subject.find_by(code: @book.subject1), Subject.find_by(code: @book.subject2), Subject.find_by(code: @book.subject3)].compact
    @links = [[@book.label_1, @book.link_1], [@book.label_2, @book.link_2], [@book.label_3, @book.link_3]]
  end

  private
    def set_book
      @book = Book.find_by(xml_id: params[:id])
    end

    def show_status
      ["NP", "IP", "OS", "OP", "In Print"]
    end
end
