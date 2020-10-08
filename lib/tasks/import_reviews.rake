require 'nokogiri'
require 'yaml'
require 'pry'

namespace :db do
    namespace :seed do

      desc 'Import book reviews to database'
      task :import_reviews, [:filepath] => :environment do |t, args|


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

      unless node.xpath("reviews/review/review_text").empty?

      node.xpath("reviews/review").map do |newreview|

        review = Review.find_by(review_id: newreview.xpath("review_id").text)

        # check all book reviews to see if review exists
        # if db reviews has more reviews than xml reviews for same book delete extras

        if review.nil?
          review = Review.new(review_id: newreview.xpath("review_id").text, weight: "0")
          new_review = true
        end

        review.tap do |r|

          r.title_id = node.xpath("book_id").text
          # use title_id to lookup book's reviews, add them to array
          r.title = node.xpath("title").text
          r.author = node.xpath("author_byline").text
          r.review = newreview.at("review_text").text
          r.weight = "0"

        end #tap


        if review.save
          unless new_review.nil?
            created_ids << review.title_id
          end
        else
            error_ids << review.title_id
        end

        new_review = nil

        end #map
      end #unless
    end #map

    # Check for reviews in the db but no longer in the feed
    # review must be for a title in the xml

    db_reviews = Review.all.each do |review|
      db_review_ids << review.review_id
    end

    doc.xpath("//record/reviews/review").map do |xml|
      xml_review_ids << xml.xpath("review_id").text
    end

    doc.xpath("//record").map do |xml|
      xml_book_ids << xml.xpath("book_id").text
    end


    xml_book_ids.each do |book_id| #for each book in the delta

      db_reviews = []

      db_reviews = Review.where(title_id: book_id) # collect all its review ids from the db

       db_reviews.each do |dbreview|
          if xml_review_ids.exclude? dbreview.review_id # if review from db is not in xml
            toDelete = Review.find_by(review_id: dbreview.review_id) #delete that review
            deleted_ids << dbreview.review_id.to_s
            toDelete.destroy
          end
        end

    end

      puts "deletions: "+deleted_ids.length.to_s
      puts "created: "+created_ids.length.to_s
      puts "errors: "+error_ids.length.to_s

      # harvest = ReviewHarvest.new(error_ids: error_ids, deleted_ids: deleted_ids, created_ids: created_ids)
      # harvest = ReviewHarvest.new(error_ids: error_ids, created_ids: created_ids)

      # harvest.save

    end #task
  end #namespace: seed
end #namespace: db
