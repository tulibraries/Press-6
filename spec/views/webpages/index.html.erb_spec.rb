# frozen_string_literal: true

require "rails_helper"

RSpec.describe "webpages/index", type: :view do
  before(:each) do
    assign(:webpages, [
      Webpage.create!(),
      Webpage.create!()
    ])
  end

  it "renders a list of webpages" do
    render
  end
end
