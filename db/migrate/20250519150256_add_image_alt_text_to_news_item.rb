# frozen_string_literal: true

class AddImageAltTextToNewsItem < ActiveRecord::Migration[7.2]
  def up
    add_column :news_items, :image_alt_text, :string
  end
  def down
    remove_column :news_items, :image_alt_text
  end
end
