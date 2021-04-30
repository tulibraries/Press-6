# frozen_string_literal: true

require "simplecov-lcov"

SimpleCov::Formatter::LcovFormatter.config do |c|
  c.report_with_single_file = true
  c.single_report_path = "coverage/lcov/app.lcov"
end

SimpleCov.formatter = SimpleCov::Formatter::LcovFormatter

SimpleCov.start("rails") do
  add_filter "app/channels"
end
