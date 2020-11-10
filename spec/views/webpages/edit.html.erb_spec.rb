# frozen_string_literal: true

require "rails_helper"

RSpec.describe "webpages/edit", type: :view do
  before(:each) do
    @webpage = assign(:webpage, Webpage.create!())
  end

  it "renders the edit webpage form" do
    render

    assert_select "form[action=?][method=?]", webpage_path(@webpage), "post" do
    end
  end
end
