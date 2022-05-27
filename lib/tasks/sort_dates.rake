# frozen_string_literal: true

require "logger"

namespace :update do
  task sort_dates: [:environment] do
    @log = Logger.new("log/sort-dates.log")
    @stdout = Logger.new($stdout)
    stdout_and_log("Adds sortable date fields to books.")

    Book.all.each do |m|
      stdout_and_log("starting: title: #{m.title}")
      m.save!
      stdout_and_log("Saved: title: #{m.title}, sort_title: #{m.sort_title}, slug: #{m.slug}")
    end
  end
end

def stdout_and_log(message, level: :info)
  @log.send(level, message)
  @stdout.send(level, message)
end
