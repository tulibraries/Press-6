# frozen_string_literal: true

require "rails_helper"

RSpec.describe "special_offers/show", type: :view do
  before(:each) do
    @special_offer = assign(:special_offer, SpecialOffer.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
