# frozen_string_literal: true

module WebpagesHelper
  def display_image(model, homepage = false)
    if model.image.attached?
      (image_tag model.image, loading: "lazy", "aria-hidden": aria_hidden(model))
    else
      (image_tag "default-book-cover-index.png", loading: "lazy", "aria-hidden": true)
    end
  end

  def hot_cover(book)
    if book.cover_image.attached?
      (image_tag book.custom_image("cover_image", 180, 280), class: "news-image", loading: "lazy")
    else
      (image_tag "default-book-cover-index.png", class: "news-image", loading: "lazy")
    end
  end

  def news_image(model)
    if model.class.to_s == "Event"
      if model.image.attached?
        (image_tag model.image,
                  class: "news-image",
                  loading: "lazy")
      else
        (image_tag "default-book-cover-index.png",
                  class: "news-image",
                  loading: "lazy")
      end
    else
      model.class.to_s == "Book" ? hot_cover(model) : (image_tag model.image, class: "news-image", loading: "lazy")
    end
  end

  def news_link(model, type = nil)
    case model.class.to_s
    when "Book"
      if type == "image"
        (link_to news_image(model), book_path(model))
      else
        (link_to model.title, book_path(model))
      end
    when "NewsItem"
      if type == "image"
        (model.link.present? ? (link_to news_image(model), model.link) : news_image(model))
      else
        (model.link.present? ? (link_to model.title, model.link) : model.title)
      end
    when "Event"
      type == "image" ? (link_to news_image(model), events_path) : (link_to model.title, events_path)
    end
  end

  def news_text(model)
    model.class.to_s == "NewsItem" ? model.description : model.news_text
  end
end
