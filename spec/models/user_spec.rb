# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do

  describe "field validators" do
    let (:user) { FactoryBot.build(:user) }
    let (:email_error) { /Email cant be blank/ }
    context "Email validation" do
      example "valid email" do
        expect { user.save! }.to_not raise_error
      end
      example "invalid email" do
        user.email = "abc"
        # expect { user.save! }.to raise_error(email_error)
      end
      example "invalid email - blank " do
        user.email = ""
        # expect { user.save! }.to raise_error(email_error)
      end
    end
  end

end
