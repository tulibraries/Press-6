# frozen_string_literal: true

require "open-uri"
require "resolv-replace"
require "logger"

namespace :import do
  task brochures_json: [:environment] do

    response = HTTParty.get("http://localhost:3001/brochures.json")
    brochures = JSON.parse(response.body)

    @updated = 0
    @not_saved = 0
    @created = 0
    @brochures = 0
    @images = 0
    @pdfs = 0
    @errored = 0
    @log = Logger.new("log/sync-brochures.log")
    @stdout = Logger.new(STDOUT)


    def attach_image(brochure, image_path)
      begin
        brochure.image.attach(
          io: URI.open("http://tupress.temple.edu#{image_path}"),
          filename: image_path.sub("/uploads/brochure/images/", ""),
        ) unless brochure.image.attached?
        @images += 1
      rescue OpenURI::HTTPError => err
        stdout_and_log("Syncing Brochure #{brochure.id}, image -- errored --  #{err.message} ")
        @errored += 1
      end
    end

    def attach_pdf(brochure, pdf_path)
      begin
        brochure.pdf.attach(
          io: URI.open("http://tupress.temple.edu#{pdf_path}"),
          filename: pdf_path.sub("/uploads/brochures/", ""),
        ) unless brochure.image.attached?
        @pdfs += 1
      rescue OpenURI::HTTPError => err
        stdout_and_log(%Q(Syncing Brochure \"#{brochure.title}\", PDF -- errored --  #{err.message} ))
        @errored += 1
      end
    end

    def assign_catalog(brochure, code, catalog)
      begin
        ActiveRecord::Base.connection.execute("UPDATE catalogs SET brochure_id = \"#{code}\" WHERE catalogs.id = #{catalog.id};")
      rescue => error
        puts error
        stdout_and_log("Brochure catalog unable to be saved for #{catalog.title}")
        @not_saved += 1
      end
    end

    def assign_subject(brochure, code, subject)
      begin
        ActiveRecord::Base.connection.execute("UPDATE subjects SET brochure_id = \"#{code}\" WHERE subjects.id = #{subject.id};")
      rescue => error
        puts error
        stdout_and_log("Brochure subject unable to be saved for #{brochure.title}")
        @not_saved += 1
      end
    end

    brochures.each do |brochure|

      brochure_to_update = (
                              Brochure.find_by(title: brochure["title"]) ?
                              Brochure.find_by(title: brochure["title"])
                              :
                              Brochure.new
                            )

      new_brochure = true if brochure_to_update.title.blank?

      record_hash =
      {
        "title"                 => brochure.dig("title"),
        "subject_id"            => brochure.dig("subject_id"),
        "catalog_id"            => brochure.dig("catalog_code"),
        "promoted_to_homepage"  => brochure.dig("promoted_to_homepage"),
        "pdf"                   => brochure.dig("pdf")["url"],
        "image"                 => brochure.dig("image")["url"]
      }

      catalog = Catalog.find_by(code: record_hash["catalog_id"])
      subject = Subject.find_by(code: record_hash["subject_id"])

      brochure_to_update.assign_attributes(record_hash.except("pdf", "image", "catalog_id", "subject_id"))

      attach_pdf(brochure_to_update, record_hash["pdf"]) if record_hash["pdf"].present?
      attach_image(brochure_to_update, record_hash["image"]) if record_hash["image"].present?

      if brochure_to_update.pdf.present?
        if brochure_to_update.save!
          assign_catalog(record_hash["catalog_id"], catalog) if record_hash["catalog_id"].present?
          assign_subject(record_hash["subject_id"], subject) if record_hash["subject_id"].present?
          @updated += 1 unless new_brochure
          @created += 1 if new_brochure
        else
          stdout_and_log(%Q(Brochure record unable to be saved for #{record_hash["title"]}))
          @not_saved += 1
        end
      end

      stdout_and_log("Syncing completed with #{@updated} updated, #{@created} created, #{@errored} errored, and #{@not_saved} not saved. \n Covers: #{@images}, Excerpts: #{@pdfs}")

    end

    def stdout_and_log(message, level: :info)
      @log.send(level, message)
      @stdout.send(level, message)
    end

  end
end
