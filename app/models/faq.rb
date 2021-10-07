# frozen_string_literal: true

class Faq < ApplicationRecord
  include Friendable

  validates :title, :answering, presence: true
  has_rich_text :answer
  has_one :action_text_rich_text, class_name: "ActionText::RichText", as: :record, dependent: :nullify

  def self.search(q)
    if q
      Faq.joins(:action_text_rich_text)
          .where("action_text_rich_texts.body REGEXP ? OR title REGEXP ?", "(^|\\W)#{q}(\\W|$)", "(^|\\W)#{q}(\\W|$)")
    end
  end
end
