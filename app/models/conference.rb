class Conference < ApplicationRecord
  validates :title, :start_date, :end_date, :location, :venue, presence: true

end
