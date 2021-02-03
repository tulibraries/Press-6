# frozen_string_literal: true

class Agency < ApplicationRecord
  validates :title, :contact, :address1, :country, :city, :region, presence: true
end
