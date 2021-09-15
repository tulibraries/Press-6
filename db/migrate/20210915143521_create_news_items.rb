# frozen_string_literal: true

class CreateNewsItems < ActiveRecord::Migration[6.1]
  def change
    create_table :news_items do |t|
      t.string :title
      t.string :link
      t.boolean :promote_to_homepage

      t.timestamps
    end
  end
end
