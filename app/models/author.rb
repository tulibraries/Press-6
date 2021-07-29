# frozen_string_literal: true

class Author < ApplicationRecord
  before_save :set_title,

  def set_title
    self.title = [self.prefix, self.first_name, self.last_name, self.suffix].join(" ").strip
  end
end
