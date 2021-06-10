# frozen_string_literal: true

class AgenciesController < ApplicationController
  def index
    @default_agency = Agency.find_by(region: "All Other Territories")
    @agencies = Agency.where.not(region: "All Other Territories").group_by {|a| a.region}.map {|region, agencies| [region, agencies]}
  end
end
