# frozen_string_literal: true

class Author < ApplicationRecord
  include Friendable

  before_validation :set_title

  validates :author_id, :last_name, presence: true

  paginates_per 45

  def set_title
    self.title = [self.prefix, self.first_name, self.last_name, self.suffix].join(" ").strip
  end

  def index_title
    [self.first_name, self.last_name, self.suffix].join(" ").strip
  end

  def self.search(q)
    if q
      q = q.last.present? ? q : q[0...-1]
      Author.where("first_name REGEXP ?", "(^|\\W)#{q}(\\W|$)")
            .or(Author.where "last_name REGEXP ?", "(^|\\W)#{q}(\\W|$)")
            .sort_by { |a| [a.last_name, a.first_name] }
    end
  end
end
