 # frozen_string_literal: true

 require "rails_helper"

 RSpec.describe "/agencies", type: :request do

   let(:valid_attributes) {
     skip("Add a hash of attributes valid for your model")
   }

   let(:invalid_attributes) {
     skip("Add a hash of attributes invalid for your model")
   }

   describe "GET /index" do
     xit "renders a successful response" do
       Agency.create! valid_attributes
       get agencies_url
       expect(response).to be_successful
     end
   end

   describe "GET /show" do
     xit "renders a successful response" do
       agency = Agency.create! valid_attributes
       get agency_url(agency)
       expect(response).to be_successful
     end
   end
 end
