# frozen_string_literal: true

class AddHeadFieldToPerson < ActiveRecord::Migration[6.0]
  def change
    add_column :people, :head, :boolean
  end
end
