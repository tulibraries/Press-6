# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples "show_editable" do

  def model_name
    controller.to_s.underscore.chomp("_controller").singularize
  end

  let(:controller) { described_class }
  let(:model) { FactoryBot.create(model_name.to_sym) }

  describe "GET /#{model_name}/:id" do
    it "has an edit link" do
      get :show, params: { id: model.id }
      expect(response.body).to match /\/admin\/#{model_name.pluralize}\/#{model.id}\/edit\"/
    end
  end
end
