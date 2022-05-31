# frozen_string_literal: true

require 'logger'

module SyncService
  class Reviews
    def self.call(xml_path: nil)
      new(xml_path:).sync
    end

    def initialize(params = {})
      @log = Logger.new('log/sync-reviews.log')
      @stdout = Logger.new($stdout)
      @xmlPath = params.fetch(:xml_path)
      @booksDoc = Nokogiri::XML(File.open(@xmlPath), &:noblanks)
      @deleted_ids = []
      @xml_review_ids = []
      @xml_book_ids = []
      @db_review_ids = []
      stdout_and_log("Syncing reviews from #{@xmlPath}")
    end

    def sync
      @updated = @created = @errored = 0
      read_reviews.each do |book|
        if book.is_a?(Hash)
          @log.info(%(Syncing reviews for: #{book['record']['title']}))
          record = record_hash(book)
          create_or_update!(record)
        else # when node is returned from read_reviews
          reviews = book.at('reviews').children.map(&:to_xml)
          if reviews.present?
            book = { 'reviews' => reviews }
            create_or_update!(book)
          else
            @log.info(%(Syncing review for book: #{book.at('book_id').text}))
          end
        end
      rescue Exception => e
        stdout_and_log("sync error:  #{e.message} \n #{e.backtrace}")
        @errored += 1
      end

      prune_reviews

      stdout_and_log("Syncing completed with #{@created} created, #{@updated} updated, #{@deleted_ids.length} deleted, and #{@errored} errored records.")
    end

    def read_reviews
      @booksDoc.xpath('//record').map do |node|
        node_xml = node.to_xml
        begin
          Hash.from_xml(node_xml)
        rescue REXML::ParseException => e
          node
        end
      end
    end

    def record_hash(record)
      unless record == true
        {
          'reviews' => record.fetch('record', nil)['reviews']['review'],
          'book_id' => record.fetch('record', nil)['book_id']
        }
      end
    end

    def create_or_update!(record_hash)
      reviews = record_hash['reviews']
      book = record_hash['book_id']

      unless record_hash.nil?
        begin
          reviews.each do |review|
            r = Review.find_by(review_id: review['review_id'])
            if r
              stdout_and_log(
                %(Incoming book with review '#{r['review_id']}' matched to existing review '(code = #{r.review_id} )', level: :debug)
              )
              @updated += 1
            else
              r = Review.new
              @created += 1
            end

            r['review_id'] = review['review_id']
            r['review'] = review['review_text']
            r['book_id'] = record_hash['book_id']
            r['weight'] = 0

            stdout_and_log(%(Successfully saved record for: #{r['review_id']})) if r['review'].present? && r.save!
          end
        rescue Exception => e
          if e.message == 'no implicit conversion of String into Integer' # empty tags
            stdout_and_log(%(Empty review tags for:  #{book['record']['title']}))
          else
            stdout_and_log("Syncing Review: #{book['record']['title']} - #{e.message} \n #{e.backtrace}")
          end
        end
      end
    end

    def prune_reviews
      # Check for reviews in the db but no longer in the feed
      # review must be for a title in the xml
      db_reviews = Review.all.each do |review|
        @db_review_ids << review.review_id
      end
      @booksDoc.xpath('//record/reviews/review').map do |xml|
        @xml_review_ids << xml.xpath('review_id').text
      end
      @booksDoc.xpath('//record').map do |xml|
        @xml_book_ids << xml.xpath('book_id').text
      end
      @xml_book_ids.each do |book_id| # for each book in the delta
        db_reviews = []
        db_reviews = Review.where(book_id:) # collect all its review ids from the db
        db_reviews.each do |dbreview|
          next unless @xml_review_ids.exclude? dbreview.review_id # if review from db is not in xml

          toDelete = Review.find_by(review_id: dbreview.review_id) # delete that review
          @deleted_ids << dbreview.review_id.to_s
          toDelete.destroy
        end
      end
    end

    def stdout_and_log(message, level: :info)
      @log.send(level, message)
      @stdout.send(level, message)
    end
  end
end
