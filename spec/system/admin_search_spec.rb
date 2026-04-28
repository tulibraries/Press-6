# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin index search", type: :system, js: true do
  let(:user) { create(:user) }
  let!(:matching_faq) { create(:faq, title: "Alpha Result") }
  let!(:other_faq) { create(:faq, title: "Beta Result") }

  around do |example|
    test_user = user

    Admin::ApplicationController.class_eval do
      define_method(:authenticate_user!) { true }
      define_method(:current_user) { test_user }
    end

    example.run
  ensure
    Admin::ApplicationController.class_eval do
      remove_method :authenticate_user!
      remove_method :current_user
    end
  end

  it "searches from the admin index page" do
    visit admin_faqs_path

    fill_in "search", with: "Alpha"
    find_field("search").send_keys(:enter)

    expect(page).to have_current_path(/search=Alpha/)
    expect(page).to have_content("Alpha Result")
    expect(page).not_to have_content("Beta Result")
  end
end
