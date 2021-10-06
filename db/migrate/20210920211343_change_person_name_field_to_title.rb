# frozen_string_literal: true

class ChangePersonNameFieldToTitle < ActiveRecord::Migration[6.1]
  def change
    if column_exists?(:people, :name)
      rename_column :people, :name, :title
    end
  end
end
