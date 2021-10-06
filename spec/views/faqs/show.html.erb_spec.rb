# frozen_string_literal: true

require "rails_helper"

RSpec.describe "faqs/show", type: :view do
  before(:each) do
    @faq = assign(:faq, FactoryBot.create(:faq))
  end

  it "renders attributes in <p>" do
    render
  end
end
