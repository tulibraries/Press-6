# frozen_string_literal: true

require "open-uri"
require "resolv-replace"
require "logger"

namespace :import do
  task conferences_json: [:environment] do
    response = HTTParty.get("http://tupress.temple.edu/conferences/conferences.json")
    conferences = JSON.parse(response.body)

    @updated = 0
    @not_saved = 0
    @created = 0
    @conferences = 0
    @images = 0
    @pdfs = 0
    @errored = 0
    @log = Logger.new("log/sync-conferences.log")
    @stdout = Logger.new($stdout)

    conferences.each do |conference|
      conference_to_update = (
                              Conference.find_by(title: conference["conference"]) || Conference.new
                            )

      new_conference = true if conference_to_update.title.blank?

      record_hash =
        {
          "title" => conference["conference"],
          "dates" => conference["dates"],
          "start_date" => DateTime.now,
          "end_date" => DateTime.now,
          "link" => conference["link"],
          "venue" => conference["venue"],
          "location" => conference["location"],
          "booth" => conference["booth"]
        }

      if record_hash["location"].blank?
        stdout_and_log(%(No location: #{record_hash['title']}))
        record_hash["location"] = "Not specified"
      end

      conference_to_update.update(record_hash)

      begin
        if conference_to_update.save!
          @updated += 1 unless new_conference
          @created += 1 if new_conference
        else
          stdout_and_log(%(Conference record unable to be saved for #{record_hash['title']}))
          @not_saved += 1
        end
      rescue StandardError => e
        stdout_and_log(%(#{record_hash['title']}: #{e.message} -- loc= #{record_hash['location']} --))
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
