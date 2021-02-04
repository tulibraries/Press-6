# frozen_string_literal: true

if  Rails.configuration.active_storage.service == :amazon
  sts = Aws::STS::Client.new(
    access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
    secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key),
    region: "us-east-1"
  )

  Aws.config.update({
                      credentials: Aws::AssumeRoleCredentials.new(
                        client: sts,
                        role_arn: Rails.application.credentials.dig(:aws, :role_arn),
                        role_session_name: "session-name",
                        region: "us-east-1"
                      ) })
end
