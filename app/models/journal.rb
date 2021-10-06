# frozen_string_literal: true

class Journal < ApplicationRecord
  include Friendable
  validates :title, :url, presence: true

  def self.search(q)
	  if q
	    # @journals = Journal.where("title REGEXP ?", "(^|\\W)#{q}(\\W|$)")
	    @journals = Journal.where("title LIKE ?", "%#{q}%")
		end
	end
end
