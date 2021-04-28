# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do

  describe ApplicationHelper do
    describe "search-glass image lookup" do
      it "returns the path to the file" do
        expect(helper.search_glass).to include("media/images/mag-")
      end
    end

    describe "fix_invalid_html" do
      it "corrects faulty html passed into it" do
        expect(helper.fix_invalid_html("<p><b>Nonsense!</p>")).to eq("<p><b>Nonsense!</b></p>")
      end
    end

  end

end
