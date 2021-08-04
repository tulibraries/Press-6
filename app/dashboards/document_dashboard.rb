# frozen_string_literal: true

require "administrate/base_dashboard"

class DocumentDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    title: Field::String,
    document: FileField,
    document_type: Field::Select.with_options(
      collection: I18n.t("tupress.downloads.document_types")
    ),
    person: Field::BelongsTo,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    document_type
    title
    person
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    title
    document_type
    document
    person
  ].freeze

  FORM_ATTRIBUTES = %i[
    title
    document
    document_type
    person
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(document)
    document.title
  end
end
