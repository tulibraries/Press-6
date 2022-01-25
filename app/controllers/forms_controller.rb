# frozen_string_literal: true

class FormsController < ApplicationController
  def new
    @form = Form.new
    if existing_forms.include? params[:type]
      @type = params[:type]
      @books = Book.where(status: show_status).order(:title)
      render template: "forms/create"
    else
      render "errors/not_found", status: :not_found
    end
  end

  def create
    @form = Form.new(params[:form])
    @form.request = request
    @type = params[:form][:form_type]
    @intro = Webpage.find_by(slug: "copy-request-intro") if @type == "copy-request"
    if @form.deliver
      redirect_to root_path(@form), notice: "Thank you for your message. We will contact you soon!"
    else
      flash.now[:error] = "Cannot send message."
      render :new
    end
  end

  def existing_forms
    Dir.glob(Rails.root.join("app/views/forms/*/"))
      .map { |template_path| template_path.split("/").last }
  end
end
