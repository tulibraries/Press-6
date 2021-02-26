# frozen_string_literal: true

json.extract! special_offer, :id, :created_at, :updated_at
json.url special_offer_url(special_offer, format: :json)
