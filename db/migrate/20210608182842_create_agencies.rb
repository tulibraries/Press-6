# frozen_string_literal: true

class CreateAgencies < ActiveRecord::Migration[6.0]
  def change
    create_table :agencies do |t|
      t.string :title
      t.string :region
      t.string :contact
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :city
      t.string :country
      t.string :phone
      t.string :fax
      t.string :email
      t.string :website

      t.timestamps
    end
  end
end
