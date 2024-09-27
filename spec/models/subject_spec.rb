# frozen_string_literal: true

require "rails_helper"

RSpec.describe Subject, type: :model do
  describe "associations" do
    it { should have_many(:brochures) }
  end

  it_behaves_like "attachable"
  it_behaves_like "detachable"

  describe ".search(q)" do
    let!(:subject1) { Subject.create!(title: "Ruby on Rails Guide") }
    let!(:subject2) { Subject.create!(title: "PostgreSQL for Beginners") }
    let!(:subject3) { Subject.create!(title: "C++ Programming") }

    it "returns subjects that match the results" do
      results = Subject.search("Rails")
      expect(results).to include(subject1)
      expect(results).not_to include(subject2)
    end

    it "is case insensitive" do
      results = Subject.search("ruby")
      expect(results).to include(subject1)
    end

    it "escapes special regex characters" do
      results = Subject.search("C++")
      expect(results).to include(subject3)
    end
  end
end
