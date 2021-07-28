# frozen_string_literal: true

class AddAuthorIdsToBooks < ActiveRecord::Migration[6.1]
  def change
    change_table :books, bulk: true do |t|
      remove_column :books, :author_prefixes, :text
      remove_column :books, :author_firsts, :text
      remove_column :books, :author_lasts, :text
      remove_column :books, :author_suffixes, :text
    end
  end
end
