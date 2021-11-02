# frozen_string_literal: true

require "administrate/base_dashboard"

class BrochureDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    title: Field::String,
    catalog_id: Field::Select.with_options(
      collection: Catalog.all
                          .sort_by { |catalog| [catalog.year, catalog.season] }
                          .reverse
                          .select { |catalog| [catalog.title, catalog.code] }
    ),
    subject_id: Field::Select.with_options(
      collection: Subject.all.map { |subject| [subject.title, subject.code] }.sort
    ),
    image: ImageField,
    pdf: FileField,
    promoted_to_homepage: Field::Boolean,
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
  promoted_to_homepage
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
  title
  promoted_to_homepage
  image
  pdf
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
  title
  image
  pdf
  catalog_id
  subject_id
  promoted_to_homepage
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

  # Overwrite this method to customize how brochures are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(brochure)
    brochure.title
  end
end
