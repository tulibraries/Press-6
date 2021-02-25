# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

# Webpacker 4.2.0 introduced a bug where yarn install runs twice during assets:precompile
# TODO: Remove this when we upgrade webpacker
# Rake::Task["yarn:install"].tap do |t|
#   raise "Consider removing this patch" unless t.prerequisites.include?("webpacker:yarn_install")

#   prerequisites = t.prerequisites - ["webpacker:yarn_install"]
#   t.clear_prerequisites
#   t.enhance(prerequisites) unless prerequisites.empty?
# end
