# frozen_string_literal: true

class CreateAuthors < ActiveRecord::Migration[6.1]
  def change
    create_table :authors do |t|
      t.string :author_id
      t.string :title
      t.string :first_name
      t.string :last_name
      t.string :prefix
      t.string :suffix

      t.timestamps
    end
  end
end
