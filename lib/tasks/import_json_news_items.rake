# frozen_string_literal: true

require "open-uri"
require "resolv-replace"
require "logger"

namespace :import do
  task news_items_json: [:environment] do
    response = HTTParty.get("http://tupress.temple.edu/news_items.json")
    news_items = JSON.parse(response.body)

    @updated = 0
    @not_saved = 0
    @created = 0
    @news_items = 0
    @images = 0
    @pdfs = 0
    @errored = 0
    @log = Logger.new("log/sync-news_items.log")
    @stdout = Logger.new($stdout)

    def attach_image(news_item, path)
      unless news_item.image.attached?
        news_item.image.attach(
          io: URI.open("http://tupress.temple.edu#{path}"),
          filename: path.sub("/uploads/news_item/images/", "")
        )
      end
      @images += 1
    rescue StandardError => e
      stdout_and_log("Syncing NewsItem #{news_item.title}, -- errored --  #{e.message} ")
      @errored += 1
    end

    news_items.each do |news_item|
      news_item_to_update = (
                              NewsItem.find_by(id: news_item["id"]) || NewsItem.new
                            )

      new_news_item = true if news_item_to_update.id.blank?

      record_hash =
        {
          "id" => news_item["id"],
          "title" => news_item["title"],
          "promote_to_homepage" => news_item["homepage"],
          "link" => news_item.fetch("link", "https://tupress.temple.edu"),
          "image" => news_item["image"]["url"],
          "description" => news_item["description"]
        }

      news_item_to_update.update(record_hash.except("image"))
      attach_image(news_item_to_update, record_hash["image"]) if record_hash["image"].present?

      begin
        if news_item_to_update.save!
          @updated += 1 unless new_news_item
          @created += 1 if new_news_item
        else
          stdout_and_log(%(NewsItem record unable to be saved for #{record_hash['title']}))
          @not_saved += 1
        end
      rescue StandardError => e
        stdout_and_log(%(NewsItem id: #{record_hash['id']} -- #{e.message}))
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
