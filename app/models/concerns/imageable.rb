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
    image = send(image_field.to_sym)
    if image.blob.present?
      if image.blob.metadata[:width] == nil
        image.blob.analyze
      end
      if (image.blob.metadata[:width] != width) || (image.blob.metadata[:height] != height)
        if image.blob.metadata[:width] > image.blob.metadata[:height]
          image.variant(format: :png,
                        background: :transparent,
                        gravity: "North",
                        resize_to_fit: [width, height])
        else
          image.variant(format: :png,
                        background: :transparent,
                        gravity: :center,
                        resize_and_pad: [width,
                                        height])
        end
      else
        image
      end
    end
  end
end
