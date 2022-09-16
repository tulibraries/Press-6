# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_menu, :script_nonce

  def set_menu
    @journals = Journal.all
    @ordering_information = Webpage.find_by(slug: "ordering-information")
    @submissions = Webpage.find_by(slug: "submissions")
    @about = Webpage.find_by(slug: "about-the-press")
    @about_u_presses = Webpage.find_by(slug: "about-university-presses")
    @payment_terms = Webpage.find_by(slug: "payment-terms")
  end

  def script_nonce
    if Rails.env.production?
      @nonce = SecureRandom.base64(12)
    end
  end
end
