# frozen_string_literal: true

class Webpage < ApplicationRecord
  include Imageable
  include Friendable

  validates :title, presence: true

  def self.search(q)
	  if q
			# @site = Webpage.where("title REGEXP ? AND id != 10 AND id != 11 AND id != 12", "(^|\\W)#{q}(\\W|$)").or(Page.where("content REGEXP ? AND id != 11 AND id != 12", "(^|\\W)#{q}(\\W|$)"))
			# @site = Webpage.where("title LIKE ? AND id != 10 AND id != 11 AND id != 12", "%#{q}%").or(Page.where("body LIKE ? AND id != 11 AND id != 12", "%#{q}%"))
		end
	end
  has_rich_text :body
end
