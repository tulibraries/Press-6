# frozen_string_literal: true

class RemoveAddressFieldsFromAgency < ActiveRecord::Migration[6.1]
  def change
      remove_column :agencies, :address1, :string
      remove_column :agencies, :address2, :string
      remove_column :agencies, :address3, :string
    end
  end
end
