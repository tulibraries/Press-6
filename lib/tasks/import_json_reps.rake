# frozen_string_literal: true

require "open-uri"
require "resolv-replace"
require "logger"

namespace :import do
  task reps_json: [:environment] do

    response = HTTParty.get("http://localhost:3001/reps.json")
    reps = JSON.parse(response.body)

    @updated = 0
    @not_saved = 0
    @created = 0
    @reps = 0
    @images = 0
    @pdfs = 0
    @errored = 0
    @log = Logger.new("log/sync-reps.log")
    @stdout = Logger.new(STDOUT)

    reps.each do |rep|

      rep_to_update = (
                              Person.find_by(email: rep["email"]) ?
                              Person.find_by(email: rep["email"])
                              :
                              Person.new
                            )

      new_rep = true if rep_to_update.email.blank?

      record_hash =
      {
        "title"         => rep.dig("name"),
        "department"    => "Sales Reps",
        "email"         => rep.dig("email"),
        "company"       => rep.dig("company"),
        "address"       => rep.dig("address"),
        "phone"         => rep.dig("phone"),
        "fax"           => rep.dig("fax"),
        "region"        => rep.dig("region"),
        "coverage"      => rep.dig("coverage")
      }

      rep_to_update.update(record_hash)

      begin
        if rep_to_update.save!
          @updated += 1 unless new_rep
          @created += 1 if new_rep
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
