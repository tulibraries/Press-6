class Faq < ApplicationRecord
  validates :title, :answer, presence: true
  has_rich_text :answer
end
