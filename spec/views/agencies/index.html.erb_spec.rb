require 'rails_helper'

RSpec.describe "agencies/index", type: :view do
  before(:each) do
    assign(:agencies, [
      Agency.create!(
        title: "Title"
      ),
      Agency.create!(
        title: "Title"
      )
    ])
  end

  it "renders a list of agencies" do
    render
    assert_select "tr>td", text: "Title".to_s, count: 2
  end
end
