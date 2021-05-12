# frozen_string_literal: true

module Imageable
  extend ActiveSupport::Concern
  # require Rails.root.join("lib/uploads.rb")
  require "logger"



  def index_image(image_field)
    custom_image(image_field, 220, 320)
  end

  def show_image(image_field)
    custom_image(image_field, 470, 120)
  end

  def custom_image(image_field, width, height)
    if ((self.send(image_field.to_sym).blob.metadata[:width] != width) || (self.send(image_field.to_sym).blob.metadata[:height] != height))
      self.send(image_field.to_sym).variant(image_variation(image_field, width, height)).processed
    else
      image
    end if image_field.present?
  end

  def image_variation(image_field, width, height)
    ActiveStorage::Variation.new(resize_to_fill(width: width, height: height, blob: self.send(image_field.to_sym).blob)) if image_field.present?
  end

  def jpeg?(blob)
    blob.content_type.include? "jpeg"
  end

  def optimize
    {
      strip: true
    }
  end

  def optimize_jpeg
    {
      strip: true,
      'sampling-factor': "4:2:0",
      quality: "85",
      interlace: "JPEG",
      colorspace: "sRGB"
    }
  end

  def optimize_hash(blob)
    return optimize_jpeg if jpeg? blob
    optimize
  end

  def resize_to_fill(width:, height:, blob:, gravity: "Center")
    @stdout = Logger.new(STDOUT)
    @log = Logger.new("log/activestorage-debug.log")

    blob.analyze unless blob.analyzed?
    stdout_and_log("metadata: {width: #{blob.metadata[:width]}, height: #{blob.metadata[:height]}}", :info)
    cols = blob.metadata[:width].to_f
    rows = blob.metadata[:height].to_f


    stdout_and_log("metadata: {cols: #{cols}, rows: #{rows}}", :debug)

    if width != cols || height != rows
      scale_x = width / cols
      scale_y = height / rows
      begin
        if scale_x >= scale_y
          cols = (scale_x * (cols + 0.5)).round
          resize = cols.to_s
        else
          rows = (scale_y * (rows + 0.5)).round
          resize = "x#{rows}"
        end
      rescue
        stdout_and_log("\n INFINITY \n")
      end
    end

    stdout_and_log("#{{
      resize: resize,
      gravity: gravity,
      background: "rgba(255,255,255,0.0)",
      extent: cols != width || rows != height ? "#{width}x#{height}" : ""
    }.to_s}\n\n", :debug)

    {
      resize: resize,
      gravity: gravity,
      background: "rgba(255,255,255,0.0)",
      extent: cols != width || rows != height ? "#{width}x#{height}" : ""
    }.merge(optimize_hash(blob))
  end

  def stdout_and_log(message, level)
    @log.send(level, message)
    @stdout.send(level, message)
  end
end
