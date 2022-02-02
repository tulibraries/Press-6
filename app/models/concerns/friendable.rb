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
      slug = [cleanup(self.book.sort_title)]
    when "Book"
      slug = [cleanup(self.sort_title)]
    else
      if title.present?
        slug = self.title.parameterize
      end
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
        [cleanup(self.book.sort_title)],
        [:title_and_sequence]
      ]
    when "Book"
      [
        [cleanup(self.sort_title)],
        [:title_and_sequence]
      ]
    else
      [
        [cleanup(self.title)],
        [:title_and_sequence]
      ]
    end
  end

  def cleanup(html)
    ActionController::Base.helpers.strip_tags(html)
  end
end
