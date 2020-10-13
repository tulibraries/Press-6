# frozen_string_literal: true

require 'nokogiri'
require 'yaml'
require 'pry'

namespace :db do
  namespace :seed do
    desc 'Import book subjects to database'
    task :import_subjects, [:filepath] => :environment do |_t, args|
      SUBJECTS_DATA = args.fetch(:filepath)

      doc = if SUBJECTS_DATA
              File.open(SUBJECTS_DATA, 'rb:UTF-16le') { |f| Nokogiri::XML(f) }
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
        next unless node.xpath('subjects/subject/subject_id').text.present?

        node.xpath('subjects/subject').map do |newsubject|
          subject = Subject.find_by(code: newsubject.xpath('subject_id').text)
          # binding.pry if subject.present?

          if subject.nil?
            subject = Subject.new(code: newsubject.xpath('subject_id').text)
            new_subject = true
          end

          subject.tap do |r|
            # binding.pry
            r.code = newsubject.xpath('subject_id').text
            r.title = newsubject.xpath('subject_title').text
          end # tap

          if subject.save
            created_ids << subject.code unless new_subject.nil?
          else
            error_ids << subject.code
          end

          new_subject = nil
        end # map
        # unless
      end # map

      puts 'subjects updated: ' + created_ids.length.to_s
      puts 'subjectes errored: ' + error_ids.length.to_s
    end # task
  end # namespace: seed
end # namespace: db
