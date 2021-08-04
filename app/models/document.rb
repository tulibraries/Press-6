# frozen_string_literal: true

class Document < ApplicationRecord
  validates :title, :document_type, presence: true
  has_one_attached :document, dependent: :destroy
  belongs_to :person, dependent: :destroy
end
