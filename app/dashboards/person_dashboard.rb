# frozen_string_literal: true

require "administrate/base_dashboard"

class PersonDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    slug: Field::String,
    title: Field::String,
    email: Field::String,
    position: Field::String,
    position_description: TrixField,
    department: Field::Select.with_options(
      collection: I18n.t("tupress.admin.people.departments")
    ),
    document_contact: Field::String,
    image: ImageField,
    head: Field::Boolean,
    address: TrixField,
    phone: Field::String,
    fax: Field::String,
    coverage: Field::String,
    company: Field::String,
    region: Field::Select.with_options(
      collection: I18n.t("tupress.admin.people.regions")
    ),
    website: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    title
    position
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    image
    title
    position
    department
  ].freeze

  FORM_ATTRIBUTES = {
    "staff_info" => [:image, :title, :slug, :email, :position, :position_description, :department, :head],
    "sales_rep" => [:company, :region, :address, :phone, :fax, :coverage, :website]
  }

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
    person.title
  end
end
