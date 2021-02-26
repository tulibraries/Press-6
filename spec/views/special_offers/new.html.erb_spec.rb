# frozen_string_literal: true

require "rails_helper"

RSpec.describe "special_offers/new", type: :view do
  before(:each) do
    assign(:special_offer, SpecialOffer.new())
  end

  it "renders new special_offer form" do
    render

    assert_select "form[action=?][method=?]", special_offers_path, "post" do
    end
  end
end
