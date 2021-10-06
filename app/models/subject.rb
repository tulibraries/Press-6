# frozen_string_literal: true

class Subject < ApplicationRecord
  include Friendable

  validates :pdf, presence: false, blob: { content_type: ["application/pdf"], size_range: 1..250.megabytes }
  validates :title, presence: true

  has_one_attached :pdf, dependent: :destroy
  has_many :brochures, class_name: "Brochure", dependent: :nullify

  def self.search(q)
		if q
			# @subjects = Subject.where("title REGEXP ?", "(^|\\W)#{q}(\\W|$)")
			@subjects = Subject.where("title LIKE ?", "%#{q}%")
		end
	end
end
