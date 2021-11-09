class AddDatesTextFieldToConferences < ActiveRecord::Migration[6.1]
  def change
    add_column :conferences, :dates, :string
  end
end
