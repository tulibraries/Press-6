class AddLabelFieldForQAs < ActiveRecord::Migration[6.1]
  if column_exists?(:books, :toc_label)
    rename_column :books, :toc_label, :qa_label
  end
end
