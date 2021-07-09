# frozen_string_literal: true

class Catalog < ApplicationRecord
  before_save :set_century, :set_season, :set_title
  validates :title, :code, :season, :year, presence: true

  has_many :books, primary_key: :code, class_name: "Book", dependent: :nullify
  has_one_attached :pdf, dependent: :destroy

  def set_century
    decade = self.code[2, 4]
    self.year = (decade >= "78" && decade <= "99") ? "19#{decade}" : "20#{decade}"
  end

  def set_season
    self.season = code[0, 2].downcase == "fa" ? "Fall" : "Spring"
  end

  def set_title
    self.title = "#{self.season} #{self.year}"
  end
end
