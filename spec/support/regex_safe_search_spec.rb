# frozen_string_literal: true

def regex_safe_search_factory
  described_class.to_s.underscore.to_sym
end

RSpec.shared_examples "regex-safe search" do
  it "does not raise for unbalanced parentheses in the query" do
    create(regex_safe_search_factory, **search_attributes)

    expect { described_class.search(search_query) }.not_to raise_error
  end
end
