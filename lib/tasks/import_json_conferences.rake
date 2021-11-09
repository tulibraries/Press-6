# frozen_string_literal: true

require "open-uri"
require "resolv-replace"
require "logger"

namespace :import do
  task conferences_json: [:environment] do

    response = HTTParty.get("http://localhost:3001/conferences/conferences.json")
    conferences = JSON.parse(response.body)

    @updated = 0
    @not_saved = 0
    @created = 0
    @conferences = 0
    @images = 0
    @pdfs = 0
    @errored = 0
    @log = Logger.new("log/sync-conferences.log")
    @stdout = Logger.new(STDOUT)

    conferences.each do |conference|

      conference_to_update = (
                              Conference.find_by(title: conference["conference"]) ?
                              Conference.find_by(title: conference["conference"])
                              :
                              Conference.new
                            )

      new_conference = true if conference_to_update.title.blank?

      record_hash =
      {
        "title"           => conference.dig("conference"),
        "dates"           => conference.dig("dates"),
        "start_date"      => DateTime.now,
        "end_date"        => DateTime.now,
        "link"            => conference.dig("link"),
        "venue"           => conference.dig("venue"),
        "location"        => conference.dig("location"),
        "booth"           => conference.dig("booth")
      }

      unless record_hash["location"].present?
        stdout_and_log(%Q(location check: #{record_hash["title"]}))
        record_hash["location"] = "Not specified"
      end
      # conference_to_update.assign_attributes(record_hash) 
      # binding.pry if record_hash["title"] == "Northeast Modern Language Association"
      conference_to_update.update(record_hash)

      begin
        if conference_to_update.save!
          @updated += 1 unless new_conference
          @created += 1 if new_conference
        else
          stdout_and_log(%Q(Conference record unable to be saved for #{record_hash["title"]}))
          @not_saved += 1
        end
      rescue => err
        stdout_and_log(%Q(#{record_hash["title"]}: #{err.message} -- loc= #{record_hash["location"]} --))
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
