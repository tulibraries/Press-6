 # frozen_string_literal: true

 require "rails_helper"

 RSpec.describe "/agencies", type: :request do
   let(:agency) { FactoryBot.create(:agency) }
   let(:user) { FactoryBot.create(:user) }

   before(:each) do
     sign_in user
   end
 
   after(:each) do
     sign_out user
   end

   describe "GET /index" do
    it "renders a successful response" do
      get agencies_url
      expect(response).to be_successful
    end

    it "displays a title link when logged in" do
      get agencies_url
      expect(response).to be_successful
    end
   end
 end
