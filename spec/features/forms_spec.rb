# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/forms/:type", type: :feature do
  it "does not include intro text" do
    visit "/forms/copy-request"
    container = page.find(".form-intro")
    expect(container.text).to match("")
  end
  it "includes intro text" do
    @intro = FactoryBot.create(:webpage, title: "Copy Request Intro",
                                         body: ActionText::Content.new("This is the introductory text."))
    visit "/forms/copy-request"
    container = page.find(".form-intro")
    expect(container.text).to include("This is the introductory text.")
  end
  it "does not include footer text" do
    visit "/forms/copy-request"
    container = page.find(".form-intro")
    expect(container.text).to match("")
  end
  it "includes footer text" do
    @footer = FactoryBot.create(:webpage, title: "Copy Request Footer",
                                          body: ActionText::Content.new("This is the footer text."))
    visit "/forms/copy-request"
    container = page.find(".form-footer")
    expect(container.text).to include("This is the footer text.")
  end
end
