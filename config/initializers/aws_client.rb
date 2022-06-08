# frozen_string_literal: true

require "aws-sdk-s3"

key = Rails.application.credentials.dig(:aws, :access_key_id)
secret = Rails.application.credentials.dig(:aws, :secret_access_key)

Aws.config.update(
  region: "us-east-1",
  credentials: Aws::Credentials.new(key, secret)
)
