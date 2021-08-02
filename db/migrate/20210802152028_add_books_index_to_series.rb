# frozen_string_literal: true

class AddBooksIndexToSeries < ActiveRecord::Migration[6.1]
  def change
    add_reference :series, :book, foreign_key: true
  end
end
