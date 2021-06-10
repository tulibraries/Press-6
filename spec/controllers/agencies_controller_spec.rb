# frozen_string_literal: true

require "rails_helper"

RSpec.describe AgenciesController, type: :controller do

  let(:agency) { FactoryBot.create(:agency) }

  describe "GET #index" do
    it "returns html when requested" do
      get :index, format: :html
      expect(response.header["Content-Type"]).to include "html"
    end
    # it "assigns instance variables" do
    #   expect(assigns(:agencies)).to be
    # end
  end
end
