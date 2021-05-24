# frozen_string_literal: true

class ConferencesController < ApplicationController
  def index
    @conferences = Conference.all
  end
end
