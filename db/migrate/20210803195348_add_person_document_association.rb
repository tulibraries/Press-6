class AddPersonDocumentAssociation < ActiveRecord::Migration[6.1]
  def change
    add_reference :people, :document, foreign_key: true
  end
end
