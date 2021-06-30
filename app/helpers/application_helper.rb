# frozen_string_literal: true

module ApplicationHelper
  def search_glass
    asset_pack_path("media/images/mag.png")
  end

  # Close unclosed tags
  def fix_invalid_html(html)
    Nokogiri::HTML::DocumentFragment.parse(html).to_html
  end

  def edit_url(book = nil)
    id = params[:id]
    exemptions = [nil, "webpages", "books"]

    unless exemptions.include?(controller_name)
      if ["index", "labor_studies", "north_broad_press"].include?(action_name)
        "/admin/#{controller_name.pluralize}"
      else
        "/admin/#{controller_name}/#{id}/edit"
      end
    else
      if controller_name == "webpages" && action_name == "show"
        "/admin/#{controller_name}/#{id}/edit"
      elsif controller_name == "books" && action_name == "show"
        "/admin/#{controller_name}/#{book}/edit"
      else
        "/admin/#{controller_name}"
      end
    end
  def menu_button(text)
    button_tag text,
              { id: "dropdownMenuButton", type: "button", class: "btn btn-lg btn-secondary dropdown-toggle",
              style: "display:inline-block;border:0;",
              "data-toggle" => "dropdown", "aria-haspopup" => "true", "aria-expanded" => "false",
              method: :get }
  end
end
