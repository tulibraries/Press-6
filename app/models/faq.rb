# frozen_string_literal: true

class Faq < ApplicationRecord
  include Friendable

  validates :title, :answer, presence: true
  has_rich_text :answer
  has_one :action_text_rich_text, class_name: "ActionText::RichText", as: :record, dependent: :nullify

  def self.search(q)
    if q
      q = q.last.present? ? q : q[0...-1]
      escaped_q = Regexp.escape(q)
      Faq.joins(:action_text_rich_text)
         .where("action_text_rich_texts.body ~* ? OR title ~* ?", "(^|\\W)#{escaped_q}(\\W|$)", "(^|\\W)#{escaped_q}(\\W|$)")
    end
  end
end
