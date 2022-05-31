# frozen_string_literal: true

require "open-uri"
require "resolv-replace"
require "logger"

namespace :import do
  task agencies_json: [:environment] do
    response = HTTParty.get("http://tupress.temple.edu/agencies.json")
    agencies = JSON.parse(response.body)

    @updated = 0
    @not_saved = 0
    @created = 0
    @agencies = 0
    @images = 0
    @pdfs = 0
    @errored = 0
    @log = Logger.new("log/sync-agencies.log")
    @stdout = Logger.new($stdout)

    agencies.each do |agency|
      agency_to_update = (
                              Agency.find_by(email: agency["email"]) || Agency.new
                            )

      new_agency = true if agency_to_update.email.blank?

      record_hash =
        {
          "title" => agency.fetch("title", "Temple"),
          "email" => agency["email"],
          "contact" => agency["contact"],
          "address" => "#{agency['address1']}<br>#{agency['address2']}<br>#{agency['address3']}<br>#{agency['city']}<br>#{agency['country']}",
          "phone" => agency["phone"],
          "fax" => agency["fax"],
          "region" => agency["region"],
          "website" => agency["website"]
        }

      agency_to_update.update(record_hash)

      begin
        if agency_to_update.save!
          @updated += 1 unless new_agency
          @created += 1 if new_agency
        else
          stdout_and_log(%(Agency record unable to be saved for #{record_hash['title']}))
          @not_saved += 1
        end
      rescue StandardError => e
        stdout_and_log(%(Agency title: #{record_hash['title']} -- #{e.message}))
        @not_saved += 1
      end

      stdout_and_log("Syncing completed with #{@updated} updated, #{@created} created, #{@errored} errored, and #{@not_saved} not saved.")
    end

    def stdout_and_log(message, level: :info)
      @log.send(level, message)
      @stdout.send(level, message)
    end
  end
end
