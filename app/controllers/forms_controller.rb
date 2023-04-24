# frozen_string_literal: true

class FormsController < ApplicationController
  before_action :html_check, only: :create

  def html_check
    binding.pry
    if params[:form][:comments].present?
      if params[:form][:comments].include? "<"
        flash[:alert] = "HTML markup is not allowed in comments."
        render :create, denied: true
      end
    end
  end

  def new
    @form = Form.new
    if existing_forms.include? params[:type]
      @type = params[:type]
      existing_forms.each do |form|
        @intro = Webpage.find_by(slug: "#{form}-intro") if form == @type
        @footer = Webpage.find_by(slug: "#{form}-footer") if form == @type
      end
      @books = Book.displayable.requestable.order(:sort_title)
      @book = Book.find(params[:id]) if params[:id].present?
      render template: "forms/create"
    else
      render "errors/not_found", status: :not_found
    end
  end

  def create
    @form = Form.new(params[:form])
    @form.request = request
    @type = params[:form][:form_type]

    if verify_recaptcha(model: @form)
      if @form.deliver
        redirect_to root_path(@form), notice: "Thank you for your message. We will contact you soon!"
      else
        redirect_to new_form_path(type: @type), notice: "Cannot send message."
      end
    else
      render :create, form: params[:form]
      flash[:alert] = "Please prove you are human."
    end
  end

  def existing_forms
    Dir.glob(Rails.root.join("app/views/forms/*/"))
       .map { |template_path| template_path.split("/").last }
  end
end
