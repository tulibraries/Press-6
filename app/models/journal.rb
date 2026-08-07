# frozen_string_literal: true

class Journal < ApplicationRecord
  include Friendable
  validates :title, :url, presence: true

  def self.search(q)
    if q
      q = q.last.present? ? q : q[0...-1]
      escaped_q = Regexp.escape(q)
      Journal.where("title ~* ?", "(^|\\W)#{escaped_q}(\\W|$)")
    end
  end
end
