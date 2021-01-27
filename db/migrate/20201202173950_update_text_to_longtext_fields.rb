# frozen_string_literal: true

class UpdateTextToLongtextFields < ActiveRecord::Migration[6.0]
  def change
    change_column :books, :subjects, :text, limit: 4294967295
  end
end
