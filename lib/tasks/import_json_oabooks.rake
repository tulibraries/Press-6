# frozen_string_literal: true

require "open-uri"
require "resolv-replace"
require "logger"

namespace :import do
  task oabooks_json: [:environment] do

    response = HTTParty.get("http://localhost:3001/oabooks.json")
    oabooks = JSON.parse(response.body)

    @updated = 0
    @not_saved = 0
    @created = 0
    @oabooks = 0
    @images = 0
    @pdfs = 0
    @errored = 0
    @log = Logger.new("log/sync-oabooks.log")
    @stdout = Logger.new(STDOUT)

    def attach_image(oabook, path)
      begin
        oabook.image.attach(
          io: URI.open("http://tupress.temple.edu#{path}"),
          filename: path.sub("/uploads/oabook/cover_images/", ""),
        ) 
        @images += 1
      rescue => err
        stdout_and_log("Syncing Oabook #{oabook.title}, -- image errored --  #{err.message} ")
        @errored += 1
      end
    end

    def attach_mobi(oabook, path)
      begin
        oabook.mobi.attach(
          io: URI.open("http://tupress.temple.edu#{path}"),
          filename: path.sub("/uploads/oabooks/", ""),
        ) 
        @images += 1
      rescue => err
        stdout_and_log("Syncing Oabook #{oabook.title}, -- mobi errored --  #{err.message} ")
        @errored += 1
      end
    end

    def attach_pdf(oabook, path)
      begin
        oabook.pdf.attach(
          io: URI.open("http://tupress.temple.edu#{path}"),
          filename: path.sub("/uploads/oabooks/", ""),
        ) 
        @images += 1
      rescue => err
        stdout_and_log("Syncing Oabook #{oabook.title}, -- pdf errored --  #{err.message} ")
        @errored += 1
      end
    end

    def attach_epub(oabook, path)
      begin
        oabook.epub.attach(
          io: URI.open("http://tupress.temple.edu#{path}"),
          filename: path.sub("/uploads/oabooks/", ""),
        ) 
        @images += 1
      rescue => err
        stdout_and_log("Syncing Oabook #{oabook.title}, -- epub errored --  #{err.message} ")
        @errored += 1
      end
    end

    oabooks.each do |oabook|

      oabook_to_update = (
                              Oabook.find_by(title: oabook["title"]) ?
                              Oabook.find_by(title: oabook["title"])
                              :
                              Oabook.new
                            )

      new_oabook = true if oabook_to_update.id.blank?

      record_hash =
      {
        "title"                  => oabook.dig("title"),
        "subtitle"               => oabook.dig("subtitle"),
        "author"                 => oabook.dig("author"),
        "edition"                => oabook.dig("edition"),
        "isbn"                   => oabook.dig("isbn"),
        "print_isbn"             => oabook.dig("print_isbn"),
        "description"            => oabook.dig("description"),
        "manifold"                   => oabook.dig("manifold"),
        "collection"             => oabook.dig("collection"),
        "supplemental"           => oabook.dig("supplemental"),
        "pod"                    => oabook.dig("pod"),
        "image"                  => oabook.dig("cover_image")["url"],
        "epub"                   => oabook.dig("epub")["url"],
        "mobi"                   => oabook.dig("mobi")["url"],
        "pdf"                    => oabook.dig("pdf")["url"]
      }

      oabook_to_update.update(record_hash.except("image","epub","mobi","pdf"))
      attach_image(oabook_to_update, record_hash["image"]) if record_hash["image"].present?
      attach_epub(oabook_to_update, record_hash["epub"]) if record_hash["epub"].present?
      attach_pdf(oabook_to_update, record_hash["pdf"]) if record_hash["pdf"].present?
      attach_mobi(oabook_to_update, record_hash["mobi"]) if record_hash["mobi"].present?

      begin
        if oabook_to_update.save!
          @updated += 1 unless new_oabook
          @created += 1 if new_oabook
        else
          stdout_and_log(%Q(Oabook record unable to be saved for #{record_hash["title"]}))
          @not_saved += 1
        end
      rescue => err
        stdout_and_log(%Q(Oabook title: #{record_hash["title"]} -- #{err.message}))
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
