class AddTocLabelToBooks < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :toc_label, :string
  end
end
