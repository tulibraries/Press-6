require 'rails_helper'

RSpec.describe "agencies/show", type: :view do
  before(:each) do
    @agency = assign(:agency, Agency.create!(
      title: "Title"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
  end
end
