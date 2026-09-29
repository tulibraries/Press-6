# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Award headings", type: :view do
  [false, true].each do |signed_in|
    context "with signed_in=#{signed_in}" do
      before do
        allow(view).to receive(:current_user).and_return(signed_in ? Object.new : nil)
        allow(view).to receive(:controller_name).and_return("books")
        stub_template "_books.html.erb" => ""
      end

      it "escapes a script-like year parameter" do
        allow(view).to receive(:action_name).and_return("awards_by_year")
        view.params[:id] = "<script>alert(1)</script>"
        render template: "books/awards_by_year"

        heading = Nokogiri::HTML.fragment(rendered).at_css("h1")
        expect(heading.text).to include("<script>alert(1)</script>")
        expect(heading.css("script")).to be_empty
      end

      it "preserves subject typography while stripping unsafe markup" do
        allow(view).to receive(:action_name).and_return("awards_by_subject")
        assign(:subject, Subject.new(title: '<em onclick="alert(1)">History</em><script>alert(1)</script>', slug: "history"))
        render template: "books/awards_by_subject"

        heading = Nokogiri::HTML.fragment(rendered).at_css("h1")
        expect(heading.at_css("em").text).to eq("History")
        expect(heading.css("script, [onclick]")).to be_empty
        expect(heading.css("a").size).to eq(signed_in ? 1 : 0)
      end
    end
  end
end
