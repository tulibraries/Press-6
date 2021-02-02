# frozen_string_literal: true

class Book < ApplicationRecord
  before_save :sort_titles

  has_rich_text :news_text
  has_rich_text :guide_text
  has_rich_text :excerpt_text
  has_rich_text :news_text

  has_many :reviews, foreign_key: "review_id", dependent: :destroy, inverse_of: :book
  has_many :books, class_name: "Book", dependent: :destroy, inverse_of: :book
  
  belongs_to :series, optional: true
  belongs_to :catalog, optional: true
  belongs_to :promotion, optional: true

  has_one_attached :cover_image, dependent: :destroy
  has_one_attached :excerpt_image, dependent: :destroy
  has_one_attached :suggested_reading_image, dependent: :destroy
  has_one_attached :guide_image, dependent: :destroy

  def sort_titles
    excludes = ["A", "An", "The"]
    sort_title = self.title
    first = sort_title.split.first
    if !first.nil? && excludes.include?(first.titlecase)
      sort_title = sort_title.sub(/^(the|a|an)\s+/i, "")
      self.sort_title = sort_title + ", " + first
    else
      self.sort_title = self.title
    end
  end
end
