# frozen_string_literal: true

require "rails_helper"

RSpec.describe Subject, type: :model do
  
  it_behaves_like "attachable"
  it_behaves_like "detachable"

end
