# frozen_string_literal: true

class Subject < ApplicationRecord
  include Friendable

  validates :pdf, presence: false, blob: { content_type: ["application/pdf"], size_range: 1..250.megabytes }
  validates :title, presence: true

  has_one_attached :pdf, dependent: :destroy

  has_many :subject_brochure, dependent: :nullify
  has_many :brochures, through: :subject_brochure, source: :brochure

  def self.search(q)
    if q
      Subject.where("title REGEXP ?", "(^|\\W)#{q}(\\W|$)").sort
    end
  end
end
