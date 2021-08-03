 # frozen_string_literal: true

 require "rails_helper"

 RSpec.describe "/special_offers", type: :request do
   let(:offer) { FactoryBot.create(:special_offer, active: false) }
   let(:offer2) { FactoryBot.create(:special_offer, active: true) }
   let(:book) { FactoryBot.create(:book, title: "Offerings", special_offer: offer.id) }
   let(:book2) { FactoryBot.create(:book, title: "Burnt Offerings", special_offer: (offer2.id)) }

   describe "index page renders offers" do
     it "returns an offer" do
       expect { get special_offers_path.to have_text(offer2.title) }
     end
     it "does not return an inactive offer" do
       expect { get special_offers_path.not_to have_text(offer.title) }
     end
   end

   describe "show page renders books" do
     it "returns books by offer" do
       expect { get series_path(offer2).to have_text(book2.title) }
     end
   end
 end
