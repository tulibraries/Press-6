# frozen_string_literal: true

module ApplicationHelper
  def search_glass
    asset_pack_path("media/images/mag.png")
  end

  # Close unclosed tags
  def fix_invalid_html(html)
    Nokogiri::HTML::DocumentFragment.parse(html).to_html
  end
end
