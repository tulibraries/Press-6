# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.3"

gem "rails", "~> 7.0.3.1"
gem "active_storage_validations"
gem "activestorage-validator"
gem "administrate", ">= 0.18.0"
gem "administrate-field-date_picker", "~> 0.3.0"
gem "administrate-field-ordered_has_many"
gem "administrate-field-scoped_has_many"
gem "aws-sdk-s3"
gem "cssbundling-rails"
gem "devise"
gem "font-awesome-rails"
gem "font-awesome-sass"
gem "friendly_id"
gem "httparty"
gem "image_processing", ">= 1.2"
gem "jbuilder"
gem "jsbundling-rails"
gem "json", ">= 2.3.0"
gem "kaminari"
gem "mail_form"
gem "meta-tags"
gem "mini_magick"
gem "mysql2", "~> 0.5.4"
gem "nokogiri", "1.13.9"
gem "okcomputer"
gem "omniauth"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"
gem "puma", "~> 5.6.5"
gem "simple_form"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "pry"
  gem "pry-byebug"
  gem "pry-rails"
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
end

group :development do
  gem "brakeman"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.1.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "factory_bot_rails"
  gem "orderly"
  gem "rails-controller-testing"
  gem "rspec-activemodel-mocks"
  gem "rspec-rails"
  gem "selenium-webdriver"
  gem "shoulda-matchers", "~> 5.2"
  gem "simplecov"
  gem "simplecov-lcov"
  gem "webdrivers"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
