# frozen_string_literal: true

require 'nokogiri'
require 'yaml'
require 'pry'

namespace :db do
  namespace :seed do
    desc 'Import book catalogs to database'
    task :import_catalogs, [:filepath] => :environment do |t, args|
      CATALOGS_DATA = args.fetch(:filepath)

      doc = if CATALOGS_DATA
              File.open(CATALOGS_DATA, 'rb:UTF-16le') { |f| Nokogiri::XML(f) }
            else
              Nokogiri::XML('')
            end

      error_ids = []
      created_ids = []
      updated_ids = []
      deleted_ids = []
      xml_review_ids = []
      xml_book_ids = []
      db_reviews = []
      db_review_ids = []
      new_review = nil

      doc.xpath('//record').map do |node|
        next unless node.xpath('catalog').text.present?

        next unless %w[sp fa].include?(node.xpath('catalog').text[0, 2].downcase) &&
                    Float(node.xpath('catalog').text[2, 4], exception: false)

        node.xpath('catalog').map do |newcatalog|
          catalog = Catalog.find_by(code: newcatalog.text)

          if catalog.nil?
            catalog = Catalog.new(code: newcatalog.text)
            new_catalog = true
          end

          catalog.tap do |r|
            r.code = newcatalog.text
            binding.pry if newcatalog.text[2, 4].nil?
            r.season = 'Fall' if newcatalog.text[0, 2].downcase == 'fa'
            r.season = 'Spring' if newcatalog.text[0, 2].downcase == 'sp'
            # Y2k concerns since all years are only last 2 digits
            decade = newcatalog.text[2, 4]
            current_century = Time.now.strftime('%C')
            r.year = "#{current_century}#{decade}"
            r.year = "19#{decade}" if decade.to_i >= 78 && decade.to_i <= 99
            # Y2K Uncomment above line when running first time
            r.title = r.season.to_s + ' ' + r.year.to_s + ' Catalog'
          end # tap

          if catalog.save
            created_ids << catalog.code unless new_catalog.nil?
          else
            error_ids << catalog.code
          end

          new_catalog = nil
        end
        # map
        # unless
      end # map

      puts 'catalogs updated: ' + created_ids.length.to_s
      puts 'catalogs errored: ' + error_ids.length.to_s
    end # task
  end # namespace: seed
end # namespace: db
