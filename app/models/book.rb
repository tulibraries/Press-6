# frozen_string_literal: true

class Book < ApplicationRecord
  include Imageable
  before_save :sort_titles

  has_rich_text :news_text
  has_rich_text :news_text

  has_many :reviews, foreign_key: "review_id", dependent: :destroy, inverse_of: :book
  has_many :books, class_name: "Book", dependent: :nullify

  belongs_to :series, optional: true
  belongs_to :catalog, optional: true
  belongs_to :special_offer, optional: true

  has_one_attached :cover_image, dependent: :destroy
  has_one_attached :excerpt, dependent: :destroy
  has_one_attached :suggested_reading_image, dependent: :destroy
  has_one_attached :guide_file, dependent: :destroy
  has_one_attached :toc_file, dependent: :destroy

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

  def subjects_as_tuples
    [JSON.parse(self.subjects)["subject"]].flatten.map { |h| [h["subject_title"], h["subject_id"]] }
  end

  def bindings_as_tuples
    [JSON.parse(self.bindings)["binding"]].flatten.select { |b| ["NP", "IP"].include? b["binding_status"] }.map { |b|
        {
          format: b["format"],
          price: b["price"],
          ean: b["ean"],
          status: b["binding_status"],
          pub_date: b["pub_date_for_format"]
        }}
  end
end
