# frozen_string_literal: true

class CreateJournals < ActiveRecord::Migration[6.0]
  def change
    create_table :journals do |t|
      t.string :title
      t.string :url

      t.timestamps
    end
  end
end
