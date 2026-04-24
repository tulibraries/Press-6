# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Administrate saves", type: :system, js: true do
  let(:user) { create(:user) }
  let!(:faq) { create(:faq, title: "Original FAQ") }

  before do
    login_as(user, scope: :user)
  end

  it "updates a faq from the admin edit form" do
    visit edit_admin_faq_path(faq)

    fill_in "faq_title", with: "Updated FAQ"
    click_button "Update Faq"

    expect(page).to have_current_path(admin_faq_path(faq), ignore_query: true)
    expect(page).to have_content("Updated FAQ")
    expect(faq.reload.title).to eq("Updated FAQ")
  end
end
