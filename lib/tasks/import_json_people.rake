# frozen_string_literal: true

require "open-uri"
require "resolv-replace"
require "logger"

namespace :import do
  task people_json: [:environment] do
    response = HTTParty.get("http://tupress.temple.edu/people/list.json")
    persons = JSON.parse(response.body)

    @updated = 0
    @not_saved = 0
    @created = 0
    @persons = 0
    @images = 0
    @pdfs = 0
    @errored = 0
    @log = Logger.new("log/sync-people.log")
    @stdout = Logger.new($stdout)

    persons.each do |person|
      person_to_update = (
                              Person.find_by(email: person["email"]) || Person.new
                            )

      new_person = true if person_to_update.email.blank?

      record_hash =
        {
          "title" => person["name"],
          "email" => person["email"],
          "position" => person["position"],
          "position_description" => person["position_description"],
          "department" => person["department"],
          "document_contact" => person["document_contact"]
        }

      person_to_update.update(record_hash)

      begin
        if person_to_update.save!
          @updated += 1 unless new_person
          @created += 1 if new_person
        else
          stdout_and_log(%(Person record unable to be saved for #{record_hash['title']}))
          @not_saved += 1
        end
      rescue StandardError => e
        stdout_and_log(%(Person title: #{record_hash['title']} -- #{e.message}))
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
