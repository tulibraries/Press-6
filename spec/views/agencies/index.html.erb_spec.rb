# frozen_string_literal: true

require "rails_helper"

RSpec.describe "agencies/index", type: :view do
  let(:agency1) { FactoryBot.create(:agency, contact: "John", region: "Japan") }
  let(:agency2) { FactoryBot.create(:agency, contact: "Mark", region: "Turkey") }
  let(:agency3) { FactoryBot.create(:agency, contact: "Luke", region: "Midwest") }
  let(:agency4) { FactoryBot.create(:agency, contact: "Ringo", region: "All Other Territories") }
  let(:user) { FactoryBot.create(:user) }

  context "displays agency info" do
    before(:each) do
      assign(:default_agency, agency3)
      assign(:agencies, [{ agency1.region => [agency1] }, { agency2.region => [agency2] }])
      allow(view).to receive(:current_user).and_return(user)
      render "agencies", agencies: [agency1, agency2]
    end

    it "renders a list of agencies by region" do
      expect(rendered).to match(/#{agency1.contact}/)
      expect(rendered).to match(/#{agency2.contact}/)
      expect(rendered).not_to match(/#{agency3.contact}/)
    end
  end

  context "displays region info" do
    before(:each) do
      allow(view).to receive(:current_user).and_return(user)
      render "region", region: agency1.region
    end

    it "only displays assigned regions" do
      expect(rendered).to match(/#{agency1.region}/)
      expect(rendered).not_to match(/#{agency3.region}/)
    end

    it "gets rights info from helper method" do
      expect(rendered).to match(/Non-exclusive Rights/)
      expect(rendered).not_to match(/Exclusive Rights/)
    end
  end

  context "displays default agency info if assigned" do
    before(:each) do
      assign(:default_agency, agency4)
      allow(view).to receive(:current_user).and_return(user)
      render "default_agency"
    end

    it "renders only default agency" do
      expect(rendered).not_to match(/#{agency1.contact}/)
      expect(rendered).not_to match(/#{agency2.contact}/)
      expect(rendered).not_to match(/#{agency3.contact}/)
      expect(rendered).to match(/#{agency4.contact}/)
    end
  end
end
