# frozen_string_literal: true

module Admin
  module Detachable
    extend ActiveSupport::Concern

    def detach
      klass = params[:controller].split("/").last.classify
      @entity = klass.constantize.find(params[:id])
      if klass == "Book"
        types = ["cover_image","excerpt_image","guide_image","suggested_reading_image"]
        type = types.index(params[:field])
        field = types.at(type) if types.include? params[:field]
        @entity.public_send(field).purge
      end
      flash[:notice] = "Image detached"
      redirect_to url_for(controller: params[:controller], action: :show, id: params[:id], only_path: true)
    end

  end
end
