# frozen_string_literal: true

require "administrate/base_dashboard"

class ConferenceDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    title: Field::String,
    slug: Field::String,
    dates: Field::String,
    start_date: Field::DatePicker,
    end_date: Field::DatePicker,
    link: Field::String,
    venue: Field::String,
    location: Field::String,
    booth: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    title
    location
    start_date
    end_date
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    title
    start_date
    end_date
    location
    venue
    booth
    link
  ].freeze

  FORM_ATTRIBUTES = %i[
    title
    slug
    dates
    start_date
    end_date
    location
    venue
    booth
    link
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

  # Overwrite this method to customize how conferences are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(conference)
    conference.title
  end
end
