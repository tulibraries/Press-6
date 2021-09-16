# frozen_string_literal: true

module WebpagesHelper
  def display_image(model)
    model.image.attached? ?
      (image_tag model.image)
      :
      (image_pack_tag "default-book-cover-index.png")
  end

  def news_image(model)
    unless model.class.to_s == "Event"
      model.class.to_s == "Book" ? hot_cover(model) : (image_tag model.image)
    else
      image_pack_tag "default-book-cover-index.png"
    end
  end

  def news_link(model)
    case model.class.to_s
    when "Book"
      link_to model.title, book_path(model.xml_id)
    when "NewsItem"
      link_to model.title, model.link
    when "Event"
      link_to model.title, event_path(model)
    end
  end

  def news_text(model)
    model.class.to_s == "NewsItem" ? model.description : model.news_text
  end
end
