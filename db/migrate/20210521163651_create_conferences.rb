# frozen_string_literal: true

class CreateConferences < ActiveRecord::Migration[6.0]
  def change
    create_table :conferences do |t|
      t.string :title
      t.datetime :start_date
      t.datetime :end_date
      t.string :link
      t.string :venue
      t.string :location
      t.string :booth

      t.timestamps
    end
  end
end
