# frozen_string_literal: true

module Admin
  module Detachable
    extend ActiveSupport::Concern

    def detach
      get_models
      klass = params[:controller].split("/").last.classify
      @entity = get_model(klass).friendly.find(params[:id])

      types = %w[cover_image excerpt_file guide_file toc_file suggested_reading_image qa] if klass == "Book"
      types = ["image"] if %w[Event Series Person Highlight NewsItem].include?(klass)
      types = %w[image pdf] if %w[Catalog Brochure].include?(klass)
      types = ["pdf"] if %w[SpecialOffer Subject].include?(klass)
      types = %w[image epub mobi pdf] if ["Oabook"].include?(klass)

      type = types.index(params[:field])
      field = types.at(type) if types.include? params[:field]
      @entity.public_send(field).purge

      flash[:notice] = "Uploaded file detached"
      redirect_to url_for(controller: params[:controller], action: :show, id: params[:id], only_path: true)
    end

    private

      def get_models
        Dir[Rails.root + "app/models/**/*.rb"].each do |path|
          require path
        end
      end

      def get_model(name)
        models ||= ActiveRecord::Base.descendants.reduce({}) { |acc, model|
          acc.merge({ model.name => model })
        }

        models[name]
      end
  end
end
