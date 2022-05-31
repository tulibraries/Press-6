# frozen_string_literal: true

class Author < ApplicationRecord
  include Friendable

  before_validation :set_title

  validates :author_id, :last_name, presence: true

  has_one_attached :qa, dependent: :destroy
  validates :qa, presence: false, blob: { content_type: ["application/pdf"], size_range: 1..250.megabytes }

  paginates_per 45

  def set_title
    self.title = [prefix, first_name, last_name, suffix].join(" ").strip
  end

  def index_title
    [first_name, last_name, suffix].join(" ").strip
  end

  def self.search(q)
    if q
      q = q.last.present? ? q : q[0...-1]
      Author.where("first_name REGEXP ?", "(^|\\W)#{q}(\\W|$)")
            .or(Author.where("last_name REGEXP ?", "(^|\\W)#{q}(\\W|$)"))
            .sort_by { |a| [a.last_name, a.first_name] }
    end
  end
end
