require 'nokogiri'
require 'yaml'

namespace :db do
    namespace :seed do

      desc 'Updates from Deltas'
      task :run_updates, [:file_path] => :environment do |t, args|
        filepath = args.fetch(:file_path, nil)
        if filepath && File.exist?(filepath) 
          Rake::Task["db:seed:import_books"].invoke(filepath)
          Rake::Task["db:seed:import_reviews"].invoke(filepath)
        end
      end

      desc 'Import books to database'
      task :import_books, [:filepath] => :environment do |t, args|

      BOOK_DATA = args.fetch(:filepath, nil)

      # If there is no file, create an empty node
      # so we don't throw an error when
      if BOOK_DATA 
        doc = File.open(BOOK_DATA, 'rb:UTF-16le') { |f| Nokogiri::XML(f) }
      else
        doc = Nokogiri::XML("")
      end

      error_ids = []
      created_ids = []
      updated_ids = []
      new_book = nil

      doc.xpath("//record").map do |node|
        book = Book.find_by(book_id: node.xpath("book_id").text)

        if book.nil?
          book = Book.new(book_id: node.xpath("book_id").text, title: " ")
          new_book = true
        end
        book.tap do |b|
          b.title = node.xpath("title").text
          b.subtitle = node.xpath("subtitle").text
          b.author_id = node.xpath("authors/author").map do |id|
            id.at("author_id").text
          end
          b.author_prefix = node.xpath("authors/author").map do |name|
            name.at("author_prefix").text
          end
          b.author_first = node.xpath("authors/author").map do |name|
            name.at("author_first").text
          end
          author_last = node.xpath("authors/author").map do |name|
            name.at("author_last").text
          end
          b.author_last = author_last.first
          b.author_suffix = node.xpath("authors/author").map do |name|
            name.at("author_suffix").text
          end
          b.author_byline = node.xpath("author_byline").text
          b.about_author = node.xpath("author_bios").text
          b.intro = node.xpath("intro").text
          b.blurb = node.xpath("blurb").text
          b.status = node.xpath("status").text
          b.pages_total = node.xpath("format/pages_total").text
          b.trim = node.xpath("format/trim").text
          b.illustrations = node.xpath("format/illustrations_copy").text
          b.isbn = node.xpath("isbn").text
          b.pub_date = node.xpath("pub_date").text
          b.in_series = node.xpath("series").map do |series|
            series.at("series_id").text
          end
          b.binding = node.xpath("bindings/binding").map do |bindings|
             Hash.from_xml(bindings.to_s)
          end
          b.description = node.xpath("description").text
          b.subjects = node.xpath("subjects/subject").map do |subject|
            Hash.from_xml(subject.to_s)
          end
          b.contents = node.xpath("contents").text
          b.hotweight = "1"
          b.newsweight = "1"
          b.catalog = node.xpath("catalog").text
        end #tap

        if book.save
          if !new_book.nil?
            created_ids << book.book_id
          else
            updated_ids << node.xpath("book_id").text
          end
        else
            error_ids << book.book_id
        end

        new_book = nil
      end #each

      puts "count: "+(updated_ids.length+created_ids.length).to_s+"\n"
      puts "errors: "+error_ids.length.to_s

      # harvest = Harvest.new(error_ids: error_ids, updated_ids: updated_ids, created_ids: created_ids)

      # harvest.save

    end #task
  end #namespace: seed
end #namespace: db
