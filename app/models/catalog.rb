# frozen_string_literal: true

class Catalog < ApplicationRecord
  before_save :set_century, :set_season, :set_title
  has_many :books, dependent: :destroy

  def show_status
    ["NP", "IP","OS","OP"]
  end

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
    
