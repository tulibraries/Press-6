# frozen_string_literal: true

class CreateSubjects < ActiveRecord::Migration[6.0]
  def change
    create_table :subjects do |t|
      t.string :code
      t.string :title
      t.string :file_label

      t.timestamps
    end
  end
end
