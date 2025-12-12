# frozen_string_literal: true

class AddRegionReferenceToAgencies < ActiveRecord::Migration[7.2]
  def up
    add_reference :agencies, :region, foreign_key: true

    Agency.reset_column_information
    Region.reset_column_information

    Agency.find_each do |agency|
      next if agency.region_id.present?

      parsed = parse_region_label(agency.region)
      region_scope = Region.where(name: parsed[:name])
      region_scope = region_scope.where(rights_designation: parsed[:designation]) if parsed[:designation]
      region = region_scope.first || Region.find_by(name: parsed[:name])

      agency.update_columns(region_id: region.id) if region # rubocop:disable Rails/SkipsModelValidations
    end
  end

  def down
    remove_reference :agencies, :region, foreign_key: true
  end

  private

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
