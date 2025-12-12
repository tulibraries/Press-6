# frozen_string_literal: true

module Friendable
  extend ActiveSupport::Concern
  included do
    extend FriendlyId
    friendly_id :slug_candidates, use: :slugged
  end

  def title_and_sequence
    base_slug =
      case self
      when Review
        cleanup(book.sort_title)
      when Book
        cleanup(sort_title)
      else
        title&.parameterize
      end

    return if base_slug.blank?

    if self.class.count > 1
      sequence = self.class.where("slug like ?", "%#{base_slug}%").count
      "#{base_slug}--#{sequence}"
    end
  end

  def slug_candidates
    case self
    when Review
      [
        [cleanup(book.sort_title)],
        [:title_and_sequence]
      ]
    when Book
      [
        [cleanup(sort_title)],
        [:title_and_sequence]
      ]
    when Region
      [
        [cleanup(title), rights_check],
        [:title_and_sequence]
      ]
    else
      [
        [cleanup(title)],
        [:title_and_sequence]
      ]
    end
  end

  def cleanup(html)
    ActionController::Base.helpers.strip_tags(html)
  end

  def rights_check
    case rights_designation
    when "exclusive", 2
      "exclusive-rights"
    when "non_exclusive", 1
      "non-exclusive-rights"
    when "world_exclusive", 3
      "world-exclusive-rights"
    else
      ""
    end
  end
end
