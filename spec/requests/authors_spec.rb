 # frozen_string_literal: true

 require "rails_helper"

 RSpec.describe "/authors", type: :request do
   let(:author) { FactoryBot.create(:author) }
   let(:book) { FactoryBot.create(:book, author_ids: ["\"#{author.author_id}\""]) }

   describe "GET /index" do
     it "renders a successful response" do
       expect { get authors_path.to have_text(author.title) }
     end

     it "lists author name" do
      expect { get authors_path.to have_text(author.title) }
    end
   end

   describe "GET /show" do
     it "renders a successful response" do
       expect { get authors_path(author).to be_successful }
     end

     it "displays book title" do
       expect { get author_path(author).to have_text(book.title) }
     end
   end
 end
