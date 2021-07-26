# frozen_string_literal: true

class RemoveAwardFieldsFromBooks < ActiveRecord::Migration[6.0]
  def change
    change_table :books, bulk: true do |t|
      remove_column :books, :award, :string
      remove_column :books, :award2, :string
      remove_column :books, :award3, :string
      remove_column :books, :award4, :string
      remove_column :books, :award_year, :string
      remove_column :books, :award_year2, :string
      remove_column :books, :award_year3, :string
      remove_column :books, :award_year4, :string
    end
  end
end
