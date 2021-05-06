# frozen_string_literal: true

require "rails_helper"

# Expected to be included in a Request spec for a admin dashboard.
# The described_class is expected to be the model the dashboard is supporting.

def model_name
  described_class.to_s.underscore
end

RSpec.shared_examples "renderable_dashboard" do
  let(:factory_model) { FactoryBot.create(model_name.to_sym) }
  # let(:account) { FactoryBot.create(:account) }
  let(:index_path) { send("admin_#{model_name.pluralize}_path") }

  # Why is series index route "index_series" instead of "series" like the other models?
  let(:index_path) { send("admin_#{model_name.pluralize}_index_path") } if model_name == "series"
  # why series

  let(:show_path) { send("admin_#{model_name}_path", factory_model) }
  let(:new_path) { send("new_admin_#{model_name}_path") }
  let(:edit_path) { send("edit_admin_#{model_name}_path", factory_model) }

  before(:each) do
    # sign_in account
  end

  after(:each) do
    # sign_out account
  end

  describe "GET /admin/#{model_name}" do
    it "access #{model_name} adminstrate" do
      get index_path
      expect(response).to have_http_status(200)
      #expect(response.body).to match(factory_model.label)
    end
  end

  describe "GET /admin/#{model_name}/show" do
    it "renders #{model_name} admin show" do
      get show_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /admin/#{model_name}/edit" do
    it "renders #{model_name} edit page" do
      get edit_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /admin/#{model_name}/new" do
    it "renders #{model_name} new page"  do
      get new_path
      expect(response).to have_http_status(200)
    end
  end
end
