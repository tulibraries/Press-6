# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.4"

gem "rails", "~> 6.1.4"
gem "mysql2", "~> 0.5.3"
gem "puma", "~> 4.1"
gem "webpacker", "~> 5.0"
gem "turbolinks", "~> 5"
gem "jbuilder", "~> 2.7"
gem "json", ">= 2.3.0"
gem "image_processing", "~> 1.2"
gem "mini_magick"
gem "administrate", ">= 0.16.0"
gem "administrate-field-scoped_has_many"
gem "administrate-field-ordered_has_many"
gem "nokogiri", "1.11.4"
gem "pry"
gem "listen", "~> 3.2"
gem "jquery-rails"
gem "bootstrap"
gem "bootsnap", ">= 1.4.2", require: false
gem "aws-sdk-s3", require: false
gem "active_storage_validations"
gem "kaminari"
gem "administrate-field-date_picker", "~> 0.2.0"
gem "meta-tags"
gem "activestorage-validator"

gem "devise"
gem "omniauth"
gem "omniauth-google-oauth2"

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "pry-rails"
  gem "pry-byebug"
  gem "rspec-activemodel-mocks"
  gem "rspec-rails", "~> 4.0.1"
end

group :development do
  gem "web-console", ">= 3.3.0"
  gem "brakeman"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "factory_bot_rails"
  gem "rails-controller-testing"
  gem "simplecov"
  gem "simplecov-lcov"
  gem "shoulda-matchers", "~> 4.0"
  gem "orderly"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
