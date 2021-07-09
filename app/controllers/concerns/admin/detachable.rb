# frozen_string_literal: true

module Admin
  module Detachable
    extend ActiveSupport::Concern

    def detach
      klass = params[:controller].split("/").last.classify
      @entity = klass.constantize.find(params[:id])

      types = ["cover_image", "excerpt_file", "guide_file", "toc_file", "suggested_reading_image"] if klass == "Book"
      types = ["image"] if ["Brochure", "Series", "Person"].include?(klass)
      types = ["pdf"] if ["Catalog", "SpecialOffer", "Subject"].include?(klass)
      types = ["image", "epub", "mobi", "pdf"] if ["Oabook"].include?(klass)

      type = types.index(params[:field])

      field = types.at(type) if types.include? params[:field]
      @entity.public_send(field).purge

      flash[:notice] = "Uploaded file detached"
      redirect_to url_for(controller: params[:controller], action: :show, id: params[:id], only_path: true)
    end
  end
end
