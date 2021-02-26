# frozen_string_literal: true

require "rails_helper"

RSpec.describe "special_offers/edit", type: :view do
  before(:each) do
    @special_offer = assign(:special_offer, SpecialOffer.create!())
  end

  it "renders the edit special_offer form" do
    render

    assert_select "form[action=?][method=?]", special_offer_path(@special_offer), "post" do
    end
  end
end
