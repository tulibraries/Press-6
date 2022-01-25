# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :set_book, only: [:show, :study_guide]
  include SetInstance

  def index
    letter = params[:id] ? params[:id] : "a"
    unless letter == "numeric"
      @books = Book.where(status: show_status)
                    .where("sort_title LIKE ?", "#{letter}%")
                    .order(:sort_title)
                    .page params[:page]
    else
      @books = Book.where(status: show_status)
                    .where("sort_title regexp ?", "^[0-9]+")
                    .order(:sort_title)
                    .page params[:page]
    end
    @selected = letter
  end

  def show
    @reviews = Review.where(book_id: @book.xml_id)
    @series = Series.find_by(code: @book.series_id)
    @awards = [@book.award, @book.award2, @book.award3]
    @subjects = [
                  Subject.find_by(code: @book.subject1),
                  Subject.find_by(code: @book.subject2),
                  Subject.find_by(code: @book.subject3)
                ].compact
    @links = [
              [@book.label_1, @book.link_1],
              [@book.label_2, @book.link_2],
              [@book.label_3, @book.link_3],
              [@book.label_4, @book.link_4],
              [@book.label_5, @book.link_5],
              [@book.label_6, @book.link_6],
              [@book.label_7, @book.link_7],
              [@book.label_8, @book.link_8],
              [@book.label_9, @book.link_9],
              [@book.label_10, @book.link_10]
             ].compact
    @see_alsos = @book.books.sort_by { |b| b.sort_title }.take(4)
  end

  def awards
    @awards_by_year = books_with_awards
                        .select { |b| show_status.include?(b.status) }
                        .pluck(:award_year, :award_year2, :award_year3)
                        .flatten
                        .reject(&:blank?)
                        .sort
                        .reverse
                        .uniq

    awards_by_subject = get_subjects(books_with_awards
                                      .select { |b| show_status.include?(b.status) }
                                      .map { |b| b.subjects_as_tuples }
                                      .reject(&:blank?))

    subjects = []

    awards_by_subject.each do |subject|
      s = Subject.find_by(code: subject[1])
      subjects << s
    end

    @awards_by_subject = subjects

    @recent_winners = books_with_awards
                        .select { |b| show_status.include?(b.status) }
                        .select { |b| b.featured_award_winner == true }
                        .sort_by { |b| b.award_year }
                        .uniq
                        .take(4)
  end

  def awards_by_year
    @books = Book.where("award_year LIKE ?", "%#{params[:id]}%")
                .or(Book.where("award_year2 LIKE ?", "%#{params[:id]}%"))
                .or(Book.where("award_year3 LIKE ?", "%#{params[:id]}%"))
                .where(status: show_status)
                .order(:sort_title)
  end

  def awards_by_subject
    is_number?(params[:id]) ?
      @subject = Subject.find_by(code: params[:id])
      :
      @subject = Subject.friendly.find(params[:id])

    @books = books_with_awards
              .select { |b| b.subjects.include?(@subject.code) }
              .sort_by { |b| b.sort_title }
              .uniq
  end

  def course_adoptions
    @books = Book.where(status: show_status)
                 .where(course_adoption: true)
                 .sort_by { |b| b.sort_title }
  end

  def study_guides
    @books = Book.where(status: show_status)
                 .where(active_guide: true) if params[:id].blank?
  end

  def study_guide
  end


  private
    def set_book
      @book = find_instance
    end

    def books_with_awards
      Book.select { |b| b.award_year.present? } + Book.select { |b| b.award_year2.present? } + Book.select { |b| b.award_year3.present? }.uniq
    end

    def get_subjects(tuples)
      subjects = []
      tuples.each do |subject|
        subject.each do |s|
          subjects << s unless s.any? { |value| value.nil? }
        end
        subjects.reject(&:blank?)
      end
      subjects.uniq.sort_by { |h| h[0] }
    end
end
