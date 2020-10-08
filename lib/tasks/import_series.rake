require 'nokogiri'
require 'yaml'
require 'pry'

namespace :db do
    namespace :seed do

      desc 'Import book series to database'
      task :import_series, [:filepath] => :environment do |t, args|


      REVIEW_DATA = args.fetch(:filepath)

      if REVIEW_DATA 
        doc = File.open(REVIEW_DATA, 'rb:UTF-16le') { |f| Nokogiri::XML(f) }
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

      unless node.xpath("series/series_id").empty?

        node.xpath("series").map do |newseries|

          series = Series.find_by(series_code: newseries.xpath("series_id").text)

          if series.nil?
            series = Series.new(series_id: newseries.xpath("series_id").text)
            new_series = true
          end

          series.tap do |r|
            r.series_code = node.xpath("series_id").text
            r.series_name = node.xpath("series_title").text
            r.description = node.xpath("series_description").text
            r.editors = node.xpath("review_text").text
          end #tap


          if series.save
            unless new_series.nil?
              created_ids << series.series_id
            end
          else
              error_ids << series.series_id
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
