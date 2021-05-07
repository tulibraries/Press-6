# frozen_string_literal: true

class AddFeaturedAwardWinnerToBooks < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :featured_award_winner, :boolean
  end
end
