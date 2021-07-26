# frozen_string_literal: true

class AddAwardsToBooks < ActiveRecord::Migration[6.0]
  def change
    change_table :books, bulk: true do |t|
      add_column :books, :award_year, :string
      add_column :books, :award_year2, :string
      add_column :books, :award_year3, :string
    end
  end
end
