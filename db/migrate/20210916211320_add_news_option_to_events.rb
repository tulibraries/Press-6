# frozen_string_literal: true

class AddNewsOptionToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :add_to_news, :boolean
  end
end
