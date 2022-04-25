# frozen_string_literal: true

class AddDateSortFieldsToBook < ActiveRecord::Migration[6.1]
  def change
    change_table :books, bulk: true do |t|
      add_column :books, :sort_year, :string
      add_column :books, :sort_month, :string
    end
  end
end
