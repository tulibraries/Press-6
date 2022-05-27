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
    send(image_field.to_sym).blob.analyze
    if (send(image_field.to_sym).blob.metadata[:width] != width) || (send(image_field.to_sym).blob.metadata[:height] != height)
      if send(image_field.to_sym).blob.metadata[:width] > send(image_field.to_sym).blob.metadata[:height]
        send(image_field.to_sym).variant(format: :png,
                                         background: :transparent,
                                         gravity: "North",
                                         resize_to_fit: [width, height]).processed
      else
        send(image_field.to_sym).variant(format: :png,
                                         background: :transparent,
                                         gravity: :center,
                                         resize_and_pad: [width,
                                                          height]).processed
      end
    else
      send(image_field.to_sym)
    end
  end
end
