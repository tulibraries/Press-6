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
      Webpage.joins(:action_text_rich_text)
             .where("action_text_rich_texts.body REGEXP ? OR title REGEXP ?", "(^|\\W)#{q}(\\W|$)", "(^|\\W)#{q}(\\W|$)")
    end
  end
end
