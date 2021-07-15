# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :set_book, only: [:show]
  # before_action :get_subjects, only: [:awards]

  def index
    letter = params[:id] ? params[:id] : "a"
    unless letter == "numeric"
      @books = Book.where("sort_title LIKE ?", "#{letter}%").order(:sort_title).page params[:page]
    else
      @books = Book.where("sort_title regexp ?", "^[0-9]+").order(:sort_title).page params[:page]
    end
    @selected = letter
  end

  def show
    @reviews = Review.where(book_id: @book.xml_id)
    @series = Series.find_by(code: @book.series_id)
    @awards = [@book.award, @book.award2, @book.award3]
    @subjects = [Subject.find_by(code: @book.subject1), Subject.find_by(code: @book.subject2), Subject.find_by(code: @book.subject3)].compact
    @links = [[@book.label_1, @book.link_1], [@book.label_2, @book.link_2], [@book.label_3, @book.link_3]]
  end

  def awards
    @awards_by_year = Book.where.not(award_year: nil)
                          .or(Book.where.not(award_year2: nil))
                          .or(Book.where.not(award_year3: nil))
                          .select { |b| show_status.include?(b.status) }
                          .pluck(:award_year, :award_year2, :award_year3)
                          .flatten
                          .reject(&:blank?)
                          .sort
                          .reverse

    get_subjects(
      Book.where.not(award: nil)
      .or(Book.where.not(award2: nil))
      .or(Book.where.not(award3: nil))
      .select { |b| show_status.include?(b.status) }
      .map { |b| b.subjects_as_tuples }
      .reject(&:blank?)
    )

    @awards_by_subject = @subjects.uniq.sort_by { |h| h[0] }

    @recent_winners = Book.where(featured_award_winner: true)
                                .where.not(award_year: nil)
                                .or(Book.where.not(award_year2: nil))
                                .or(Book.where.not(award_year3: nil))
                                .select { |b| show_status.include?(b.status) }
                                .take(4)
                                .sort_by { |b| b.sort_title }
  end

  def get_subjects(tuples)
    @subjects = []
    tuples.each do |subject|
      subject.each do |s|
        @subjects << s
      end
      @subjects.uniq
    end
  end

  def awards_by_year
    @books = Book.where.not(award_year: nil)
                  .where(award_year: params[:id])
                  .or(Book.where(award_year2: params[:id]))
                  .or(Book.where(award_year3: params[:id]))
                  .select { |b| show_status.include?(b.status) }
                  .sort_by { |b| b.sort_title }
  end

  def awards_by_subject
    @books = Book.where("subjects LIKE ?", "%#{params[:id]}%")
                  .select { |b| show_status.include?(b.status) }
                  .sort_by { |b| b.sort_title }
  end

  private
    def set_book
      @book = Book.find_by(xml_id: params[:id])
    end
end
