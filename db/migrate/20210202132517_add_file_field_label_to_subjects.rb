class AddFileFieldLabelToSubjects < ActiveRecord::Migration[6.0]
  def change
    add_column :subjects, :file_label, :string
  end
end
