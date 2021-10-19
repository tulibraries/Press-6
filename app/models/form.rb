# frozen_string_literal: true

class Form < MailForm::Base
  attribute :form_type

  # common fields
  attribute :name
  attribute :email
  attribute :address_line_1
  attribute :address_line_2
  attribute :city
  attribute :state
  attribute :zip
  attribute :country
  attribute :comments

  # review-copy
  attribute :media_type
  attribute :website
  attribute :request_statement

  #copy-request
  attribute :request_type
  attribute :university
  attribute :department
  attribute :request_type
  attribute :address_type
  attribute :instructor
  attribute :course_title
  attribute :projected_enrollment
  attribute :semester_taught
  attribute :book_1_title
  attribute :book_1_author
  attribute :book_2_title
  attribute :book_2_author
  attribute :book_3_title
  attribute :book_3_author
  attribute :format
  attribute :authorized_bookstore

  # rights-permissions
  attribute :book_title
  attribute :book_author_editor
  attribute :chapter_title
  attribute :chapter_author_editor
  attribute :page_numbers
  attribute :reprint_price
  attribute :your_publisher
  attribute :reprint_title
  attribute :publication_editor_author
  attribute :number_of_pages
  attribute :number_of_copies
  attribute :publication_date
  attribute :rights_requested

  # contact-us
  attribute :e_catalog
  attribute :print_catalog
  attribute :add_to_mailing_list
  attribute :remove_from_mailing_list
  attribute :removal_description
  attribute :new_and_special_news
  attribute :subjects

  def get_subject
    @forms = {
      "review-copy" => ["Request a Review Copy", ["cdoyle@temple.edu"]],
      "copy-request" => ["Exam & Desk Copy Request", ["cdoyle@temple.edu"]],
      "right-permissions" => ["Rights & Permissions", ["cdoyle@temple.edu"]],
      "contact-us" => ["Contact Us", ["cdoyle@temple.edu"]]
    }
    @forms.fetch(form_type)
  end

  # Some forms don't supply an email and name, so they're failing
  def default_from_name
    "Temple University Press"
  end

  def default_from_email
    "tempress@temple.edu"
  end

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      subject: get_subject[0],
      to: get_subject[1],
      cc: email,
      from: %("#{name || default_from_name }" <#{email || default_from_email }>)
    }
  end
end
