# frozen_string_literal: true

module SetInstance
  extend ActiveSupport::Concern
  def find_instance
    model = controller_name.classify.constantize
    model_name = model.to_s
    unless params[:id].nil?
      if model_name == "Book"
        is_number?(params[:id]) ?
          instance = model.find_by(xml_id: params[:id])
          :
          instance = model.friendly.find(params[:id])
      else
        instance = model.friendly.find(params[:id])
      end
    else
      raise ActionController::RoutingError.new("Not Found")
    end
  end

  def is_number?(string)
    true if Float(string) rescue false
  end
end
