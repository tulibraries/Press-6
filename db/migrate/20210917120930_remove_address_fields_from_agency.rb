# frozen_string_literal: true

class RemoveAddressFieldsFromAgency < ActiveRecord::Migration[6.1]
  def change
    change_table :agencies, bulk: true do |t|
      remove_column :agencies, :address1, :string
      remove_column :agencies, :address2, :string
      remove_column :agencies, :address3, :string
      remove_column :agencies, :city, :string
      remove_column :agencies, :country, :string
    end
  end
end
