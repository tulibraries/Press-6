 # frozen_string_literal: true

 require "rails_helper"

 RSpec.describe "/conferences", type: :request do
    Conference.destroy_all
   let(:future_conference) { FactoryBot.create(:conference, title: "future-conference") }
   let(:old_conference) { FactoryBot.create(:conference, title: "old-conference",
                                             start_date: DateTime.now.months_ago(3),
                                             end_date: DateTime.now.months_ago(2)) }
   let(:recent_conference) { FactoryBot.create(:conference, title: "recent-conference",
                                                 start_date: DateTime.now.months_ago(1),
                                                 end_date: DateTime.now) }


   describe "GET conferences list" do
     it "renders a successful response" do
       expect { (get conferences_path).to be_successful }
     end
     it "returns a future conference" do
      expect { get conferences_path.to have_text(future_conference.title) }
     end
     it "returns last month's conferences" do
      expect { get conferences_path.to have_text(recent_conference.title) }
     end
     it "does not return older than 1 month conference" do
      expect { get conferences_path.to have_text(old_conference.title) }
     end
   end
 end
