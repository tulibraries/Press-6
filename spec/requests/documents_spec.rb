 require 'rails_helper'

RSpec.describe "/documents", type: :request do
  let(:document) { FactoryBot.create(:document) }

  describe "GET /index" do
    it "renders a successful response" do
      expect { ( get documents_path ).to be_successful }
    end
    it "returns a document" do
      expect { get documents_path.to have_text(document.document_type) }
    end
    it "returns a document" do
      expect { get documents_path.to have_text(document.title) }
    end
    it "returns a document" do
      expect { get documents_path.to have_text(document.person.title) }
    end
  end
end
