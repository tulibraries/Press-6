# frozen_string_literal: true

class Oabook < ApplicationRecord
  include Imageable
  include Friendable

  validates :title, :isbn, :author, :collection, presence: true
  validates :image, presence: false, blob: { content_type: ["image/png", "image/jpg", "image/jpeg", "image/gif"], size_range: 1..5.megabytes }
  validates :pdf, presence: false, blob: { content_type: ["application/pdf"], size_range: 1..250.megabytes }
  validates :epub, presence: false, blob: { content_type: ["application/epub+zip"], size_range: 1..250.megabytes }
  validates :mobi, presence: false, blob: { content_type: ["application/x-mobipocket-ebook"], size_range: 1..250.megabytes }

  has_rich_text :description
  has_one_attached :image, dependent: :destroy
  has_one_attached :epub, dependent: :destroy
  has_one_attached :pdf, dependent: :destroy
  has_one_attached :mobi, dependent: :destroy

  validates :image, presence: false, blob: { content_type: ["image/png", "image/jpg", "image/jpeg", "image/gif"], size_range: 1..5.megabytes }
  validates :pdf, presence: false, blob: { content_type: ["application/pdf"], size_range: 1..250.megabytes }
  validates :epub, presence: false, blob: { content_type: ["application/epub+zip"], size_range: 1..250.megabytes }
  validates :mobi, presence: false, blob: { content_type: ["application/x-mobipocket-ebook"], size_range: 1..250.megabytes }

  def self.search(q)
	  if q
	    @oabooks = Oabook.where("title LIKE ?", "%#{q}%").or(Oabook.where("subtitle LIKE ?", "%#{q}%")).or(Oabook.where("author LIKE ?", "%#{q}%")).order(:title)
		end
	end
end
