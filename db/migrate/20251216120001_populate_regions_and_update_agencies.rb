# frozen_string_literal: true

class PopulateRegionsAndUpdateAgencies < ActiveRecord::Migration[7.2]
  def up
    # Regions that should have exclusive rights
    exclusive_regions = ["Turkey", "Spanish & Portuguese languages, World", "Arabic World"]

    # Get all unique region names from agencies
    agency_regions = Agency.distinct.pluck(:region).compact.uniq

    # Process each region
    agency_regions.each do |region_name|
      next if region_name.blank?

      clean_name, rights_designation, normalized = parsed_region(region_name, exclusive_regions, default_rights: 1)

      upsert_region(clean_name, rights_designation, raw_name: normalized)
      if normalized.include?("Spanish & Portuguese languages, World") && clean_name != normalized
        Agency.where(region: normalized).update_all(region: clean_name) # rubocop:disable Rails/SkipsModelValidations
      end
      # Note: We do NOT update the agency.region field - it stays as the clean name
    end

    # Also process people regions
    people_regions = Person.distinct.pluck(:region).compact.reject(&:blank?).uniq

    people_regions.each do |region_name|
      # Skip if already processed from agencies
      next if agency_regions.include?(region_name)

      clean_name, rights_designation, normalized = parsed_region(region_name, exclusive_regions, default_rights: 0)
      upsert_region(clean_name, rights_designation, raw_name: normalized)
    end
  end

  def down
    # Remove all regions created by this migration
    Region.destroy_all
  end

  private

    # Derive clean name and rights designation from the raw region string.
    # - If the string includes "non-exclusive", use non_exclusive (1)
    # - If the string includes "exclusive", use exclusive (2)
    # - Otherwise fall back to provided default, but override to exclusive
    #   if the clean name is in the exclusive_regions list.
    def parsed_region(raw_name, exclusive_regions, default_rights:)
      normalized = raw_name.to_s.strip
      clean_name = normalized

      # Special cases to preserve legacy strings while normalizing names and rights
      if normalized == "Arabic World Exclusive Rights"
        clean_name = "Arabic"
        return [clean_name, 3, normalized]
      end

      if normalized.include?("Spanish & Portuguese languages, World")
        clean_name = "Spanish & Portuguese languages"
        return [clean_name, 3, normalized]
      end

      rights_designation =
        if normalized.match?(/world\s+exclusive/i)
          3
        elsif normalized.match?(/non[-\s]?exclusive/i)
          1
        elsif normalized.match?(/exclusive/i)
          2
        elsif exclusive_regions.include?(clean_name)
          2
        else
          default_rights
        end

      [clean_name, rights_designation, normalized]
    end

    # Create or update a Region for the given name and rights designation.
    def upsert_region(name, rights_designation, raw_name: nil)
      alt_names = [name, raw_name].compact.uniq
      existing = Region.where(name: alt_names)

      # If a record already exists with the clean name and desired rights, keep it.
      match = existing.find_by(name: name, rights_designation: rights_designation)
      return match if match.present?

      # If there is any region with these names, update the first one to the clean name
      # and desired rights designation.
      if existing.any?
        record = existing.first
        record.update!(name: name, rights_designation: rights_designation)
        return record
      end

      Region.create!(name: name, rights_designation: rights_designation)
    end
end
