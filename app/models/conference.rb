# frozen_string_literal: true

class Conference < ApplicationRecord
  include Friendable

  validates :title, :start_date, :end_date, :location, presence: true

  def self.search(q)
	  if q
	    # @conferences = Conference.where("title REGEXP ?", "(^|\\W)#{q}(\\W|$)")
	    @conferences = Conference.where("title LIKE ?", "%#{q}%")
		end
	end
end
