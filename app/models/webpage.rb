# frozen_string_literal: true

class Webpage < ApplicationRecord
  include Imageable
  include Friendable

  validates :title, presence: true
  has_rich_text :body

  has_one :action_text_rich_text, class_name: "ActionText::RichText", as: :record, dependent: :nullify

  def self.search(q)
    if q
      q = q.last.present? ? q : q[0...-1]
      escaped_q = Regexp.escape(q)
      Webpage.joins(:action_text_rich_text)
             .where("action_text_rich_texts.body ~* ? OR title ~* ?", "(^|\\W)#{escaped_q}(\\W|$)", "(^|\\W)#{escaped_q}(\\W|$)")
    end
  end
end
