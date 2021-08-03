 # frozen_string_literal: true

 require "rails_helper"

 RSpec.describe "/agencies", type: :request do
   let(:agency) { FactoryBot.create(:agency) }

   describe "GET /index" do
     it "renders a successful response" do
       get agencies_url
       expect(response).to be_successful
     end
   end
 end
