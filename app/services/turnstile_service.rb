# frozen_string_literal: true

require "json"
require "net/http"

class TurnstileService
  VERIFY_URI = URI("https://challenges.cloudflare.com/turnstile/v0/siteverify")

  class << self
    def configured?
      Flipflop.cloudflare_turnstile? && site_key.present? && secret_key.present?
    end

    def site_key
      config[:site_key]
    end

    def verify(token:, remote_ip:)
      return true unless configured?
      return false if token.blank?

      response = Net::HTTP.post_form(VERIFY_URI, {
        "secret" => secret_key,
        "response" => token,
        "remoteip" => remote_ip
      })

      JSON.parse(response.body).fetch("success", false)
    rescue StandardError => error
      Rails.logger.warn("Turnstile verification failed: #{error.class}: #{error.message}")
      false
    end

    private

      def config
        Rails.configuration.turnstile || {}
      end

      def secret_key
        config[:secret_key]
      end
  end
end
