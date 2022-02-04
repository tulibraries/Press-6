 # frozen_string_literal: true

 require "rails_helper"

 RSpec.describe "/conferences", type: :request do  
  let(:future_conference) { FactoryBot.create(:conference, title: "future-conference") }
  let(:old_conference) { FactoryBot.create(:conference, title: "old-conference", 
                                            start_date: DateTime.now.months_ago(3), 
                                            end_date: DateTime.now.months_ago(1)) }
  let(:recent_conference) { FactoryBot.create(:conference, title: "recent-conference", 
                                                start_date: DateTime.now.months_ago(1), 
                                                end_date: DateTime.now) }

   describe "GET conferences list" do
     it "renders a successful response" do
       expect { (get conferences_path).to be_successful }
     end
     it "returns a future conference" do
       get conferences_path
       expect(response.body).to include(future_conference.title)
     end
     it "returns last month's conferences" do
      get conferences_path
      expect(response.body).to include(recent_conference.title)
     end
     it "does not return older than 1 month conference" do
      get conferences_path
      expect(response.body).not_to include(old_conference.title)
     end
   end
 end
