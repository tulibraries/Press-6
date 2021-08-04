# frozen_string_literal: true

require "rails_helper"

RSpec.describe DocumentsController, type: :controller do
  let(:doc) { FactoryBot.create(:document) }

  describe "GET #index" do
    it "returns html when requested" do
      get :index, format: :html
      expect(response.header["Content-Type"]).to include "html"
    end
  end

  it_behaves_like "index_editable"

end
