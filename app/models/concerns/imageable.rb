# frozen_string_literal: true

module Imageable
  extend ActiveSupport::Concern
  require Rails.root.join("lib/uploads.rb")

  def index_image
    custom_image(220, 220)
  end

  def index_image_path
    entity_image_path("medium")
  end

  def index_image_url
    entity_image_url("medium")
  end

  def thumb_image
    custom_image(120, 120)
  end

  def thumb_image_path
    entity_image_path("thumbnail")
  end

  def thumb_image_url
    entity_image_url("thumbnail")
  end

  def show_image
    custom_image(250, 380)
  end

  def show_image_path
    entity_image_path("large")
  end

  def show_image_url
    entity_image_url("large")
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

  def entity_image_path(type)
    Rails.application.routes.url_helpers.send("#{self.class.to_s.underscore}_cover_image_#{type}_path", to_param)
  end

  def entity_image_url(type)
    Rails.application.routes.url_helpers.send("#{self.class.to_s.underscore}_cover_image_#{type}_url", to_param)
  end
end
