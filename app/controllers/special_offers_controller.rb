# frozen_string_literal: true

class SpecialOffersController < ApplicationController
  before_action :set_special_offer, only: :show
  include SetInstance

  def index
    @special_offers = SpecialOffer.all.where(active: true)
  end

  def show
    @books = @special_offer.books
                           .displayable
                           .order(:sort_title)
                           .page params[:page]
  end

  private

    def set_special_offer
      @special_offer = find_instance
    end
end
