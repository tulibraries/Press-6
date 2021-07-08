# frozen_string_literal: true

class SpecialOffersController < ApplicationController
  before_action :set_special_offer, only: %i[show]

  def index
    @special_offers = SpecialOffer.all
  end

  def show
  end

  private
    def set_special_offer
      @special_offer = SpecialOffer.find(params[:id])
    end
end
