# frozen_string_literal: true

module Friendable
  extend ActiveSupport::Concern
  included do
    extend FriendlyId
    friendly_id :slug_candidates, use: :slugged
  end

  def title_and_sequence
    slug = self.title.parameterize
    sequence = self.class.where("slug like ?", "%#{slug}%").count
    "#{slug}--#{sequence}"
  end

  def slug_candidates
    [
      [:title],
      [:title_and_sequence]
    ]
  end
end
