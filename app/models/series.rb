# frozen_string_literal: true

class Series < ApplicationRecord
  include Imageable
  include Friendable

  validates :code, :title, presence: true
  validates :image, presence: false, blob: { content_type: ["image/png", "image/jpg", "image/jpeg", "image/gif"], size_range: 1..5.megabytes }

  has_one_attached :image
  has_many :books, primary_key: :code, class_name: "Book", dependent: :nullify

  validates :image, presence: false, blob: { content_type: ["image/png", "image/jpg", "image/jpeg", "image/gif"], size_range: 1..5.megabytes }
  validates :code, :title, presence: true

  def self.search(q)
		if q
			# @series = Series.where("title REGEXP ?", "(^|\\W)#{q}(\\W|$)")
			@series = Series.where("title LIKE ?", "%#{q}%")
		end
	end
end
