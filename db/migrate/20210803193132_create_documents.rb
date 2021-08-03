class CreateDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :documents do |t|
      t.string :title
      t.string :contact_name
      t.string :contact_email
      t.string :document_type

      t.timestamps
    end
  end
end
