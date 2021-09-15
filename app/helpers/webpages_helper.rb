# frozen_string_literal: true

module WebpagesHelper
  def catalog_image(catalog)
    catalog.image.attached? ?
      (image_tag catalog.image.attachment)
      :
      (image_pack_tag "see-also-default.gif", style: "height: 180px;")
  end
end
