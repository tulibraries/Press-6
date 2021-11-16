# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :get_journals

  def get_journals
    @journals = Journal.all
  end

  def show_status
    ["NP", "IP", "OS", "OP"]
  end
end
