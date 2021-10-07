# frozen_string_literal: true

class Conference < ApplicationRecord
  include Friendable

  validates :title, :start_date, :end_date, :location, presence: true

  def self.search(q)
    if q
      Conference.where("title REGEXP ?", "(^|\\W)#{q}(\\W|$)")
    end
  end
end
