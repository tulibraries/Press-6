# frozen_string_literal: true

require "open-uri"
require "resolv-replace"
require "logger"

namespace :import do
  task oabooks_json: [:environment] do
    response = HTTParty.get("http://tupress.temple.edu/oabooks.json")
    oabooks = JSON.parse(response.body)

    @updated = 0
    @not_saved = 0
    @created = 0
    @oabooks = 0
    @images = 0
    @pdfs = 0
    @errored = 0
    @log = Logger.new("log/sync-oabooks.log")
    @stdout = Logger.new($stdout)

    def attach_image(oabook, path)
      oabook.image.attach(
        io: URI.open("http://tupress.temple.edu#{path}"),
        filename: path.sub("/uploads/oabook/cover_images/", "")
      )
      @images += 1
    rescue StandardError => e
      stdout_and_log("Syncing Oabook #{oabook.title}, -- image errored --  #{e.message} ")
      @errored += 1
    end

    def attach_mobi(oabook, path)
      oabook.mobi.attach(
        io: URI.open("http://tupress.temple.edu#{path}"),
        filename: path.sub("/uploads/oabooks/", "")
      )
      @images += 1
    rescue StandardError => e
      stdout_and_log("Syncing Oabook #{oabook.title}, -- mobi errored --  #{e.message} ")
      @errored += 1
    end

    def attach_pdf(oabook, path)
      oabook.pdf.attach(
        io: URI.open("http://tupress.temple.edu#{path}"),
        filename: path.sub("/uploads/oabooks/", "")
      )
      @images += 1
    rescue StandardError => e
      stdout_and_log("Syncing Oabook #{oabook.title}, -- pdf errored --  #{e.message} ")
      @errored += 1
    end

    def attach_epub(oabook, path)
      oabook.epub.attach(
        io: URI.open("http://tupress.temple.edu#{path}"),
        filename: path.sub("/uploads/oabooks/", "")
      )
      @images += 1
    rescue StandardError => e
      stdout_and_log("Syncing Oabook #{oabook.title}, -- epub errored --  #{e.message} ")
      @errored += 1
    end

    oabooks.each do |oabook|
      oabook_to_update = (
                              Oabook.find_by(title: oabook["title"]) || Oabook.new
                            )

      new_oabook = true if oabook_to_update.title.blank?

      record_hash =
        {
          "title" => oabook["title"],
          "subtitle" => oabook["subtitle"],
          "author" => oabook["author"],
          "edition" => oabook["edition"],
          "isbn" => oabook["isbn"],
          "print_isbn" => oabook["print_isbn"],
          "description" => oabook["description"],
          "manifold" => oabook["manifold"],
          "collection" => oabook["collection"],
          "supplemental" => oabook["supplemental"],
          "pod" => oabook["pod"],
          "image" => oabook["cover_image"]["url"],
          "epub" => oabook["epub"]["url"],
          "mobi" => oabook["mobi"]["url"],
          "pdf" => oabook["pdf"]["url"]
        }

      record_hash["collection"] = "Labor Studies & Work" if record_hash["collection"] == "Labor Studies"

      oabook_to_update.update(record_hash.except("image", "epub", "mobi", "pdf"))
      attach_image(oabook_to_update, record_hash["image"]) if record_hash["image"].present?
      attach_epub(oabook_to_update, record_hash["epub"]) if record_hash["epub"].present?
      attach_pdf(oabook_to_update, record_hash["pdf"]) if record_hash["pdf"].present?
      attach_mobi(oabook_to_update, record_hash["mobi"]) if record_hash["mobi"].present?

      begin
        if oabook_to_update.save!
          @updated += 1 unless new_oabook
          @created += 1 if new_oabook
        else
          stdout_and_log(%(Oabook record unable to be saved for #{record_hash['title']}))
          @not_saved += 1
        end
      rescue StandardError => e
        stdout_and_log(%(Oabook title: #{record_hash['title']} -- #{e.message}))
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
