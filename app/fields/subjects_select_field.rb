# frozen_string_literal: true

require "administrate/field/base"

class SubjectsSelectField < Administrate::Field::Base
  def to_s
    data
  end
end
