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

    exemptions = [nil, "webpages", "books", "people", "agencies", "conferences"]

    if exemptions.include?(controller_name)
      case controller_name
      when "webpages"
        "/admin/#{controller_name}/#{id}/edit" if action_name == "show"
      when "books"
        if action_name == "show"
          "/admin/#{controller_name}/#{book_id}/edit"
        elsif action_name == "index"
          "/admin/#{controller_name}"
        elsif action_name == "awards_by_subject"
          "/admin/subjects/#{id_from_index}/edit"
        elsif action_name == "awards_by_year"
          "/admin/#{controller_name}"
        elsif action_name == "course_adoptions"
          "/admin/#{controller_name}"
        elsif action_name == "study_guides"
          "/admin/#{controller_name}"
        elsif action_name == "study_guide"
          "/admin/#{controller_name}"
        end
      when "agencies"
        if book_id.nil? && id_from_index.nil?
          "/admin/#{controller_name}"
        else
          "/admin/#{controller_name}/#{id_from_index}/edit"
        end
      when "people"
        if action_name == "index"
          if book_id.nil? && id_from_index.nil?
            "/admin/#{controller_name}"
          else
            "/admin/#{controller_name}/#{id_from_index}/edit"
          end
        elsif action_name == "sales_reps"
          if book_id.nil? && id_from_index.nil?
            "/admin/#{controller_name}"
          else
            "/admin/#{controller_name}/#{id_from_index}/edit"
          end
        end
      when "conferences"
        if book_id.nil? && id_from_index.nil?
          "/admin/#{controller_name}"
        else
          "/admin/#{controller_name}/#{id_from_index}/edit"
        end
      end
    else
      if ["index", "labor_studies", "north_broad_press"].include?(action_name)
        (id_from_index.present?) ? ("/admin/#{controller_name}/#{id_from_index}/edit") : ("/admin/#{controller_name.pluralize}")
      else
        "/admin/#{controller_name}/#{id}/edit" if id.present?
      end
    end
  end

  def title_link(linkable)
    if current_user
      if ["index", "sales_reps", "conferences", "study_guide", "study_guides", "course_adoptions",
          "agencies", "awards_by_subject", "awards_by_year"].include?(action_name)
        if linkable.is_a?(String)
          link_to linkable, edit_url
        else
          link_to linkable.title, edit_url(nil, linkable.slug)
        end
      elsif action_name == "show"
        link_to linkable.title, edit_url(linkable.slug)
      end
    else
      linkable.is_a?(String) ? linkable.presence : linkable.title
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
