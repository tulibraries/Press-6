# frozen_string_literal: true

class SubjectBrochure < ApplicationRecord
  belongs_to :brochure
  belongs_to :subject
end
