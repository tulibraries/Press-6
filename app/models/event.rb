# frozen_string_literal: true

class Event < ApplicationRecord
  include Friendable
  include Imageable

  validates :title, :start_date, :end_date, presence: true
  validates :image, presence: false,
                    blob: { content_type: Imageable::ALLOWED_IMAGE_TYPES, size_range: Imageable::IMAGE_SIZE_RANGE }

  has_rich_text :description
  has_rich_text :news_text
  has_one_attached :image

  def self.search(q)
    if q
      q = q.last.present? ? q : q[0...-1]
      Event.where("title ~* ?", "(^|\\W)#{q}(\\W|$)")
    end
  end
end
