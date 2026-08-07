# frozen_string_literal: true

class Conference < ApplicationRecord
  include Friendable

  validates :title, :start_date, :end_date, :location, presence: true

  def self.search(q)
    if q
      q = q.last.present? ? q : q[0...-1]
      escaped_q = Regexp.escape(q)
      Conference.where("title ~* ?", "(^|\\W)#{escaped_q}(\\W|$)")
    end
  end
end
