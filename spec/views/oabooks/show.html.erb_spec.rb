# frozen_string_literal: true

require "rails_helper"

RSpec.describe "oabooks/show.html.erb", type: :view do
  let(:user) { FactoryBot.create(:user) }

  before(:each) do
    allow(view).to receive(:current_user).and_return(user)
  end
  
  it "uses helper to create manifold link" do
    @oabook = FactoryBot.create(:oabook)
    render
    expect(rendered).to match /#{t("tupress.oabooks.manifold_link")}/
  end

end
