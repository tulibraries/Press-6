# frozen_string_literal: true

require "administrate/base_dashboard"

class OabookDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    slug: Field::String,
    title: Field::String,
    subtitle: Field::String,
    author: Field::String,
    edition: Field::String,
    isbn: Field::String,
    print_isbn: Field::String,
    description: TrixField,
    image: ImageField,
    cover_alt_text: Field::String,
    collection: Field::Select.with_options(
      collection: ["North Broad Press", "Labor Studies & Work"]
    ),
    supplemental: Field::String,
    pod: Field::Boolean,
    epub: FileField,
    mobi: FileField,
    pdf: FileField,
    manifold: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    image
    title
    author
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    image
    title
    subtitle
    author
    edition
    isbn
    print_isbn
    description
    collection
    supplemental
    epub
    pdf
    mobi
  ].freeze

  FORM_ATTRIBUTES = %i[
    image
    cover_alt_text
    title
    slug
    subtitle
    author
    edition
    isbn
    print_isbn
    description
    collection
    supplemental
    pod
    epub
    pdf
    mobi
    manifold
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(oabook)
    oabook.title
  end
end
