# frozen_string_literal: true

require "administrate/base_dashboard"

class NewsItemDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    image: ImageField,
    image_alt_text: Field::String,
    description: TrixField,
    id: Field::Number,
    title: Field::String,
    link: Field::String,
    promote_to_homepage: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    title
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    title
    image
    description
    link
    promote_to_homepage
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    title
    image
    image_alt_text
    description
    link
    promote_to_homepage
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how news items are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(news_item)
  #   "NewsItem ##{news_item.id}"
  # end
end
