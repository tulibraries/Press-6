# frozen_string_literal: true

module Friendable
  extend ActiveSupport::Concern
  included do
    extend FriendlyId
    friendly_id :slug_candidates, use: :slugged
  end

  def title_and_sequence
    if self.class == "Review"
      slug = self.book.title 
    else
      if title.present?
        slug = self.title.parameterize
      end
    end
      sequence = self.class.where("slug like ?", "%#{slug}%").count
      "#{slug}--#{sequence}"
  end

  def slug_candidates
    if self.class == "Review"
      [
        [self.book.title],
        [:title_and_sequence]
      ]
    else 
      [
        [:title],
        [:title_and_sequence]
      ]
    end
  end
end
