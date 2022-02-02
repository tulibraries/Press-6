# frozen_string_literal: true

require "logger"

namespace :update do
  task sort_titles: [:environment] do

    @log = Logger.new("log/sort-titles.log")
    @stdout = Logger.new(STDOUT)
    stdout_and_log("Updating book sort titles.")

    Book.all.each do |m|
      m.slug = ""
      m.save!
      stdout_and_log("Saved: title: #{m.title}, sort_title: #{m.sort_title}, slug: #{m.slug}")
    end

  end
end

def stdout_and_log(message, level: :info)
  @log.send(level, message)
  @stdout.send(level, message)
end
