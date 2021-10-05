# frozen_string_literal: true

require "administrate/base_dashboard"

class BookDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    xml_id: Field::String,
    slug: Field::String,
    title: Field::String,
    subtitle: Field::String,
    sort_title: Field::String,
    isbn: Field::String,
    intro: Field::Text,
    blurb: Field::Text,
    excerpt_text: Field::String,
    excerpt_file: FileField,
    toc_file: FileField,
    toc_label: Field::String,
    binding: Field::Text,
    description: Field::Text,
    contents: Field::Text,
    author_byline: Field::String,
    about_author: Field::Text,
    active_guide: Field::Boolean,
    guide_file: FileField,
    guide_file_label: Field::String,
    guide_text: TrixField,
    cover_image: ImageField,
    cover: Field::String,
    format: Field::String,
    ean: Field::String,
    pub_date: Field::String,
    pages_total: Field::String,
    trim: Field::String,
    illustrations: Field::String,
    status: Field::Select.with_options(
      collection: ["In Print", "NP", "OS", "X", "..."]
    ),
    books: Field::HasMany.with_options(
      class_name: "Book",
      order: "sort_title"),
    add_to_news: Field::Boolean,
    news_text: TrixField,
    newsweight: Field::Select.with_options(
      collection: [1, 2, 3]
    ),
    hot: Field::Boolean,
    # hotweight: Field::Select.with_options(
    #   collection: [1, 2, 3, 4, 5]
    # ),
    supplement: Field::String,
    edition: Field::String,
    suggested_reading_image: ImageField,
    suggested_reading_label: Field::String,
    course_adoption: Field::Boolean,
    desk_copy: Field::Boolean,

    special_offer: Field::BelongsTo.with_options(order: "title"),

    subjects: Field::Text,
    subject1: SubjectsSelectField,
    subject2: SubjectsSelectField,
    subject3: SubjectsSelectField,
    link_1: Field::String,
    link_2: Field::String,
    link_3: Field::String,
    link_4: Field::String,
    link_5: Field::String,
    link_6: Field::String,
    link_7: Field::String,
    link_8: Field::String,
    link_9: Field::String,
    link_10: Field::String,
    label_1: Field::String,
    label_2: Field::String,
    label_3: Field::String,
    label_4: Field::String,
    label_5: Field::String,
    label_6: Field::String,
    label_7: Field::String,
    label_8: Field::String,
    label_9: Field::String,
    label_10: Field::String,
    award: TrixField,
    award2: TrixField,
    award3: TrixField,
    award_year: Field::String,
    award_year2: Field::String,
    award_year3: Field::String,
    featured_award_winner: Field::Boolean,
    price: Field::String.with_options(searchable: false),
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    title
    author_byline
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    cover_image
    sort_title
    author_byline
    isbn
    ean
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    cover_image
    sort_title
    slug
    edition
    status
    excerpt_file
    excerpt_text
    toc_file
    toc_label
    supplement
    desk_copy
    subject1
    subject2
    subject3
    featured_award_winner
    award_year
    award
    award_year2
    award2
    award_year3
    award3
    active_guide
    guide_file
    guide_file_label
    guide_text
    hot
    add_to_news
    newsweight
    news_text
    suggested_reading_image
    suggested_reading_label
    course_adoption
    special_offer
    books
    label_1
    link_1
    label_2
    link_2
    label_3
    link_3
    label_4
    link_4
    label_5
    link_5
    label_6
    link_6
    label_7
    link_7
    label_8
    link_8
    label_9
    link_9
    label_10
    link_10
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

  # Overwrite this method to customize how books are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(book)
    book.title
  end
end
