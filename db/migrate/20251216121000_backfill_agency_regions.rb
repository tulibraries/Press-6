# frozen_string_literal: true

class BackfillAgencyRegions < ActiveRecord::Migration[7.2]
  def up
    Agency.reset_column_information
    Region.reset_column_information

    Agency.find_each do |agency|
      region = find_region_for(agency)
      next unless region

      agency.update_columns(region_id: region.id, region: region.name) # rubocop:disable Rails/SkipsModelValidations
    end
  end

  def down
    # no-op: data correction only
  end

  private

    def find_region_for(agency)
      return Region.find_by(id: agency.region_id) if agency.region_id.present?

      parsed = parse_region_label(agency.region)
      scope = Region.where(name: parsed[:name])
      scope = scope.where(rights_designation: parsed[:designation]) if parsed[:designation]
      scope.first || Region.find_by(name: parsed[:name])
    end

    def parse_region_label(label)
      normalized = label.to_s.sub(/\s*\(.*\)\s*\z/, "").strip
      base_name = normalized.gsub(/\b(world\s+exclusive|non[-\s]?exclusive|exclusive)\b(\s+rights?)?/i, "").strip
      name = base_name.presence || normalized

      designation =
        if normalized.match?(/world\s+exclusive/i)
          Region.rights_designations[:world_exclusive]
        elsif normalized.match?(/non[-\s]?exclusive/i)
          Region.rights_designations[:non_exclusive]
        elsif normalized.match?(/exclusive/i)
          Region.rights_designations[:exclusive]
        end

      { name: name, designation: designation }
    end
end
