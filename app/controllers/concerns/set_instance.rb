# frozen_string_literal: true

module SetInstance
  extend ActiveSupport::Concern
  def find_instance
    model = controller_name.classify.constantize
    model_name = model.to_s
    if params[:id].nil?
      raise(ActionController::RoutingError.new("Not Found"))
    else
      case model_name
      when "Book"
        if is_number?(params[:id])
          book = Book.find_by(xml_id: params[:id])
          if book.present?
            return redirect_to(book)
          else
            raise(ActionController::RoutingError.new("Not Found"))
          end
        else
          model.friendly.find(params[:id])
        end
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
