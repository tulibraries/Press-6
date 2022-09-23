# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Rights and Permissions", type: :request do
  let(:form_type) { "rights-and-permissions" }
  let(:form_params) do
    {
      name: "Joe", email: "test@temple.edu", address_line_1: "123 Hammock Sway", state: "FL", zip: "345321",
      book_title: "Title", book_author_editor: "Angela", chapter_title: "Chapter One", page_numbers: "3, 4", 
      your_publisher: "Knopf Press", reprint_title: "Second Edition", number_of_pages: "344", publication_date: "09/22/2022", 
      rights_requested: "All inclusive" 
    }
  end

  it_behaves_like "email form"
end
