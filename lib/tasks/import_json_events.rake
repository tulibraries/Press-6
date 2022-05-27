# frozen_string_literal: true

require "open-uri"
require "resolv-replace"
require "logger"

namespace :import do
  task events_json: [:environment] do
    response = HTTParty.get("http://tupress.temple.edu/events.json")
    events = JSON.parse(response.body)

    @updated = 0
    @not_saved = 0
    @created = 0
    @events = 0
    @images = 0
    @pdfs = 0
    @errored = 0
    @log = Logger.new("log/sync-events.log")
    @stdout = Logger.new($stdout)

    def combine(d, t)
      d = Date.parse(d) if d.is_a? String
      t = Time.zone.parse(t) if t.is_a? String
      DateTime.new(d.year, d.month, d.day, t.hour, t.min, t.sec)
    end

    def attach_image(event, path)
      unless event.image.attached?
        event.image.attach(
          io: URI.open("http://tupress.temple.edu#{path}"),
          filename: path.sub("/uploads/event/", "")
        )
      end
      @images += 1
    rescue StandardError => e
      stdout_and_log("Syncing Event #{event.title}, -- errored --  #{e.message} ")
      @errored += 1
    end

    events.each do |event|
      event_to_update = (
                              Event.find_by(id: event["id"]) || Event.new
                            )

      new_event = true if event_to_update.id.blank?

      record_hash =
        {
          "id" => event["id"],
          "title" => event["title"],
          "description" => event["dates"],
          "start_date" => event["startdate"],
          "end_date" => event["enddate"],
          "start_time" => event["time"],
          "end_time" => event["endtime"],
          "time_zone" => event["timezone"],
          "location" => event["location"],
          "add_to_news" => event["news"],
          "news_weight" => event["weight"],
          "image" => event["image"]["url"]
        }

      if record_hash["start_date"].present? && record_hash["start_time"].present?
        record_hash["start_date"] = combine(record_hash["start_date"], record_hash["start_time"])
      end
      if record_hash["start_date"].blank? && record_hash["start_time"].present?
        record_hash["start_date"] = record_hash["start_time"]
      end
      if record_hash["start_date"].blank? && record_hash["start_time"].blank? && record_hash["end_date"].present?
        record_hash["start_date"] = record_hash["end_date"]
        if record_hash["end_time"].present?
          record_hash["start_date"] =
            combine(record_hash["start_date"], record_hash["end_time"])
        end
      end
      if record_hash["start_date"].blank? && record_hash["start_time"].blank? && record_hash["end_date"].blank? && record_hash["end_time"].present?
        record_hash["start_date"] = record_hash["end_time"]
      end

      if record_hash["end_date"].present? && record_hash["end_time"].present?
        record_hash["end_date"] = combine(record_hash["end_date"], record_hash["end_time"])
      end
      if record_hash["end_date"].blank? && record_hash["end_time"].present?
        record_hash["end_date"] = combine(record_hash["start_date"], record_hash["end_time"])
      end
      if record_hash["end_date"].blank? && record_hash["end_time"].blank? && record_hash["start_date"].present?
        record_hash["end_date"] = record_hash["start_date"]
        if record_hash["start_time"].present?
          record_hash["end_date"] =
            combine(record_hash["start_date"], record_hash["start_time"])
        end
      end
      if record_hash["end_date"].blank? && record_hash["end_time"].blank? && record_hash["start_date"].blank? && record_hash["start_time"].present?
        record_hash["end_date"] = record_hash["start_time"]
      end

      event_to_update.update(record_hash.except("image", "start_time", "end_time"))
      attach_image(event_to_update, record_hash["image"]) if record_hash["image"].present?

      begin
        if event_to_update.save!
          @updated += 1 unless new_event
          @created += 1 if new_event
        else
          stdout_and_log(%(Event record unable to be saved for #{record_hash['title']}))
          @not_saved += 1
        end
      rescue StandardError => e
        stdout_and_log(%(Event id: #{record_hash['id']} -- #{e.message}))
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
