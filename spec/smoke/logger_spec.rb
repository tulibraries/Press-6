# spec/smoke/logger_spec.rb
require "rails_helper"

RSpec.describe "Logger configuration" do
  it "has a formatter that supports current_tags" do
    expect(Rails.logger.formatter).to respond_to(:current_tags)
    expect(Rails.logger.formatter.current_tags).to eq([])
  end
end

