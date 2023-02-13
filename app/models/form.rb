# frozen_string_literal: true

class Form < MailForm::Base
  attribute :form_type

  # common fields
  attribute :add_to_mailing_list
  attribute :address_line_1
  attribute :address_line_2
  attribute :book_title
  attribute :city
  attribute :comments
  attribute :country
  attribute :email
  attribute :name
  attribute :request_type
  attribute :state
  attribute :zip

  # review-copy
  attribute :media_type
  attribute :website
  attribute :request_statement

  # copy-request
  attribute :university
  attribute :department
  attribute :address_type
  attribute :instructor
  attribute :course_title
  attribute :projected_enrollment
  attribute :semester_taught
  attribute :requested_book1
  attribute :requested_book2
  attribute :requested_book3
  attribute :format
  attribute :authorized_bookstore

  # rights-and-permissions
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

  # inquiries
  attribute :e_catalog
  attribute :print_catalog
  attribute :remove_from_mailing_list
  attribute :removal_description
  attribute :new_and_special_news
  attribute :subjects

  def get_subject
    @forms = {
      "review-copy" => ["Request a Review Copy", ["tempress@temple.edu"]],
      "copy-request" => ["Request a Desk or Exam Copy", ["tempress@temple.edu"]],
      "rights-and-permissions" => ["Rights and Permissions", ["tempress@temple.edu"]],
      "inquiries" => ["Inquiries", ["tempress@temple.edu"]]
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
      from: %("#{name || default_from_name}" <#{email || default_from_email}>)
    }
  end
end
