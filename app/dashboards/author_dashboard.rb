# frozen_string_literal: true

require "administrate/base_dashboard"

class AuthorDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    slug: Field::String,
    author_id: Field::String,
    title: Field::String,
    first_name: Field::String,
    last_name: Field::String,
    prefix: Field::String,
    suffix: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    suppress: Field::Boolean,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    title
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    title
    suppress
  ].freeze

  FORM_ATTRIBUTES = %i[
    title
    slug
    suppress
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(author)
    author.title
  end
end
