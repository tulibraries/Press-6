# frozen_string_literal: true

module SetInstance
  extend ActiveSupport::Concern
  def find_instance
    model = controller_name.classify.constantize
    model_name = model.to_s
    if params[:id].nil?
      raise ActionController::RoutingError, "Not Found"
    else
      instance = case model_name
                 when "Book"
                   is_number?(params[:id]) ? redirect_to(Book.find_by(xml_id: params[:id])) : model.friendly.find(params[:id])
                 when "Series"
                   params[:id][0, 2] == "S-" ? model.find_by(code: params[:id]) : model.friendly.find(params[:id])
                 else
                   model.friendly.find(params[:id])
      end
    end
  end

  def is_number?(string)
    true if Float(string)
  rescue StandardError
    false
  end
end
