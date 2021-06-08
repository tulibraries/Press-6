# frozen_string_literal: true

class AgenciesController < ApplicationController
  def index
    @agencies = Agency.all.group_by {|a| a.region}.map {|region, agencies| [region, agencies]}
    # binding.pry
  end
end
