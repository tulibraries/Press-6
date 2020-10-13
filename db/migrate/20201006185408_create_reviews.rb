# frozen_string_literal: true

class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.string :title
      t.string :title_id
      t.text   :author
      t.text   :review
      t.string :review_id
      t.integer :weight

      t.timestamps
    end
  end
end
