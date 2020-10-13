# frozen_string_literal: true

class RemoveSeriesFromBook < ActiveRecord::Migration[6.0]
  def change
    remove_column :books, :in_series, :string
  end
end
