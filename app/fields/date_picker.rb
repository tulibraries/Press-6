# frozen_string_literal: true

require "administrate/field/text"

module Field
  class DatePicker < Administrate::Field::Text
    def ldate(options = {})
      data ? I18n.l(data, **options) : nil
    end
  end
end
