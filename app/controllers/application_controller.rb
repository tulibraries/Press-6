# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_menu

  def show_status
    ["NP", "IP", "OP"]
  end

  def set_menu
    @journals = Journal.all
    @ordering_information = Webpage.friendly.find("ordering-information")
    @submissions = Webpage.friendly.find("submissions")
    @about = Webpage.friendly.find("about-the-press")
    @about_u_presses = Webpage.friendly.find("about-university-presses")
    @payment_terms = Webpage.friendly.find("payment-terms")
  end
end
