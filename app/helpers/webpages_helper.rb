# frozen_string_literal: true

module WebpagesHelper
  def display_image(model, homepage = false)
    model.image.attached? ?
      (image_tag model.image)
      :
      ((image_pack_tag "default-book-cover-index.png") if homepage.present?)
  end

  def news_image(model)
    unless model.class.to_s == "Event"
      model.class.to_s == "Book" ? hot_cover(model) : (image_tag model.image, class: "news-image")
    else
      model.image.attached? ? (image_tag model.image, class: "news-image") : (image_pack_tag "default-book-cover-index.png", class: "news-image")
    end
  end

  def news_link(model, type = nil)
    case model.class.to_s
    when "Book"
      type == "image" ?
        (link_to news_image(model), book_path(model))
        :
        (link_to model.title, book_path(model))
    when "NewsItem"
      type == "image" ? (model.link.present? ? (link_to news_image(model), model.link) : (news_image(model))) :
                        (model.link.present? ? (link_to model.title, model.link) : (model.title))
    when "Event"
      type == "image" ? (link_to news_image(model), events_path) : (link_to model.title, events_path)
    end
  end

  def news_text(model)
    model.class.to_s == "NewsItem" ? model.description : model.news_text
  end
end
