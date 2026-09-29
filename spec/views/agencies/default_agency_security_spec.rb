# frozen_string_literal: true

require "rails_helper"

RSpec.describe "agencies/_default_agency", type: :view do
  let(:agency) { build(:agency, website: "https://example.com", email: "agent@example.com") }

  before do
    assign(:default_agency, agency)
    allow(view).to receive(:current_user).and_return(nil)
  end

  it "escapes contact, phone, and fax while retaining email and website links" do
    payload = '<img src=x onerror="alert(1)">'
    agency.contact = agency.phone = agency.fax = payload
    render partial: "agencies/default_agency"

    html = Nokogiri::HTML.fragment(rendered)
    expect(html.css("img, [onerror]")).to be_empty
    expect(html.text.scan(payload).size).to eq(3)
    expect(html.at_css('a[href="mailto:agent@example.com"]').text).to eq("agent@example.com")
    expect(html.at_css('a[href="https://example.com"]').text).to eq("https://example.com")
  end

  ["javascript:alert(1)", "data:text/html,<script>alert(1)</script>", 'https://example.com/<img src=x onerror="alert(1)">'].each do |website|
    it "safely renders website #{website.inspect}" do
      agency.website = website
      render partial: "agencies/default_agency"

      html = Nokogiri::HTML.fragment(rendered)
      expect(html.text).to include(website)
      expect(html.css("script, img, [onerror]")).to be_empty
      website_link = html.css("a").find { |link| link.text == website }
      expect(website_link).to be_present
      if website.start_with?("https:")
        expect(URI::DEFAULT_PARSER.unescape(website_link["href"])).to eq(website)
      else
        expect(website_link["href"]).to be_nil
      end
    end
  end
end
