# frozen_string_literal: true

require "rails_helper"

RSpec.describe Conference, type: :request do
  it_behaves_like "renderable_dashboard"
end
