# frozen_string_literal: true

require "rails_helper"

RSpec.describe "series/index", type: :view do
  let(:series) { FactoryBot.create(:series) }
  let(:webpage_with_text) { FactoryBot.create(:webpage, :with_text) }
  let(:webpage_no_text) { FactoryBot.create(:agency) }

  context "displays agency info" do
    before(:each) do
      assign(:intro, webpage_with_text)
      render "series"
    end

    it "renders page with intro" do
      expect(rendered).to match(/Hello World/)
    end
  end

  # context "displays region info" do
  #   before(:each) do
  #     allow(view).to receive(:current_user).and_return(user)
  #     render "region", region: agency1.region
  #   end

  #   it "only displays assigned regions" do
  #     expect(rendered).to match(/#{agency1.region}/)
  #     expect(rendered).not_to match(/#{agency3.region}/)
  #   end

  #   it "gets rights info from helper method" do
  #     expect(rendered).to match(/Non-exclusive Rights/)
  #     expect(rendered).not_to match(/Exclusive Rights/)
  #   end
  # end

end
