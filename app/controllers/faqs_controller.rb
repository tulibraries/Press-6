# frozen_string_literal: true

class FaqsController < ApplicationController
  include SetInstance
  before_action :set_faq, only: %i[show]

  def index
    @faqs = Faq.all
  end

  def show; end

  private

    def set_faq
      @faq = find_instance
    end
end
