# frozen_string_literal: true

module WebpagesHelper
  def display_image(model)
    model.image.attached? ?
      (image_tag model.image)
      :
      (image_pack_tag "see-also-default.gif", style: "height: 180px;")
  end
end
