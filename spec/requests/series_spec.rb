# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/series", type: :request do
  let(:series) { FactoryBot.create(:series) }
  let(:series2) { FactoryBot.create(:series, title: "For No One", code: "NO-01") }
  let(:book) { FactoryBot.create(:book, series: series.code) }

  describe "index page renders subjects" do
    it "returns a series" do
      expect { get series_index_path.to have_text(series.title) }
    end
    it "does not return a series with no books" do
      expect { get series_index_path.not_to have_text(series2.title) }
    end
    it "returns a book" do
      expect { get series_index_path.to have_text(book.title) }
    end
  end

  describe "show page renders books" do
    it "returns books by series" do
      expect { get series_path.to have_text(book.title) }
    end
  end
end
