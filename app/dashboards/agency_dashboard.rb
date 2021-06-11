# frozen_string_literal: true

require "administrate/base_dashboard"

class AgencyDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    title: Field::String,
    contact: Field::String,
    address1: Field::String,
    address2: Field::String,
    address3: Field::String,
    city: Field::String,
    country: Field::String,
    phone: Field::String,
    fax: Field::String,
    email: Field::String,
    website: Field::String,
    region: Field::Select.with_options(collection: I18n.t("tupress.admin.collections.agencies.regions")),
    rights: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
  title
  region
  contact
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    title
    contact
    address1
    address2
    address3
    city
    country
    phone
    fax
    email
    website
    region
    rights
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    title
    contact
    address1
    address2
    address3
    city
    country
    phone
    fax
    email
    website
    region
    rights
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

  # Overwrite this method to customize how agencies are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(agency)
  #   "Agency ##{agency.id}"
  # end
end
