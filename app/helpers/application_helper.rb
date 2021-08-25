# frozen_string_literal: true

module ApplicationHelper
  def search_glass
    asset_pack_path("media/images/mag.png")
  end

  # Close unclosed tags
  def fix_invalid_html(html)
    Nokogiri::HTML::DocumentFragment.parse(html).to_html
  end

  def edit_url(book_id = nil, id_from_index = nil)
    id = book_id.nil? ? params[:id] : book_id

    exemptions = [nil, "webpages", "books", "people"]

    if exemptions.include?(controller_name)
      if controller_name == "webpages" && action_name == "show"
        "/admin/#{controller_name}/#{id}/edit"
      elsif controller_name == "books" && action_name == "show"
        "/admin/#{controller_name}/#{book_id}/edit"
      else
        "/admin/#{controller_name}"
      end
    else
      if ["index", "labor_studies", "north_broad_press"].include?(action_name)
        (id_from_index.present?) ? ("/admin/#{controller_name}/#{id_from_index}/edit") : ("/admin/#{controller_name.pluralize}")
      else
        "/admin/#{controller_name}/#{id}/edit" if id.present?
      end
    end
  end

  def title_link(title = nil, id = nil)
    if current_user && ["index", "sales_reps"].include?(action_name)
      id.present? ? (link_to title, edit_url(nil, id)) : (link_to title, edit_url)
    elsif current_user && action_name == "show"
      link_to title, edit_url(id)
    else
      title.presence
    end
  end

  def edit_intro(id)
    link_to "[EDIT]", edit_admin_webpage_path(id) if current_user
  end

  def admin_url
    if controller_name == "webpages" && action_name == "index"
      admin_root_path
    else
      send "admin_#{controller_name}_path"
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
