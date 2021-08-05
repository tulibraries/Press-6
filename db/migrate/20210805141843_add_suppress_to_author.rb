# frozen_string_literal: true

class AddSuppressToAuthor < ActiveRecord::Migration[6.1]
  def change
    add_column :authors, :suppress, :boolean, default: false
  end
end
