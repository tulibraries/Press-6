# frozen_string_literal: true

require "administrate/base_dashboard"

class PersonDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    email: Field::String,
    position: Field::String,
    position_description: TrixField,
    department: Field::String,
    document_contact: Field::String,
    image: ImageField,
    head: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
  name
  position
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
  image
  name
  position
  department
  ].freeze

  FORM_ATTRIBUTES = %i[
    image
    name
    email
    position
    position_description
    department
    head
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how people are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(person)
    person.name
  end
end
