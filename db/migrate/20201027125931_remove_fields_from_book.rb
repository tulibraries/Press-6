class RemoveFieldsFromBook < ActiveRecord::Migration[6.0]
  def change
    remove_column :books, :author_id
    remove_column :books, :author_prefix
    remove_column :books, :author_first
    remove_column :books, :author_last
    remove_column :books, :author_suffix
    remove_column :books, :author
    remove_column :books, :catalog    
    remove_column :books, :course_adoptions

    
  end
end
