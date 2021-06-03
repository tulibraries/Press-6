# frozen_string_literal: true

require "rails_helper"

RSpec.describe Oabook, type: :feature do
  let(:oabook) { FactoryBot.create(:oabook) }

  it "has a cover image" do
    expect { oabook.image.to be_attached }
  end

  it "has a pdf file" do
    expect { oabook.pdf.to be_attached }
  end

  it "has a mobi file" do
    expect { oabook.epub.to be_attached }
  end

  it "has an epub file" do
    expect { oabook.mobi.to be_attached }
  end
end
