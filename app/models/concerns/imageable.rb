# frozen_string_literal: true

module Imageable
  extend ActiveSupport::Concern
  require Rails.root.join("lib/uploads.rb")

  def thumb_image(image_field)
    custom_image(image_field, 160, 220)
  end

  def index_image(image_field)
    custom_image(image_field, 220, 320)
  end

  def show_image(image_field)
    custom_image(image_field, 270, 420)
  end

  def custom_image(image_field, width, height)
    if ((self.send(image_field.to_sym).blob.metadata[:width] != width) || (self.send(image_field.to_sym).blob.metadata[:height] != height))
      self.send(image_field.to_sym).variant(image_variation(image_field, width, height)).processed
    else
      image
    end if image_field.present?
  end

  def image_variation(image_field, width, height)
    ActiveStorage::Variation.new(Uploads.resize_to_fill(width: width, height: height, blob: self.send(image_field.to_sym).blob)) if image_field.present?
  end
end
