# frozen_string_literal: true

class FormsController < ApplicationController
  before_action :set_form_type, only: [:new, :create]

  def new
    @form = (params[:form].present? ? Form.new(params[:form]) : Form.new)
    @notice = flash.now[:notice] if :notice.present?
    load_form_page_context
  end

  def create
    @form = Form.new(params[:form])
    @form.request = request
    load_form_page_context

    unless turnstile_verification_passed?
      failure("turnstile")
      return
    end

    if params[:form][:comments].present? && (params[:form][:comments].include? "<")
      failure("html")
    elsif params[:form][:survey].present?
      failure("survey")
    elsif params[:form][:add_to_mailing_list] == "1" && params[:form][:remove_from_mailing_list] == "1"
      failure("mailers")
    else
      @form.deliver ? success : failure("mail")
    end
  end

  def success
    redirect_to root_path, notice: "Thank you for your message. We will contact you soon!"
  end

  def failure(mode, status: :ok)
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
    render :new, notice:, status:
  end

  private

    def set_form_type
      form_type = if action_name == "create"
        params[:form][:form_type] if params[:form].is_a?(ActionController::Parameters)
                  else
                    params[:type]
      end
      @type = Form::TYPES.find { |type| type == form_type }

      render template: "errors/not_found", status: :not_found if @type.nil?
    end

    def load_form_page_context
      @intro = Webpage.find_by(slug: "#{@type}-intro")
      @footer = Webpage.find_by(slug: "#{@type}-footer")
      @books = Book.displayable.requestable.order(:sort_title)
      @book = Book.find(params.expect(:id)) if params[:id].present?
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
