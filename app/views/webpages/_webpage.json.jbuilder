# frozen_string_literal: true

json.extract! webpage, :id, :created_at, :updated_at
json.url webpage_url(webpage, format: :json)
