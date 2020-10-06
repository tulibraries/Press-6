class Book < ApplicationRecord
  has_rich_text :news_text
  has_rich_text :is_guide_text

  has_one_attached :cover_image, dependent: :destroy
end
