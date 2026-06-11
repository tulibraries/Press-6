# frozen_string_literal: true

require "net/http"

class TurnstileService
  VERIFY_URI = URI("https://challenges.cloudflare.com/turnstile/v0/siteverify")

  class << self
    def config
      Rails.configuration.turnstile.with_indifferent_access
    end

    def enabled?
      Flipflop.cloudflare_turnstile?
    end

    def configured?
      enabled? && site_key.present? && secret_key.present?
    end

    def site_key
      config[:sitekey]
    end

    def secret_key
      config[:secret_key]
    end

    def verify(token:, remote_ip:)
      return false unless configured?
      return false if token.blank?

      response = Net::HTTP.post_form(
        VERIFY_URI,
        {
          "secret" => secret_key,
          "response" => token,
          "remoteip" => remote_ip
        }
      )

      JSON.parse(response.body).fetch("success", false)
    rescue JSON::ParserError, StandardError => e
      Rails.logger.warn("Cloudflare Turnstile verification failed: #{e.class} - #{e.message}")
      false
    end
  end
end
