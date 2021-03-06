# frozen_string_literal: true

class Book < ApplicationRecord
  include Imageable
  before_save :sort_titles, :get_excerpt

  validates :title, :xml_id, :author_byline, :status, presence: true

  has_one_attached :cover_image, dependent: :destroy
  has_one_attached :excerpt_file, dependent: :destroy
  has_one_attached :suggested_reading_image, dependent: :destroy
  has_one_attached :guide_file, dependent: :destroy
  has_one_attached :toc_file, dependent: :destroy

  validates :cover_image, presence: false, blob: { content_type: ["image/png", "image/jpg", "image/jpeg", "image/gif"], size_range: 1..5.megabytes }
  validates :suggested_reading_image, presence: false, blob: { content_type: ["image/png", "image/jpg", "image/jpeg", "image/gif"], size_range: 1..5.megabytes }
  validates :toc_file, presence: false, blob: { content_type: ["application/pdf"], size_range: 1..250.megabytes }
  validates :guide_file, presence: false, blob: { content_type: ["application/pdf"], size_range: 1..250.megabytes }
  validates :excerpt_file, presence: false, blob: { content_type: ["application/pdf"], size_range: 1..250.megabytes }

  has_rich_text :news_text

  has_many :reviews, foreign_key: "review_id", dependent: :destroy, inverse_of: :book
  has_many :books, class_name: "Book", dependent: :nullify

  belongs_to :series, optional: true
  belongs_to :special_offer, optional: true

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

  def get_excerpt
    if self.excerpt.present? && self.excerpt.include?("tempress/") # only runs during harvest
      self.excerpt_text = self.excerpt.split(/.pdf\"> */i)[1].present? ? self.excerpt.split(/.pdf\"> */i)[1].split(/<\/a> */i)[0] : "Read An Excerpt (pdf)."
      self.excerpt_file_name = self.excerpt.split(/tempress\/ */)[1].split(/\"> */)[0]
    end
  end

  def subjects_as_tuples
    [JSON.parse(self.subjects, symbolize_keys: true)["subject"]].flatten.map { |h| [h["subject_title"], h["subject_id"]] } if self.subjects.present?
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
