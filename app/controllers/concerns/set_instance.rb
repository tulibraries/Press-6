# frozen_string_literal: true

module SetInstance
  extend ActiveSupport::Concern
  def find_instance
    model = controller_name.classify.constantize
    model_name = model.to_s
    unless params[:id].nil?
      case model_name
      when "Book"
        is_number?(params[:id]) ?
          instance = model.find_by(xml_id: params[:id])
          :
          instance = model.friendly.find(params[:id])
      when "Series"
        params[:id][0, 2] == "S-" ?
          instance = model.find_by(code: params[:id])
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
