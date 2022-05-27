# frozen_string_literal: true

require "logger"

namespace :update do
  task slugs: [:environment] do
    @log = Logger.new("log/slug-fest.log")
    @stdout = Logger.new($stdout)
    stdout_and_log("Updating model slugs.")

    models = [Agency, Author, Book, Brochure, Catalog, Conference, Document, Event, Highlight, Journal, NewsItem,
              Oabook, Series, SpecialOffer, Subject, Webpage]

    models.each do |model|
      model.all.each do |m|
        m.save!
        stdout_and_log("Saved: #{model}, id: #{m.id}, slug: #{m.slug}")
      end
    end
  end
end

def stdout_and_log(message, level: :info)
  @log.send(level, message)
  @stdout.send(level, message)
end
