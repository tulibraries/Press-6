require 'rails_helper'

RSpec.describe "faqs/show", type: :view do
  before(:each) do
    @faq = assign(:faq, Faq.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
