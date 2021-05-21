# frozen_string_literal: true

require "rails_helper"

RSpec.describe Webpage, type: :model do
  # webpage = FactoryBot.build(:webpage, body: ActionText::Content.new("Hello World"))
  describe 'validations' do
    it { should validate_presence_of(:title) }
    xit { should validate_presence_of(:body) }
  end
end
