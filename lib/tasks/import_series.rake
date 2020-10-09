require 'nokogiri'
require 'yaml'
require 'pry'

namespace :db do
    namespace :seed do

      desc 'Import book series to database'
      task :import_series, [:filepath] => :environment do |t, args|


      SERIES_DATA = args.fetch(:filepath)

      if SERIES_DATA 
        doc = File.open(SERIES_DATA, 'rb:UTF-16le') { |f| Nokogiri::XML(f) }      
      else
        doc = Nokogiri::XML("")
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

      doc.xpath("//record").map do |node|
      if node.xpath("series/series_id").text.present?

        node.xpath("series").map do |newseries|

          series = Series.find_by(code: newseries.xpath("series_id").text)

          if series.nil?
            series = Series.new(code: newseries.xpath("series_id").text)
            new_series = true
          end

          series.tap do |r|
            r.code = node.xpath("series/series_id").text
            r.title = node.xpath("series/series_title").text
            r.description = node.xpath("series/series_description").text
            r.editors = node.xpath("series/series_editors").text
          end #tap

          if series.save
            unless new_series.nil?
              created_ids << series.code
            end
          else
              error_ids << series.code
          end

          new_series = nil

        end #map
      end #unless
    end #map

    puts "created: "+created_ids.length.to_s
    puts "errors: "+error_ids.length.to_s

    end #task
  end #namespace: seed
end #namespace: db
