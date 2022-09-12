# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/people", type: :request do
  let(:default_person) { FactoryBot.create(:person, department: "Human Resources") }
  let(:person1) { FactoryBot.create(:person, :with_image) }
  let(:person2) { FactoryBot.create(:person, department: "Sales Representatives") }

  describe "index page renders people by department" do
    it "returns all departments" do
      expect { get people_path.to have_text("Human Resources") }
      expect { get people_path.to have_text("Access Services") }
      expect { get people_path.not_to have_text("Sales Representatives") }
      expect { get sales_reps_path.not_to have_text("Human Resources") }
    end
  end
end
