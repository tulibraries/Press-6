# frozen_string_literal: true

class CreatePeople < ActiveRecord::Migration[6.0]
  def change
    create_table :people do |t|
      t.string :name
      t.string :email
      t.string :position
      t.text :position_description
      t.string :department
      t.string :document_contact

      t.timestamps
    end
  end
end
