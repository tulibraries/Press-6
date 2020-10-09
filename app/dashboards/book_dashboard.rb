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
    book_id: Field::String,
    title: Field::String,
    subtitle: Field::String,
    author: Field::Text,
    about_author: Field::Text,
    intro: Field::Text,
    blurb: Field::Text,
    excerpt_image: FileField,
    excerpt_text: Field::Text,
    in_series: Field::Select.with_options(
      class_name: "Series"
    ),
    binding: Field::Text,
    description: Field::Text,
    reviews: Field::Text,
    contents: Field::Text,
    author_id: Field::Text,
    author_prefix: Field::Text,
    author_first: Field::Text,
    author_last: Field::Text,
    author_suffix: Field::Text,
    author_byline: Field::Text,
    author_bios: Field::Text,
    guide_image: FileField,
    guide_text: Field::Text,
    cover_image: FileField,
    format: Field::String,
    isbn: Field::String,
    ean: Field::String,
    pub_date: Field::String,
    pages_total: Field::String,
    trim: Field::String,
    illustrations: Field::String,
    award: Field::String,
    status: Field::Select.with_options(
      collection: ["In Print","NP","OS","X","..."]
    ),
    news: Field::Boolean,
    newsweight: Field::Select.with_options(
      collection: [1,2,3,4]
    ),
    hot: Field::Boolean,
    hotweight: Field::Select.with_options(
      collection: [1,2,3,4,5]
    ),
    highlight: Field::Boolean,
    catalog: Field::String,
    award_year: Field::String,
    sort_title: Field::String,
    supplement: Field::String,
    edition: Field::String,
    suggested_reading_image: FileField,
    course_adoptions: Field::Boolean,

    subjects: Field::Text,
    subject1: SubjectsSelectField,
    subject2: SubjectsSelectField,
    subject3: SubjectsSelectField,
    award_year2: Field::String,
    award2: Field::String,
    award_year3: Field::String,
    award3: Field::String,
    award_year4: Field::String,
    award4: Field::String,
    price: Field::String.with_options(searchable: false),
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
  author_byline
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
  id
  book_id
  title
  subtitle
  author_byline
  about_author
  intro
  blurb
  excerpt_text
  in_series
  binding
  description
  reviews
  subjects
  contents
  author_id
  author_prefix
  author_first
  author_last
  author_suffix
  author_bios
  guide_text
  cover_image
  format
  isbn
  ean
  pub_date
  pages_total
  trim
  illustrations
  award
  status
  newsweight
  hot
  hotweight
  course_adoptions
  highlight
  catalog
  award_year
  sort_title
  supplement
  edition
  course_adoptions
  subject1
  subject2
  subject3
  award_year2
  award2
  award_year3
  award3
  award_year4
  award4
  price
  created_at
  updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
  cover_image
  highlight
  hot
  hotweight
  news
  newsweight
  course_adoptions
  suggested_reading_image
  guide_image
  guide_text
  excerpt_image
  excerpt_text
  edition
  catalog
  supplement
  status
  subject1
  subject2
  subject3
  award_year
  award
  award_year2
  award2
  award_year3
  award3
  award_year4
  award4
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
  # def display_resource(book)
  #   "Book ##{book.id}"
  # end
end
