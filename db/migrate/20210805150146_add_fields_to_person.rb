# frozen_string_literal: true

class AddFieldsToPerson < ActiveRecord::Migration[6.1]
  def change
    change_table :people, bulk: true do |t|
      t.string :phone
      t.string :fax
      t.string :coverage
      t.string :company
      t.string :region
      t.string :website
      t.boolean :is_rep, default: false
    end
  end
end
