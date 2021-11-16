# frozen_string_literal: true

class SpecialOfferBook < ApplicationRecord
  belongs_to :special_offer
  belongs_to :book
end
