# frozen_string_literal: true

class Journal < ApplicationRecord
  include Friendable
  validates :title, :url, presence: true

  def self.search(q)
    if q
      q = q.last.present? ? q : q[0...-1]
      Journal.where("title REGEXP ?", "(^|\\W)#{q}(\\W|$)")
    end
  end
end
