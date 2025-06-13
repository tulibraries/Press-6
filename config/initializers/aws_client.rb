# frozen_string_literal: true

require "aws-sdk-s3"

env_key = ENV["AWS_ENV"] == "prod" ? :prod_access_key_id : :dev_access_key_id

key = Rails.application.credentials.dig(:aws, env_key)
secret = Rails.application.credentials.dig(:aws, :secret_access_key)

Aws.config.update(
  region: "us-east-1",
  credentials: Aws::Credentials.new(key, secret)
)