# frozen_string_literal: true

module ApplicationHelper
  def aria_hidden(model)
    if model.class.to_s == "Book"
      alt_text = model.cover_alt_text
    else
      alt_text = model.image_alt_text
    end
    alt_text.present? ? false : true
  end

  def cover_alt_text(model)
    prefix = t("tupress.default.cover_alt_text")
    case model.class.to_s
    when "Book"
      model.cover_alt_text.presence || "#{prefix} #{model.title}"
    when "Highlight"
      model.alt_text.presence || model.title
    else
      model.image_alt_text.presence
    end
  end

  def search_glass
    image_path("mag.png")
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
        case action_name
        when "show"
          "/admin/#{controller_name}/#{book_id}/edit"
        when "index"
          "/admin/#{controller_name}"
        when "awards_by_subject"
          "/admin/subjects/#{id_from_index}/edit"
        when "awards_by_year"
          "/admin/#{controller_name}"
        when "course_adoptions"
          "/admin/#{controller_name}"
        when "study_guides"
          "/admin/#{controller_name}"
        when "study_guide"
          "/admin/#{controller_name}"
        end
      when "agencies"
        if book_id.nil? && id_from_index.nil?
          "/admin/#{controller_name}"
        else
          "/admin/#{controller_name}/#{id_from_index}/edit"
        end
      when "people"
        case action_name
        when "index"
          if book_id.nil? && id_from_index.nil?
            "/admin/#{controller_name}"
          else
            "/admin/#{controller_name}/#{id_from_index}/edit"
          end
        when "sales_reps"
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
    elsif ["index", "labor_studies", "north_broad_press"].include?(action_name)
      (id_from_index.present?) ? ("/admin/#{controller_name}/#{id_from_index}/edit") : ("/admin/#{controller_name.pluralize}")
    elsif id.present?
      "/admin/#{controller_name}/#{id}/edit"
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
        link_to linkable.title.html_safe, edit_url(linkable.slug)
      end
    else
      linkable.is_a?(String) ? linkable.presence : linkable.title.html_safe
    end
  end

  def edit_intro(id)
    link_to "[EDIT]", edit_admin_webpage_path(id) if current_user
  end

  def admin_url
    if (controller_name == "webpages" && action_name == "index") || controller_name == "forms"
      admin_root_path
    elsif controller_name == "series"
      send "admin_#{controller_name}_index_path"
    else
      send "admin_#{controller_name}_path"
    end
  end

  def menu_button(text)
    button_tag text,
               { id: "dropdownMenuButton", type: "button", class: "btn btn-lg btn-secondary dropdown-toggle",
                 style: "display:inline-block;border:0;",
                 "data-bs-toggle" => "dropdown", "aria-haspopup" => "true", "aria-expanded" => "false",
                 method: :get }
  end

  def current_year
    Time.zone.now.year
  end
end
