# frozen_string_literal: true

class UpdateActiveStorageForeignKeyType < ActiveRecord::Migration[6.1]
  def up
    change_column :active_storage_variant_records, :blob_id, :bigint
  end
  def down
    change_column :active_storage_variant_records, :blob_id, :int
  end
end