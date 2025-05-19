# frozen_string_literal: true

class AddImageAltTextToEvent < ActiveRecord::Migration[7.2]
  def up
    add_column :events, :image_alt_text, :string
  end
  def down
    remove_column :events, :image_alt_text
  end
end
