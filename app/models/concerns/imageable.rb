# frozen_string_literal: true

module Imageable
  extend ActiveSupport::Concern
  require Rails.root.join("lib/uploads.rb")

  def index_image
    custom_image(220, 320)
  end

  def thumb_image
    custom_image(120, 120)
  end

  def show_image
    custom_image(270, 420)
  end

  def custom_image(width, height)
    if ((cover_image.blob.metadata[:width] != width) ||
        (cover_image.blob.metadata[:height] != height))
      cover_image.variant(image_variation(width, height)).processed
    else
      image
    end
  end

  def image_variation(width, height)
    ActiveStorage::Variation.new(Uploads.resize_to_fill(width: width, height: height, blob: cover_image.blob))
  end
end
