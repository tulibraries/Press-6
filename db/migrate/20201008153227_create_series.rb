# frozen_string_literal: true

class CreateSeries < ActiveRecord::Migration[6.0]
  def change
    create_table :series do |t|
      t.string  :code
      t.string  :title
      t.string  :editors
      t.text    :description
      t.string  :founder
      t.string  :image_link

      t.timestamps
    end
  end
end
