# frozen_string_literal: true

module SubjectsHelper
  def sort_link(subject, sort_type)
    if sort_type == "year"
      link_to t("tupress.subjects.sort_alpha"), subject_path(subject)
    else
      link_to t("tupress.subjects.sort_recent"), subject_path(subject, sort: "year")
    end
  end
end
