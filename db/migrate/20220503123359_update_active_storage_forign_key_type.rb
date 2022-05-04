# frozen_string_literal: true

class UpdateActiveStorageForeignKeyType < ActiveRecord::Migration[6.1]
  def change
    change_column :active_storage_variant_records, :blob_id, :bigint
  end
end
