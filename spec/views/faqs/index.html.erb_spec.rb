# frozen_string_literal: true

require "rails_helper"

RSpec.describe "faqs/index", type: :view do
  let(:faq1) { FactoryBot.create(:faq) }
  let(:faq2) { FactoryBot.create(:faq) }

  before(:each) do
    assign(:faqs, [
             faq1,
             faq2
           ])
  end

  it "renders a list of faqs" do
    render
  end
end
