# frozen_string_literal: true

class AddRelatedLinksToBooks < ActiveRecord::Migration[6.0]
  def change
    change_table :books, bulk: true do |t|
      t.string :link_1
      t.string :label_1
      t.string :link_2
      t.string :label_2
      t.string :link_3
      t.string :label_3
    end
  end
end
