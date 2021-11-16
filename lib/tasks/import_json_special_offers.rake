# frozen_string_literal: true

require "open-uri"
require "resolv-replace"
require "logger"

namespace :import do
  task special_offers_json: [:environment] do

    response = HTTParty.get("http://localhost:3001/promotions.json")
    special_offers = JSON.parse(response.body)

    @updated = 0
    @not_saved = 0
    @created = 0
    @special_offers = 0
    @images = 0
    @pdfs = 0
    @errored = 0
    @log = Logger.new("log/sync-special_offers.log")
    @stdout = Logger.new(STDOUT)

    def attach_pdf(sob, path)
      begin
        sob.pdf.attach(
          io: URI.open("http://tupress.temple.edu#{path}"),
          filename: path.sub("/uploads/promotions/", ""),
        )
        @images += 1
      rescue => err
        stdout_and_log("Syncing #{sob.title}, -- pdf errored --  #{err.message} ")
        @errored += 1
      end
    end

    special_offers.each do |special_offer|

      special_offer_to_update = (
                              SpecialOffer.find_by(title: special_offer["title"]) ?
                              SpecialOffer.find_by(title: special_offer["title"])
                              :
                              SpecialOffer.new
                            )

      new_special_offer = true if special_offer_to_update.title.blank?

      record_hash =
      {
        "title"              => special_offer.dig("title"),
        "intro_text"         => special_offer.dig("intro_text"),
        "pdf"                => special_offer.dig("pdf")["url"],
        "pdf_display_name"   => special_offer.dig("pdf_display_name"),
        "active"             => special_offer.dig("active")
      }

      xml_ids  = special_offer.dig("xml_ids")
      attach_pdf(special_offer_to_update, record_hash["pdf"]) if record_hash["pdf"].present?
      special_offer_to_update.update(record_hash.except("pdf"))

      begin
        if special_offer_to_update.save!

          JSON.parse(xml_ids).each do |id|
            sob = SpecialOfferBook.new(book_id: Book.find_by(xml_id: id).id, special_offer_id: special_offer_to_update.id)
            sob.save!
          end

          @updated += 1 unless new_special_offer
          @created += 1 if new_special_offer
        else
          stdout_and_log(%Q(Rep record unable to be saved for #{record_hash["title"]}))
          @not_saved += 1
        end
      rescue => err
        stdout_and_log(%Q(Rep title: #{record_hash["title"]} -- #{err.message}))
        @not_saved += 1
      end

      # stdout_and_log("Syncing completed with #{@updated} updated, #{@created} created, #{@errored} errored, and #{@not_saved} not saved.")
    end

    def stdout_and_log(message, level: :info)
      @log.send(level, message)
      @stdout.send(level, message)
    end

  end
end
