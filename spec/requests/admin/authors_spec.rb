# frozen_string_literal: true

require "rails_helper"

RSpec.describe Author, type: :request do
  it_behaves_like "renderable_dashboard"
end
