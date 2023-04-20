# frozen_string_literal: true

Recaptcha.configure do |config|
  config.site_key = ENV["TUPRESS_RECAPTCHA_SITE_KEY"]
  config.secret_key = ENV["TUPRESS_RECAPTCHA_SECRET_KEY"]
end
