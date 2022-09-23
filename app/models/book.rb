# frozen_string_literal: true

class Book < ApplicationRecord
  include Imageable
  include Friendable

  before_validation :sort_titles
  before_save :catalog_code, :sort_date

  validates :title, :xml_id, :author_byline, :author_ids, :status, presence: true
  validates :cover_image, presence: false,
                          blob: { content_type: ["image/png", "image/jpg", "image/jpeg", "image/gif"], size_range: 1..5.megabytes }
  validates :suggested_reading_image, presence: false,
                                      blob: { content_type: ["image/png", "image/jpg", "image/jpeg", "image/gif"], size_range: 1..5.megabytes }
  validates :toc_file, presence: false, blob: { content_type: ["application/pdf"], size_range: 1..250.megabytes }
  validates :guide_file, presence: false, blob: { content_type: ["application/pdf"], size_range: 1..250.megabytes }
  validates :excerpt_file, presence: false, blob: { content_type: ["application/pdf"], size_range: 1..250.megabytes }
  validates :qa, presence: false, blob: { content_type: ["application/pdf"], size_range: 1..250.megabytes }

  has_one_attached :cover_image, dependent: :destroy
  has_one_attached :excerpt_file, dependent: :destroy
  has_one_attached :suggested_reading_image, dependent: :destroy
  has_one_attached :guide_file, dependent: :destroy
  has_one_attached :toc_file, dependent: :destroy
  has_one_attached :qa, dependent: :destroy

  has_rich_text :news_text
  has_rich_text :guide_text
  has_rich_text :award
  has_rich_text :award2
  has_rich_text :award3

  has_many :books, class_name: "Book", dependent: :nullify

  has_many :special_offer_book, dependent: :nullify
  has_many :special_offers, through: :special_offer_book, source: :special_offer

  belongs_to :series, optional: true

  scope :displayable, -> { where(suppress_from_view: [nil, false]).where(status: %w[NP IP]) }

  scope :requestable, -> {
    where("bindings LIKE ?", '%"format":"PB"%')
    .where(desk_copy: [nil, false])
  }

  def sort_titles
    if title.present?
      excludes = %w[A An The]
      sort_title = title
      first = sort_title.split.first
      if !first.nil? && excludes.include?(first.titlecase)
        sort_title = sort_title.sub(/^(the|a|an)\s+/i, "")
        sort_title = cleanup(sort_title)
        self.sort_title = I18n.transliterate("#{sort_title}, #{first}")
      else
        self.sort_title = I18n.transliterate(cleanup(sort_title))
      end
    end
  end

  def catalog_code
    catalog_id.downcase if catalog_id.present?
  end

  def subjects_as_tuples
    [JSON.parse(subjects)].flatten.map { |h| [h["subject_title"], h["subject_id"]] } if subjects.present?
  end

  def bindings_as_tuples
    [JSON.parse(bindings)["binding"]].flatten.select { |b| %w[NP IP].include? b["binding_status"] }.map do |b|
      {
        format: b["format"],
        price: b["price"],
        ean: b["ean"],
        status: b["binding_status"],
        pub_date: b["pub_date_for_format"]
      }
    end
  end

  def sort_date
    if bindings.present?
      bindings_as_tuples.each do |tuple|
        next if tuple[:pub_date].blank?
        date = tuple[:pub_date].split(" ")
        temp_year = (date[1].to_i <= 99 && date[1].to_i > 70) ? "19#{date[1]}" : "20#{date[1]}"
        self.sort_year = Date.parse("#{date[0]} #{temp_year}")
        self.sort_month = date[0]
      end
    end
  end

  def self.search(q)
    if q
      q = q.last.present? ? q : q[0...-1]
      Book.displayable
          .where("title REGEXP ?", "(^|\\W)#{q}(\\W|$)")
          .or(Book.where("sort_title REGEXP ?", "(^|\\W)#{q}(\\W|$)"))
          .or(Book.where("subtitle REGEXP ?", "(^|\\W)#{q}(\\W|$)"))
          .or(Book.where("author_byline REGEXP ?", "(^|\\W)#{q}(\\W|$)"))
          .or(Book.where(isbn: q))
          .order(:sort_title)
    end
  end

  def select_value
    "#{sort_title} -- #{author_byline}"
  end
end
