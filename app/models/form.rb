# frozen_string_literal: true

class Form < MailForm::Base
  attribute :form_type
  attribute :name
  attribute :email
  attribute :media_type
  attribute :website
  attribute :request_statement
  attribute :address_line_1
  attribute :address_line_2
  attribute :state
  attribute :zip
  attribute :country

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
  attribute :comments

  def get_subject
    @forms = {
      "review-copy" => ["Request a Review Copy", ["cdoyle@temple.edu"]],
      "copy-request" => ["Exam & Desk Copy Request", ["cdoyle@temple.edu"]]
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
