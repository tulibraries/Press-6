# frozen_string_literal: true

class Person < ApplicationRecord
  include Imageable
  validates :name, :email, :department, presence: true

  has_rich_text :position_description
  has_rich_text :address
  has_one_attached :image, dependent: :destroy
  has_many :documents, dependent: :nullify

  validates :image, presence: false, blob: { content_type: ["image/png", "image/jpg", "image/jpeg", "image/gif"], size_range: 1..5.megabytes }

  def title
    name
  end

  def self.search(q)
	  if q
	    # @people = (Person.where("title REGEXP ?", "(^|\\W)#{q}(\\W|$)")).or(Person.where("position REGEXP ?", "(^|\\W)#{q}(\\W|$)"))
	    @people = Person.where("title LIKE ?", "%#{q}%").or(Person.where("position LIKE ?", "%#{q}%")).sort
		end
	end
end
