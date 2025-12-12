# frozen_string_literal: true

class AgenciesController < ApplicationController
  def index
    @default_agency = Agency.find_by(region: "All Other Territories")
    scoped = Agency.where.not(region: "All Other Territories").includes(:region_ref)
    grouped = scoped.group_by do |agency|
      record = agency.region_record
      designation = record&.rights_designation || agency.send(:parsed_rights_designation)
      name = record&.name || agency.region
      [name, designation]
    end

    @agencies = grouped.sort_by { |(name, designation), _| [name.to_s, designation.to_s] }
                       .map { |(name, _designation), agencies| [name, agencies] }
  end
end
