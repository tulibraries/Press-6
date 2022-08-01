# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :set_book, only: %i[show study_guide]
  include SetInstance

  def index
    letter = params[:id] || "a"
    @books = if letter == "numeric"
      Book.displayable
          .where("sort_title regexp ?", "^[0-9]+")
          .order(:sort_title)
          .page params[:page]
             else
               Book.displayable
                   .where("sort_title LIKE ?", "#{letter}%")
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
    @see_alsos = @book.books.sort_by(&:sort_title).take(4)
    @requestable = Book.displayable.requestable.include? @book
  end

  def awards
    @awards_by_year = books_with_awards
                      .pluck(:award_year, :award_year2, :award_year3)
                      .flatten
                      .reject(&:blank?)
                      .sort
                      .reverse
                      .uniq

    awards_by_subject = get_subjects(books_with_awards
                                      .map(&:subjects_as_tuples)
                                      .reject(&:blank?))
    subjects = []

    awards_by_subject.each do |subject|
      s = Subject.find_by(code: subject[1])
      subjects << s if s.present?
    end

    if subjects.any? nil
      @awards_by_subject = subjects.compact!
    else
      @awards_by_subject = subjects
    end

    recent_winners = books_with_awards
                     .select { |b| b.featured_award_winner == true }
                     .uniq

    first_position = recent_winners.select do |b|
      b.featured_award_weight == 1
    end.sort_by(&:updated_at).take(1).first
    second_position = recent_winners.select do |b|
      b.featured_award_weight == 2
    end.sort_by(&:updated_at).take(1).first
    third_position = recent_winners.select do |b|
      b.featured_award_weight == 3
    end.sort_by(&:updated_at).take(1).first
    fourth_position = recent_winners.select do |b|
      b.featured_award_weight == 4
    end.sort_by(&:updated_at).take(1).first

    @recent_winners = [first_position, second_position, third_position, fourth_position].compact!
  end

  def awards_by_year
    if params[:id].present? && params[:id].to_i > 0
      @books = Book.displayable
                 .where("award_year LIKE ?", params[:id])
                 .or(Book.where("award_year2 LIKE ?", params[:id]))
                 .or(Book.where("award_year3 LIKE ?", params[:id]))
                 .order(:sort_title)
    else
      redirect_to :awards
    end
  end

  def awards_by_subject
    @subject = is_number?(params[:id]) ? Subject.find_by(code: params[:id]) : Subject.friendly.find(params[:id])

    @books = books_with_awards
             .select { |b| b.subjects.include?(@subject.code) }
             .sort_by(&:sort_title)
             .uniq
  end

  def course_adoptions
    @books = Book.displayable
                 .where(course_adoption: true)
                 .order(:title)
  end

  def study_guides
    if params[:id].blank?
      @books = Book.displayable.where(active_guide: true)
    end
  end

  def study_guide; end

  private

    def set_book
      @book = find_instance
    end

    def books_with_awards
      Book.displayable.select {
        |b| b.award_year.present?
        } +
        Book.select {
          |b| b.award_year2.present?
          } +
          Book.select do |b|
            b.award_year3.present?
          end.uniq
    end

    def get_subjects(tuples)
      subjects = []
      tuples.each do |subject|
        subject.each do |s|
          subjects << s unless s.any?(&:nil?)
        end
        subjects.reject(&:blank?)
      end
      subjects.uniq.sort_by { |h| h[0] }
    end
end
