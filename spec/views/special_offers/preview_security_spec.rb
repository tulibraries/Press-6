# frozen_string_literal: true

require "rails_helper"

RSpec.describe "special_offers/index", type: :view do
  it "sanitizes stored preview HTML and preserves paragraphs, emphasis, and safe links" do
    offer = build_stubbed(:special_offer)
    raw = '<p class="custom"><em onclick="x()">Sale</em><a href="https://example.com">Info</a><a href="javascript:x()">Bad</a><script>x()</script></p>'
    allow(offer).to receive(:intro_text).and_return(double(body: raw))
    assign(:special_offers, [offer])
    allow(view).to receive(:current_user).and_return(nil)

    render template: "special_offers/index"

    preview = Nokogiri::HTML.fragment(rendered).at_css(".pt-0")
    expect(preview.at_css("p em").text).to eq("Sale")
    expect(preview.at_css('a[href="https://example.com"]').text).to eq("Info")
    expect(preview.css("script, [class], [onclick], a[href^='javascript:']")).to be_empty
  end
end
