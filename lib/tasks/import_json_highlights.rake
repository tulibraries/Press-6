# frozen_string_literal: true

require "open-uri"
require "resolv-replace"
require "logger"

namespace :import do
  task highlights_json: [:environment] do
    response = HTTParty.get("http://tupress.temple.edu/highlights.json")
    highlights = JSON.parse(response.body)

    @updated = 0
    @not_saved = 0
    @created = 0
    @highlights = 0
    @images = 0
    @pdfs = 0
    @errored = 0
    @log = Logger.new("log/sync-highlights.log")
    @stdout = Logger.new($stdout)

    def attach_image(highlight, path)
      unless highlight.image.attached?
        highlight.image.attach(
          io: URI.open("http://tupress.temple.edu#{path}"),
          filename: path.sub("/uploads/highlight/images/", "")
        )
      end
      @images += 1
    rescue StandardError => e
      stdout_and_log("Syncing Highlight #{highlight.title}, -- errored --  #{e.message} ")
      @errored += 1
    end

    highlights.each do |highlight|
      highlight_to_update = (
                              Highlight.find_by(title: highlight["title"]) || Highlight.new
                            )

      new_highlight = true if highlight_to_update.title.blank?

      record_hash =
        {
          "title" => highlight["title"],
          "promote_to_homepage" => highlight["homepage"],
          "link" => highlight.fetch("link", "https://tupress.temple.edu"),
          "image" => highlight["image"]["url"],
          "alt_text" => "Alt text needed"
        }

      highlight_to_update.update(record_hash.except("image"))
      attach_image(highlight_to_update, record_hash["image"]) if record_hash["image"].present?

      begin
        if highlight_to_update.save!
          @updated += 1 unless new_highlight
          @created += 1 if new_highlight
        else
          stdout_and_log(%(Highlight record unable to be saved for #{record_hash['title']}))
          @not_saved += 1
        end
      rescue StandardError => e
        stdout_and_log(%(Highlight title: #{record_hash['title']} -- #{e.message}))
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
