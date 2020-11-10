# frozen_string_literal: true

require "rails_helper"

RSpec.describe "webpages/new", type: :view do
  before(:each) do
    assign(:webpage, Webpage.new())
  end

  it "renders new webpage form" do
    render

    assert_select "form[action=?][method=?]", webpages_path, "post" do
    end
  end
end
