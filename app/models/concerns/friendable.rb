# frozen_string_literal: true

module Friendable
  extend ActiveSupport::Concern
  included do
    extend FriendlyId
    friendly_id :slug_candidates, use: :slugged
  end

  def title_and_sequence
    case self.class
    when "Review"
      slug = [cleanup(book.sort_title)]
    when "Book"
      slug = [cleanup(sort_title)]
    else
      slug = title.parameterize if title.present?
    end
    if self.class.count > 1
      sequence = self.class.where("slug like ?", "%#{slug}%").count
      "#{slug}--#{sequence}"
    end
  end

  def slug_candidates
    case self.class
    when "Review"
      [
        [cleanup(book.sort_title)],
        [:title_and_sequence]
      ]
    when "Book"
      [
        [cleanup(sort_title)],
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
end
