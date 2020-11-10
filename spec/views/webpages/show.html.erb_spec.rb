# frozen_string_literal: true

require "rails_helper"

RSpec.describe "webpages/show", type: :view do
  before(:each) do
    @webpage = assign(:webpage, Webpage.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
