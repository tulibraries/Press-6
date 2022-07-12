# frozen_string_literal: true

require "rails_helper"

RSpec.describe "books/awards", type: :view do
  let(:user) { FactoryBot.create(:user) }

  before(:each) do
    allow(view).to receive(:current_user).and_return(user)
  end

  it "renders subjects from awards instance variable" do
    @book = FactoryBot.create(:book)
    subject = FactoryBot.create(:subject)
    assign(:awards_by_subject, [subject])
    render
    # binding.pry
    expect(rendered).to have_text(/#{subject.title}/)
  end
end
