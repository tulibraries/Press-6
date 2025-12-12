# frozen_string_literal: true

FactoryBot.define do
  factory :region do
    sequence(:name) { |n| "Region #{n}" }
    description { "A test region description" }
    rights_designation { :unspecified }

    trait :with_agencies do
      after(:create) do |region|
        create_list(:agency, 2, region: region.name)
      end
    end

    trait :with_people do
      after(:create) do |region|
        create_list(:person, 2, region: region.name, is_rep: true)
      end
    end
  end
end
