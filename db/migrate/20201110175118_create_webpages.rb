# frozen_string_literal: true

class CreateWebpages < ActiveRecord::Migration[6.0]
  def change
    create_table :webpages do |t|
      t.string :title
      t.timestamps
    end
  end
end
