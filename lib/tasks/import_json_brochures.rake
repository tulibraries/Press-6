# frozen_string_literal: true

require "open-uri"
require "resolv-replace"
require "logger"

namespace :import do
  task brochures_json: [:environment] do
    response = HTTParty.get("http://tupress.temple.edu/brochures.json")
    brochures = JSON.parse(response.body)

    @updated = 0
    @not_saved = 0
    @created = 0
    @brochures = 0
    @images = 0
    @pdfs = 0
    @errored = 0
    @log = Logger.new("log/sync-brochures.log")
    @stdout = Logger.new($stdout)

    def attach_image(brochure, image_path)
      unless brochure.image.attached?
        brochure.image.attach(
          io: URI.open("http://tupress.temple.edu#{image_path}"),
          filename: image_path.sub("/uploads/brochure/images/", "")
        )
      end
      @images += 1
    rescue OpenURI::HTTPError => e
      stdout_and_log("Syncing Brochure #{brochure.id}, image -- errored --  #{e.message} ")
      @errored += 1
    end

    def attach_pdf(brochure, pdf_path)
      unless brochure.image.attached?
        brochure.pdf.attach(
          io: URI.open("http://tupress.temple.edu#{pdf_path}"),
          filename: pdf_path.sub("/uploads/brochures/", "")
        )
      end
      @pdfs += 1
    rescue OpenURI::HTTPError => e
      stdout_and_log(%(Syncing Brochure \"#{brochure.title}\", PDF -- errored --  #{e.message} ))
      @errored += 1
    end

    def assign_brochure(model, id)
      model_class = model.class.to_s.downcase
      join = "#{model.class}Brochure".constantize.new
      begin
        join.update(brochure_id: id, "#{model_class}_id".to_sym => model.id)
        stdout_and_log("Brochure (#{id}) associated with #{model_class}")
      rescue StandardError => e
        stdout_and_log("Brochure (#{id}) unable to be associated with #{model_class}: #{e}")
        @not_saved += 1
      end
    end

    brochures.each do |brochure|
      brochure_to_update = (
                              Brochure.find_by(title: brochure["title"]) || Brochure.new
                            )

      new_brochure = true if brochure_to_update.title.blank?

      record_hash =
        {
          "title" => brochure["title"],
          "subject_code" => brochure["subject_id"],
          "catalog_code" => brochure["catalog_code"],
          "promoted_to_homepage" => brochure["promoted_to_homepage"],
          "pdf" => brochure["pdf"]["url"],
          "image" => brochure["image"]["url"]
        }

      brochure_to_update.assign_attributes(record_hash.except("pdf", "image", "catalog_code", "subject_code"))

      attach_pdf(brochure_to_update, record_hash["pdf"]) if record_hash["pdf"].present?
      attach_image(brochure_to_update, record_hash["image"]) if record_hash["image"].present?

      if brochure_to_update.pdf.present?
        if brochure_to_update.save!
          @updated += 1 unless new_brochure
          @created += 1 if new_brochure

          catalog = Catalog.find_by(code: record_hash["catalog_code"])
          subject = Subject.find_by(code: record_hash["subject_code"])
          assign_brochure(catalog, brochure_to_update.id) if catalog.present?
          assign_brochure(subject, brochure_to_update.id) if subject.present?

        else
          stdout_and_log(%(Brochure record unable to be saved for #{record_hash['title']}))
          @not_saved += 1
        end
      else
        stdout_and_log(%(Brochure record unable to be saved for #{record_hash['title']} -- No PDF))
      end

      stdout_and_log("Syncing completed with #{@updated} updated, #{@created} created, #{@errored} errored, and #{@not_saved} not saved. \n Covers: #{@images}, Excerpts: #{@pdfs}")
    end

    def stdout_and_log(message, level: :info)
      @log.send(level, message)
      @stdout.send(level, message)
    end
  end
end
