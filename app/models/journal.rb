# frozen_string_literal: true

class Journal < ApplicationRecord
  include Friendable
  validates :title, :url, presence: true

  def self.search(q)
	  if q
	    Journal.where("title REGEXP ?", "(^|\\W)#{q}(\\W|$)")
		end
	end
end
