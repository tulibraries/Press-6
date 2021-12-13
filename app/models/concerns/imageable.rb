# frozen_string_literal: true

module Imageable
  extend ActiveSupport::Concern

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
    the_image = self.send(image_field.to_sym)
    if (the_image.blob.metadata[:width] != width) || (the_image.blob.metadata[:height] != height)
      if the_image.blob.metadata[:width] > the_image.blob.metadata[:height]
        the_image.variant(format: :png,
                      background: :transparent,
                      gravity: "North",
                      resize_to_fit: [width, height]
                    ).processed
      else
        the_image.variant(format: :png,
          background: :transparent,
          gravity: :center,
          resize_and_pad: [width, height]
        ).processed
      end
    else
      the_image
    end
  end
end
