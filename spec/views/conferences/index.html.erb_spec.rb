# frozen_string_literal: true

require "rails_helper"

RSpec.describe "conferences/index", type: :view do
  let(:conference1) { FactoryBot.create(:conference, start_date: DateTime.now) }
  let(:conference2) { FactoryBot.create(:conference, start_date: DateTime.now.next_month) }
  # binding.pry
  let(:intro) { FactoryBot.create(:webpage, body: ActionText::Content.new("Hello World")) }
  let(:user) { FactoryBot.create(:user) }

  before(:each) do
    allow(view).to receive(:current_user).and_return(user)
    assign(:conferences, [conference1, conference2].group_by { |conference| conference.start_date.strftime("%B") })
    assign(:intro, intro)
  end

  it "creates link to conference site" do
    render
    expect(rendered).to include "href=\"#{conference1.link}"
  end

  it "groups conferences by month" do
    render
    expect(rendered).to include "#{conference1.start_date.strftime('%B')}</h2>"
    expect(rendered).to include "#{conference2.start_date.strftime('%B')}</h2>"
  end

  it "renders top of page intro" do
    render
    expect(rendered).to include "Hello World"
  end
end
