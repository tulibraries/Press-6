# frozen_string_literal: true

class AddDocumentPersonAssociation < ActiveRecord::Migration[6.1]
  def change
    add_reference :documents, :person, foreign_key: true
  end
end
