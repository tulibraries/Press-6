# frozen_string_literal: true

class Catalog < ApplicationRecord
  include Imageable
  include Friendable

  before_validation :set_title

  validates :code, presence: true

  has_many :brochures, class_name: "Brochure", dependent: :nullify
  has_many :books, primary_key: :code, class_name: "Book", dependent: :nullify
  has_one_attached :pdf, dependent: :destroy
  has_one_attached :image, dependent: :destroy

  def set_title
    if code.present?
      decade = code[2, 4]
      self.year = (decade >= "78" && decade <= "99") ? "19#{decade}" : "20#{decade}"
      self.season = code[0, 2].downcase == "fa" ? "Fall" : "Spring"
      self.title = "#{season} #{year}"
    end
  end
end
