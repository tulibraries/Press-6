# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples "index_editable" do

  def model_name
    controller.to_s.underscore.chomp("_controller").singularize
  end

  let(:controller) { described_class }
  let(:model) { FactoryBot.create(model_name.to_sym) }
  let(:user) { FactoryBot.create(:user) }

  before(:each) do
    sign_in user
  end

  after(:each) do
    sign_out user
  end

  describe "GET /#{model_name.pluralize}" do
    it "has an edit link" do
      get :index unless model_name == "oabook"
      get :north_broad_press if model_name == "oabook"
      expect(response.body).to match /\/admin\/#{model_name.pluralize}\"/
      expect(response.body).to match /[EDIT]/ if model_name == "oabook" || model_name == "conference"
    end

  end
end
