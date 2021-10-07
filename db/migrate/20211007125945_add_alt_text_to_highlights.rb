# frozen_string_literal: true

class AddAltTextToHighlights < ActiveRecord::Migration[6.1]
  def change
    add_column :highlights, :alt_text, :string
  end
end
