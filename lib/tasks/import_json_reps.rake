# frozen_string_literal: true

require "open-uri"
require "resolv-replace"
require "logger"

namespace :import do
  task reps_json: [:environment] do
    response = HTTParty.get("http://tupress.temple.edu/reps.json")
    reps = JSON.parse(response.body)

    @updated = 0
    @not_saved = 0
    @created = 0
    @reps = 0
    @images = 0
    @pdfs = 0
    @errored = 0
    @log = Logger.new("log/sync-reps.log")
    @stdout = Logger.new($stdout)

    reps.each do |rep|
      rep_to_update = (
                              Person.find_by(email: rep["email"]) || Person.new
                            )

      new_rep = true if rep_to_update.email.blank?

      record_hash =
        {
          "title" => rep["name"],
          "department" => "Sales Reps",
          "email" => rep["email"],
          "company" => rep["company"],
          "address" => rep["address"],
          "phone" => rep["phone"],
          "fax" => rep["fax"],
          "region" => rep["region"],
          "coverage" => rep["coverage"]
        }

      rep_to_update.update(record_hash)

      begin
        if rep_to_update.save!
          @updated += 1 unless new_rep
          @created += 1 if new_rep
        else
          stdout_and_log(%(Rep record unable to be saved for #{record_hash['title']}))
          @not_saved += 1
        end
      rescue StandardError => e
        stdout_and_log(%(Rep title: #{record_hash['title']} -- #{e.message}))
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
