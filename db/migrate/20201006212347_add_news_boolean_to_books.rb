# frozen_string_literal: true

class AddNewsBooleanToBooks < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :news, :boolean
  end
end
