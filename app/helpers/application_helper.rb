# frozen_string_literal: true

module ApplicationHelper
  def search_glass
    asset_pack_path("media/images/mag.png")
  end

  # Close unclosed tags
  def fix_invalid_html(html)
    Nokogiri::HTML::DocumentFragment.parse(html).to_html
  end

  def menu_button(text)
    button_tag text,
              { id: "dropdownMenuButton", type: "button", class: "btn btn-lg btn-secondary dropdown-toggle",
              style: "display:inline-block;border:0;",
              "data-toggle" => "dropdown", "aria-haspopup" => "true", "aria-expanded" => "false",
              method: :get }
  end
end
