# frozen_string_literal: true

module SetInstance
  extend ActiveSupport::Concern
  def find_instance
    model = controller_name.classify.constantize
    unless params[:id].nil?
      case model       
        when Book
          model.find_by(xml_id: params[:id])
        when Author
          model.find_by(author_id: params[:id])
        when Catalog || Series || Subject
          model.find_by(code: params[:id])
        else
          model.friendly.find(params[:id])
      end
    else
      raise ActionController::RoutingError.new("Not Found")
    end
  end
end
