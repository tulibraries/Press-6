# frozen_string_literal: true

module SubjectsHelper
  def sort_link(sort_type)
    if sort_type == "year"
      link_to "Sort Alphabetically", subject_path(@subject)
    else
      link_to "Most recent first", subject_path(@subject, sort: "year")
    end
  end
end
