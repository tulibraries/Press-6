# frozen_string_literal: true

class FormsController < ApplicationController
  def new
    @form = (params[:form].present? ? Form.new(params[:form]) : Form.new)
    @notice = flash.now[:notice] if :notice.present?
    if existing_forms.include? params[:type]
      @type = params[:type]
      existing_forms.each do |form|
        @intro = Webpage.find_by(slug: "#{form}-intro") if form == @type
        @footer = Webpage.find_by(slug: "#{form}-footer") if form == @type
      end
      @books = Book.displayable.requestable.order(:sort_title)
      @book = Book.find(params[:id]) if params[:id].present?
      create if params[:form].present?
    else
      render "errors/not_found", status: :not_found
    end
  end

  def create
    @form = Form.new(params[:form])
    @form.request = request
    @type = params[:form][:form_type]
    @books = Book.displayable.requestable.order(:sort_title)

    if params[:form][:comments].present? && (params[:form][:comments].include? "<")
      failure("html")
    elsif params[:form][:survey].present?
      failure("survey")
    elsif params[:form][:add_to_mailing_list].present? && params[:form][:remove_from_mailing_list].present?
      failure("mailers")
    else
      @form.deliver ? success : failure("mail")
    end
  end

  def success
    redirect_to root_path, notice: "Thank you for your message. We will contact you soon!"
  end

  def failure(mode)
    case mode
    when "html"
      notice = "HTML markup is not allowed in comments."
      flash.now[:notice] = notice
    when "survey"
      notice = "Please check indicated fields for errors."
      flash.now[:notice] = notice
    when "mailers"
      notice = "Please check mailing options for errors."
      flash.now[:notice] = notice
    when "mail"
      notice = "Unable to send form."
      flash.now[:notice] = notice
    end
    render :new, notice:
  end

  def existing_forms
    Dir.glob(Rails.root.join("app/views/forms/*/"))
       .map { |template_path| template_path.split("/").last }
  end
end
