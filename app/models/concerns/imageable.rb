# frozen_string_literal: true

module Imageable
  extend ActiveSupport::Concern

  ALLOWED_IMAGE_TYPES = %w[image/png image/jpg image/jpeg image/gif].freeze
  IMAGE_SIZE_RANGE = 1..5.megabytes

  def thumb_image(image_field)
    custom_image(image_field, 160, 220)
  end

  def index_image(image_field)
    custom_image(image_field, 250, 350)
  end

  def show_image(image_field)
    custom_image(image_field, 271, 421)
  end

  def custom_image(image_field, width, height)
    image = send(image_field.to_sym)
    image.analyze unless image.analyzed

    image_width = image.metadata[:width].to_i
    image_height = image.metadata[:height].to_i

    if (image_width != width) || (image_height != height)
      if image_width > image_height
        image.variant(format: :png,
                      background: :transparent,
                      gravity: "North",
                      resize_to_fit: [width, height]).processed
        else
          image.variant(format: :png,
                        background: :transparent,
                        gravity: :center,
                        resize_and_pad: [width,
                                        height]).processed
      end
    else
      image
    end
  end
end
