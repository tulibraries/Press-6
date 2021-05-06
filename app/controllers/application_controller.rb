# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :get_journals

  def get_journals
    @journals = Journal.all
  end
end
