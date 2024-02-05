# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.4"

gem "rails", "~> 7.0.8"
gem "active_storage_validations"
gem "activestorage-validator"
gem "administrate"
gem "administrate-field-date_picker", "~> 0.3.0"
gem "administrate-field-ordered_has_many"
gem "administrate-field-scoped_has_many"
gem "aws-sdk-s3"
gem "binding_of_caller"
gem "cssbundling-rails"
gem "devise"
gem "font-awesome-rails"
gem "font-awesome-sass"
gem "friendly_id"
gem "httparty", ">= 0.21.0"
gem "image_processing", ">= 1.2"
gem "jbuilder"
gem "jsbundling-rails"
gem "json", ">= 2.3.0"
gem "kaminari"
gem "mail", "~> 2.8.1"
gem "mail_form"
gem "meta-tags"
gem "mini_magick"
gem "mysql2", "~> 0.5.5"
gem "nokogiri", "1.16.0"
gem "okcomputer"
gem "omniauth"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"
gem "puma", "~> 6.4.2"
gem "recaptcha", require: "recaptcha/rails"
gem "simple_form"
gem "skylight"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"

group :production do
  gem "dalli"
  gem "connection_pool"
end

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
  gem "better_errors"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "factory_bot_rails"
  gem "orderly"
  gem "rails-controller-testing"
  gem "rspec-activemodel-mocks"
  gem "rspec-rails"
  gem "selenium-webdriver"
  gem "shoulda-matchers", "~> 6.1"
  gem "simplecov"
  gem "simplecov-lcov"
  gem "webdrivers"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

gem "honeybadger", "~> 5.4"
