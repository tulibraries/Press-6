class Book < ApplicationRecord
  require 'pry'
  serialize :author_id, Array
	serialize :binding, Array
	serialize :subjects, Array
  serialize :in_series, Array
  
  has_rich_text :news_text
  has_rich_text :is_guide_text

  has_one_attached :cover_image, dependent: :destroy
  has_one_attached :excerpt_image, dependent: :destroy
  has_one_attached :suggested_reading_image, dependent: :destroy
  has_one_attached :guide_image, dependent: :destroy

end
