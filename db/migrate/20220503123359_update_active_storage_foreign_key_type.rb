# frozen_string_literal: true

class UpdateActiveStorageForeignKeyType < ActiveRecord::Migration[6.1]
  def up
    unless column_exists?(:active_storage_variant_records, :blob_id, type: :bigint)
      change_column :active_storage_variant_records, :blob_id, :bigint
    end
  end

  def down
    if column_exists?(:active_storage_variant_records, :blob_id, type: :bigint)
      change_column :active_storage_variant_records, :blob_id, :integer
    end
  end
end
