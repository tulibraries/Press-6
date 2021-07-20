# frozen_string_literal: true

class AddMoreLinksToBooks < ActiveRecord::Migration[6.1]
  def change
    change_table :books, bulk: true do |t|
      add_column :books, :link_4, :string
      add_column :books, :link_5, :string
      add_column :books, :link_6, :string
      add_column :books, :link_7, :string
      add_column :books, :link_8, :string
      add_column :books, :link_9, :string
      add_column :books, :link_10, :string
      add_column :books, :label_4, :string
      add_column :books, :label_5, :string
      add_column :books, :label_6, :string
      add_column :books, :label_7, :string
      add_column :books, :label_8, :string
      add_column :books, :label_9, :string
      add_column :books, :label_10, :string
    end
  end
end
