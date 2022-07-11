# frozen_string_literal: true

class AddBookCoverAltTextToBook < ActiveRecord::Migration[7.0]
  def up
    add_column :books, :cover_alt_text, :string
  end
  def down
    remove_column :books, :cover_alt_text
  end
end
