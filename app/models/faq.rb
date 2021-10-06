# frozen_string_literal: true

class Faq < ApplicationRecord
  include Friendable

  validates :title, :answer, presence: true
  has_rich_text :answer
end
