# frozen_string_literal: true

require "open-uri"
require "resolv-replace"
require "logger"

namespace :import do
  task documents_json: [:environment] do
    response = HTTParty.get("http://tupress.temple.edu/documents.json")
    documents = JSON.parse(response.body)

    @updated = 0
    @not_saved = 0
    @created = 0
    @documents = 0
    @errored = 0
    @log = Logger.new("log/sync-documents.log")
    @stdout = Logger.new($stdout)

    def attach_document(doc, path)
      unless doc.document.attached?
        doc.document.attach(
          io: URI.open("http://tupress.temple.edu#{path}"),
          filename: path.sub("/uploads/documents/", "")
        )
      end
      @documents += 1
    rescue StandardError => e
      stdout_and_log("Syncing Document #{document.title}, -- errored --  #{e.message} ")
      @errored += 1
    end

    @person = Person.new(title: "TBD", department: "Administration", email: "tempress@temple.edu")
    @person.save!

    documents.each do |document|
      document_to_update = (
                              Document.find_by(title: document["title"]) || Document.new
                            )

      new_document = true if document_to_update.title.blank?

      record_hash =
        {
          "title" => document["title"],
          "document" => document["filename"]["url"],
          "document_type" => document["department"],
          "person" => @person
        }

      document_to_update.update(record_hash.except("document"))

      begin
        attach_document(document_to_update, record_hash["document"]) if record_hash["document"].present?
      rescue StandardError => e
        stdout_and_log(%(Rescued: #{record_hash['title']}: #{e.message}))
        @not_saved += 1
      end

      begin
        if document_to_update.save!
          @updated += 1 unless new_document
          @created += 1 if new_document
        else
          stdout_and_log(%(Document record unable to be saved for #{record_hash['title']}))
          @not_saved += 1
        end
      rescue StandardError => e
        stdout_and_log(%(Rescued: #{record_hash['title']}: #{e.message}))
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
