# frozen_string_literal: true

require "rails_helper"

RSpec.describe OabooksHelper, type: :helper do
  describe "string concat" do
    it "concats localized purchase link with isbn" do
      expect(helper.purchase_link("123456789")).to eq("#{t('tupress.books.purchase_link')}123456789")
    end
  end
end
