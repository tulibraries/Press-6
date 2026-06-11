# frozen_string_literal: true

class FormsController < ApplicationController
  def new
    @form = (params[:form].present? ? Form.new(params[:form]) : Form.new)
    @notice = flash.now[:notice] if :notice.present?
    if existing_forms.include? params[:type]
      @type = params[:type]
      load_form_page_context
      create if params[:form].present?
    else
      render template: "errors/not_found", status: :not_found
    end
  end

  def create
    @form = Form.new(params[:form])
    @form.request = request
    @type = params[:form][:form_type]
    load_form_page_context

    unless turnstile_verification_passed?
      failure("turnstile")
      return
    end

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
      notice = t("tupress.forms.errors.html")
      flash.now[:notice] = notice
    when "survey"
      notice = t("tupress.forms.errors.survey")
      flash.now[:notice] = notice
    when "mailers"
      notice = t("tupress.forms.errors.mailers")
      flash.now[:notice] = notice
    when "mail"
      notice = t("tupress.forms.errors.smtp")
      flash.now[:notice] = notice
    when "turnstile"
      notice = t("tupress.forms.errors.turnstile")
      flash.now[:notice] = notice
    end
    render :new, notice:
  end

  def existing_forms
    Dir.glob(Rails.root.join("app/views/forms/*/"))
       .map { |template_path| template_path.split("/").last }
  end

  private

    def load_form_page_context
      @intro = Webpage.find_by(slug: "#{@type}-intro")
      @footer = Webpage.find_by(slug: "#{@type}-footer")
      @books = Book.displayable.requestable.order(:sort_title)
      @book = Book.find(params[:id]) if params[:id].present?
      @turnstile_site_key = TurnstileService.site_key if TurnstileService.configured?
    end

    def turnstile_verification_passed?
      return true unless TurnstileService.configured?

      TurnstileService.verify(
        token: params["cf-turnstile-response"],
        remote_ip: request.remote_ip
      )
    end
end
