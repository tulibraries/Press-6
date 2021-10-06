# frozen_string_literal: true

class NewsItem < ApplicationRecord
  include Imageable
  include Friendable

  validates :title, :image, presence: true

  has_one_attached :image
  has_rich_text :description

  def self.search(q)
	  if q
	    # @news_items = NewsItem.where("title REGEXP ?", "(^|\\W)#{q}(\\W|$)")
	    @news_items = NewsItem.where("title LIKE ?", "%#{q}%")
		end
	end
end
