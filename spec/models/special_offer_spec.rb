# frozen_string_literal: true

require "rails_helper"

RSpec.describe SpecialOffer, type: :model do

  it_behaves_like "attachable"
  it_behaves_like "detachable"

end
