# frozen_string_literal: true

require "rails_helper"

RSpec.describe "conferences/index.html.erb", type: :view do
  let(:conference1) { FactoryBot.create(:conference, start_date: DateTime.now) }
  let(:conference2) { FactoryBot.create(:conference, start_date: DateTime.now.next_month) }
  let(:intro) { FactoryBot.create(:webpage) }

  before(:each) do
    assign(:conferences, [conference1, conference2].group_by { |conference| conference.start_date.strftime("%B") })
    assign(:intro, intro)
  end

  it "creates link to conference site" do
    render
    expect(rendered).to match /href=\"#{conference1.link}/
  end

  it "groups conferences by month" do
    render
    expect(rendered).to match /<h2>#{conference1.start_date.strftime("%B")}/
    expect(rendered).to match /<h2>#{conference2.start_date.strftime("%B")}/
  end

  it "renders top of page intro" do
    render
    expect(rendered).to match /Hello World/
  end

end
