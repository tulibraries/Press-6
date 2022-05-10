# frozen_string_literal: true

class FixFeaturedAwardWeightMigration < ActiveRecord::Migration[6.1]
  def change
    unless column_exists?(:books, :featured_award_weight)
      add_column :books, :featured_award_weight, :int
    end
  end
end
