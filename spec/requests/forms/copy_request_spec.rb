# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Request a Desk or Exam Copy", type: :request do

  let(:pb_adoption) { FactoryBot.create(:book, title: "paper back", sort_title: "paper back", course_adoption: true)  }
  let(:hc_adoption) { FactoryBot.create(:book, title: "hard cover", sort_title: "hard cover", course_adoption: true, bindings: "")  }

  describe "request formats" do
    it "only has paperback course adoption books" do
      @books = [pb_adoption, hc_adoption]
      get form_path(type: "copy-request")
      expect(response.body).to include(pb_adoption.sort_title)
      expect(response.body).not_to include(hc_adoption.sort_title)
    end
  end

  describe "requests from book pages" do
    it "prepopulates select list" do
      get form_path(type: "copy-request", id: pb_adoption.id)
      expect(response.body).to include(pb_adoption.title)
    end
  end

  let(:form_type) { "copy-request" }
  let(:form_params) {
    {
      name: "Joe", email: "test@temple.edu", address_line_1: "123 Hammock Sway", state: "FL", zip: "345321", address_type: "Residential",
      requested_book1: "Appollonian Way -- Lorenzo Garcia", format: "eBook"
    }
  }

  it_behaves_like "email form"

end
