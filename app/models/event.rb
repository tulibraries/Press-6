# frozen_string_literal: true

class Event < ApplicationRecord
  include Friendable  
  include Imageable

  validates :title, :start_date, :end_date, presence: true

  has_rich_text :description
  has_rich_text :news_text
  has_one_attached :image

  def self.search(q)
    if q
      Event.where("title REGEXP ?", "(^|\\W)#{q}(\\W|$)")
    end
  end
end
