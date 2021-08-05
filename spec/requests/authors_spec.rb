 # frozen_string_literal: true

 require "rails_helper"

 RSpec.describe "/authors", type: :request do
  let(:author) { FactoryBot.create(:author) }
  let(:author2) { FactoryBot.create(:author, suppress: true) }
  let(:book) { FactoryBot.create(:book, author_ids: ["\"#{author.author_id}\""]) }
  let(:book2) { FactoryBot.create(:book, author_ids: ["\"#{author2.author_id}\""]) }

  describe "GET /index" do
    it "renders a successful response" do
      expect { get authors_path.to have_text(author.title) }
    end

    it "lists author name" do
      expect { get authors_path.to have_text(author.title) }
    end

    it "does not list suppressed authors" do
      expect { get authors_path.not_to have_text(book2.title) }
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
