class FaqsController < ApplicationController
  before_action :set_faq, only: %i[ show ]

  def index
    @faqs = Faq.all
  end

  def show
  end

  private
    def set_faq
      @faq = Faq.find(params[:id])
    end

end
