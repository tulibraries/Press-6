# frozen_string_literal: true

require "aws-sdk-s3"

key = (ENV["AWS_ENV"] == "prod") ?
  Rails.application.credentials.dig(:aws, :prod_access_key_id)
  :
  Rails.application.credentials.dig(:aws, :dev_access_key_id)

secret = Rails.application.credentials.dig(:aws, :secret_access_key)

Aws.config.update(
  region: "us-east-1",
  credentials: Aws::Credentials.new(key, secret)
)
