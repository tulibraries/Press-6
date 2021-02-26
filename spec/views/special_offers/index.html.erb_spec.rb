# frozen_string_literal: true

require "rails_helper"

RSpec.describe "special_offers/index", type: :view do
  before(:each) do
    assign(:special_offers, [
      SpecialOffer.create!(),
      SpecialOffer.create!()
    ])
  end

  it "renders a list of special_offers" do
    render
  end
end
