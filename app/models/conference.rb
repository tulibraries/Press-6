# frozen_string_literal: true

class Conference < ApplicationRecord
  include Friendable

  validates :title, :start_date, :end_date, :location, presence: true

  def self.search(q)
    if q
      q = q.last.present? ? q : q[0...-1]
      Conference.where("title REGEXP ?", "(^|\\W)#{q}(\\W|$)")
    end
  end
end
