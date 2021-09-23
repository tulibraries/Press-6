# frozen_string_literal: true

class Author < ApplicationRecord
  include Friendable

  before_save :set_title

  validates :author_id, :last_name, presence: true

  paginates_per 45

  def set_title
    self.title = [self.prefix, self.first_name, self.last_name, self.suffix].join(" ").strip
  end
end
