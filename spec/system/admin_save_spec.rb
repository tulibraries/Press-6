# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Administrate saves", type: :system, js: true do
  let(:user) { create(:user) }
  let(:faq) { create(:faq, title: "Original FAQ", answer: ActionText::Content.new("Original answer")) }

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

  it "updates a faq from the admin edit form" do
    visit edit_admin_faq_path(faq)

    fill_in_rich_text_area "answer", with: "Updated answer"
    click_button "Update Faq"

    expect(page).to have_current_path(admin_faq_path(faq.reload), ignore_query: true)
    expect(page).to have_content("Updated answer")
    expect(faq.reload.answer.to_plain_text).to eq("Updated answer")
  end
end
