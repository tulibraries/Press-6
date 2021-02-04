# frozen_string_literal: true

class AgenciesController < ApplicationController
  before_action :set_agency, only: [:show]

  def index
    @agencies = Agency.all
  end

  def show
  end

  private
    def set_agency
      @agency = Agency.find(params[:id])
    end
end
