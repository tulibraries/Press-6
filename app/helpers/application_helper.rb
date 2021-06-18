# frozen_string_literal: true

module ApplicationHelper
  def search_glass
    asset_pack_path("media/images/mag.png")
  end

  # Close unclosed tags
  def fix_invalid_html(html)
    Nokogiri::HTML::DocumentFragment.parse(html).to_html
  end

  def edit_url
    path = request.env["PATH_INFO"]
    controller = path.split("/").slice(1)
    id = path.split("/").slice(2)
    exemptions = [nil, "webpages", "books"]

    unless exemptions.include?(controller)
      "/admin/#{controller}/#{id}/edit" if action_name == "show"
      "/admin/#{controller}" if action_name == "index"
    else
      if controller == "webpages" && action_name == "show"
        "/admin/#{controller}/#{id}/edit"
      elsif controller == "books" && action_name == "show"
        "/admin/#{controller}/#{@book.id}/edit"
      else
        "/admin/#{controller}"
      end
    end
  end
end
