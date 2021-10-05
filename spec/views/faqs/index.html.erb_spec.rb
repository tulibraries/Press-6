require 'rails_helper'

RSpec.describe "faqs/index", type: :view do
  before(:each) do
    assign(:faqs, [
      Faq.create!(),
      Faq.create!()
    ])
  end

  it "renders a list of faqs" do
    render
  end
end
