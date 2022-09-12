# frozen_string_literal: true

class AddPublishedFieldToSeries < ActiveRecord::Migration[7.0]
  def change
    add_column :series, :unpublish, :boolean, default: false
  end
end
