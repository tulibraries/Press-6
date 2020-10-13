# frozen_string_literal: true

require 'nokogiri'
require 'yaml'
require 'pry'

namespace :db do
  namespace :seed do
    desc 'Import book series to database'
    task :import_series, [:filepath] => :environment do |_t, args|
      SERIES_DATA = args.fetch(:filepath)

      doc = if SERIES_DATA
              File.open(SERIES_DATA, 'rb:UTF-16le') { |f| Nokogiri::XML(f) }
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
        next unless node.xpath('series/series_id').text.present?

        node.xpath('series').map do |newseries|
          series = Series.find_by(code: newseries.xpath('series_id').text)

          if series.nil?
            series = Series.new(code: newseries.xpath('series_id').text)
            new_series = true
          end

          series.tap do |r|
            r.code = node.xpath('series/series_id').text
            r.title = node.xpath('series/series_title').text
            r.description = node.xpath('series/series_description').text
            r.editors = node.xpath('series/series_editors').text
          end # tap

          if series.save
            created_ids << series.code unless new_series.nil?
          else
            error_ids << series.code
          end

          new_series = nil
        end # map
        # unless
      end # map

      puts 'series updated: ' + created_ids.length.to_s
      puts 'series errored: ' + error_ids.length.to_s
    end # task
  end # namespace: seed
end # namespace: db
