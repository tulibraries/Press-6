# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "field validators" do
    let(:user) { FactoryBot.build(:user) }
    let(:blank_error) { /Email can't be blank/ }
    let(:invalid_error) { /Email is invalid/ }
    context "Email validation" do
      example "valid email" do
        expect { user.save! }.to_not raise_error
      end
      example "invalid email" do
        user.email = "abc"
        expect { user.save! }.to raise_error(invalid_error)
      end
      example "invalid email - blank " do
        user.email = ""
        expect { user.save! }.to raise_error(blank_error)
      end
    end
  end

  describe "title = email" do
    let(:user) { FactoryBot.create(:user) }

    it "assigns email as title" do
      expect(user.title).to match user.email
    end
  end
end
