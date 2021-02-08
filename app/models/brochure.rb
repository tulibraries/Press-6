class Brochure < ApplicationRecord
    validates :title, presence: true

    has_one_attached :image, dependent: :destroy
end
